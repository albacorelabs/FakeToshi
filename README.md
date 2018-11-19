# Faketoshi


With everyone seemingly trying to prove they are Satoshi (looking at you [Craig Wright](https://en.bitcoin.it/wiki/Craig_Wright) and the recent["faketoshi twitter"](https://archive.fo/Br5Tl)), we've decided to make it easier for other people to make similar claims.

Credit to Greg Maxwell and Pieter Wuille whose various posts (
[here](https://www.reddit.com/r/btc/comments/9xpivk/satoshi_i_do_not_want_to_be_public_but_there_is/e9uo87m/), 
[here](https://twitter.com/pwuille/status/1063582706288586752), and 
[here](https://bitcoin.stackexchange.com/questions/81115/if-someone-wanted-to-pretend-to-be-satoshi-by-posting-a-fake-signature-to-defrau) 
) gave us enough of an understanding to implement our own Faketoshi-forger. We encourage you to check these resources out to understand why these continued Satoshi claims are nothing more than frauds.

The following implementation creates a signature (s) from a message hash (H(m)) that will validate against the public key from the genesis block. (Although it can easily be extended for **any Satoshi public key**). The trick is that the message (m), the pre-image of the message hash, itself cannot be known or derived. Thus this, and the other claims using the construction, is an existensial forgery.

You can browse to https://albacore.io/faketoshi for an generator in js that uses a similar construction.

### How to use
```
git clone ""
stack build  
stack exec Faketoshi-exe

/* Optional */
Post output on twitter claiming to be Satoshi
```