{-# LANGUAGE RecordWildCards #-}

module Faketoshi (valid_forgery,generate_forgery,Faketoshi_Credentials) where

import Numeric
import Crypto.PubKey.ECC.Prim
import Crypto.PubKey.ECC.Types
import Crypto.PubKey.ECC.ECDSA
import Crypto.Number.ModArithmetic
import Crypto.Number.Generate
import Crypto.Random.Types


data Faketoshi_Credentials = Faketoshi_Credentials {
    sig :: Signature,
    msg :: Integer,
    pubKey :: PublicKey
}

instance Show Faketoshi_Credentials where
    show (Faketoshi_Credentials s m p) = "Sigs: " ++ show s ++ "\nMsg Hash: " ++ show m ++ "\nPublic Key: " ++ show (public_q p)

valid_forgery :: Faketoshi_Credentials -> Bool
valid_forgery Faketoshi_Credentials{..} = hashless_verify pubKey sig msg

-- Copied from Cryptonite ECDSA (https://hackage.haskell.org/package/cryptonite) just removing the hashing of the message
hashless_verify :: PublicKey -> Signature -> Integer -> Bool
hashless_verify (PublicKey _ PointO) _ _ = False
hashless_verify pk@(PublicKey curve q) (Signature r s) msg
    | r < 1 || r >= n || s < 1 || s >= n = False
    | otherwise = maybe False (r ==) $ do
        w <- inverse s n
        let z  = msg -- removed hash here or we ACTUALLY have to know the preimage of the forged hash
            u1 = z * w `mod` n
            u2 = r * w `mod` n
            x  = pointAddTwoMuls curve u1 g u2 q
        case x of
                PointO     -> Nothing
                Point x1 _ -> return $ x1 `mod` n
    where 
        n = ecc_n cc
        g = ecc_g cc
        cc = common_curve $ public_curve pk

generate_forgery :: MonadRandom m => String -> String -> m (Maybe Faketoshi_Credentials)
generate_forgery x_coord y_coord = do
    let crv = getCurveByName SEC_p256k1
    let ((x_int,_):_) = readHex x_coord
    let ((y_int,_):_) = readHex y_coord 
    let public_point = Point (x_int :: Integer) (y_int :: Integer)
    let curve_order = ((ecc_n . common_curve) crv)
    a <- generateMax ((ecc_n . common_curve) crv)
    b <- generateMax ((ecc_n . common_curve) crv)
    case inverse b curve_order of
        Just invB -> do
            let (Point rx _) = pointAdd crv (pointBaseMul crv a) (pointMul crv b public_point)

            let sig = Signature rx ((rx * invB) `mod` curve_order)
            let msg = (rx * a * invB) `mod` curve_order
            return $ Just $ Faketoshi_Credentials sig msg (PublicKey crv public_point)
        Nothing -> return Nothing


