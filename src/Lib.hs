{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( startApp
    ) where

--import qualified Network.Wai as Wai
--import qualified Network.Wai.Handler.Warp as Warp
--import Servant ((:<|>)( .. ), (:>))
--import qualified Servant as S
--import qualified Database.PostgreSQL.Simple as PGS

--import Api.User
--import Api.BlogPost

--type API = "users" :> UserAPI
      -- :<|> "posts" :> BlogPostAPI

--startApp :: IO ()
--startApp = do
    --con <- PGS.connect PGS.defaultConnectInfo
        --{ PGS.connectUser = "postgres"
        --, PGS.connectPassword = "postgres"
        --, PGS.connectDatabase = "opaleye"
        --}
    --Warp.run 8080 $ app con

--app :: PGS.Connection -> Wai.Application
--app con = S.serve api $ server con

--api :: S.Proxy API
--api = S.Proxy

--server :: PGS.Connection -> S.Server API
--server con = userServer con 
    -- :<|> blogPostServer con


import qualified Network.Wai as Wai
import qualified Network.Wai.Handler.Warp as Warp
import Servant ((:<|>)( .. ), (:>))
import qualified Servant as S
import qualified Database.PostgreSQL.Simple as PGS

import Api.User
import Api.BlogPost

type API = "users" :> UserAPI
      :<|> "posts" :> BlogPostAPI

startApp :: IO ()
startApp = do
  con <- PGS.connect PGS.defaultConnectInfo
        { PGS.connectUser = "postgres"
        , PGS.connectPassword = "postgres"
        , PGS.connectDatabase = "opaleye"
         }
  Warp.run 8080 $ app con

app :: PGS.Connection -> Wai.Application
app con = S.serve api $ server con

api :: S.Proxy API
api = S.Proxy

server :: PGS.Connection -> S.Server API
server con = userServer con
        :<|> blogPostServer con
