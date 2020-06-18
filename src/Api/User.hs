{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE OverloadedStrings #-}

module Api.User where

import Data.Aeson
import Servant
import Control.Monad (mzero)
import Data.Maybe (listToMaybe)

import App

data User = User
  { userEmail        :: Email
  , userPassword :: String
  } deriving (Eq, Show)

instance ToJSON User where
    toJSON user = object ["email" .= userEmail user]

instance FromJSON User where
    parseJSON (Object o) = User <$>
                              o .: "email" <*>
                              o .: "password"
    parseJSON _ = mzero

type UserAPI = Get '[JSON] [User]
          :<|> Capture "email" Email :> Get '[JSON] (Maybe User)
          :<|> ReqBody '[JSON] User :> Post '[JSON] [User]

userAPI :: Proxy UserAPI
userAPI = Proxy

userServer :: Server UserAPI
userServer = getUsers
        :<|> getUserByEmail
        :<|> postUser

getUsers :: AppM [User]
getUsers = return users

getUserByEmail :: Email -> AppM (Maybe User)
getUserByEmail email = return $ listToMaybe $ filter ((== email) . userEmail) users

postUser :: User -> AppM [User]
postUser user = return $ users ++ [user]

users :: [User]
users = [ User "isaacnewton@gmail.com" "betterthanleibniz"
        , User "alberteinstein@hotmail.com" "crazytrain"
        ]
