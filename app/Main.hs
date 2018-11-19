module Main where

import Faketoshi
import Control.Monad.IO.Class (liftIO)

main :: IO ()
main = do
    let xCoord = "678afdb0fe5548271967f1a67130b7105cd6a828e03909a67962e0ea1f61deb6" -- xCoord from Genesis Block Pubkey
    let yCoord = "49f6bc3f4cef38c4f35504e51ec112de5c384df7ba0b8d578a4c702b6bf11d5f" -- yCoord from Genesis Block Pubkey
    Just forgery <- liftIO $ generate_forgery xCoord yCoord
    if valid_forgery forgery then
        putStrLn $ show forgery
    else
        putStrLn "Couldn't make you Satoshi - sorry"
    

