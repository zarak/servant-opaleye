{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TypeOperators   #-}

module Api.BlogPost where

import Servant
import qualified Opaleye as O
import Control.Monad.IO.Class (liftIO)
import Data.Maybe (listToMaybe)
import qualified Database.PostgreSQL.Simple as PGS

import App
import Models.BlogPost
import Queries.BlogPost

type BlogPostAPI = Get '[JSON] [BlogPostRead]
              :<|> Capture "id" BlogPostID :> Get '[JSON] (Maybe BlogPostRead)
              :<|> Capture "email" Email :> Get '[JSON] [BlogPostRead]
              :<|> ReqBody '[JSON] BlogPostWrite :> Post '[JSON] (Maybe BlogPostID)

blogPostAPI :: Proxy BlogPostAPI
blogPostAPI = Proxy

blogPostServer :: PGS.Connection -> Server BlogPostAPI
blogPostServer con = getPosts con
                :<|> getPostById con
                :<|> getPostsByEmail con
                :<|> postPost con

getPosts :: PGS.Connection -> AppM [BlogPostRead]
getPosts con = liftIO $ O.runQuery con blogPostsQuery

getPostById :: PGS.Connection -> BlogPostID -> AppM (Maybe BlogPostRead)
getPostById con postID = liftIO $ listToMaybe <$> O.runQuery con (blogPostByIdQuery postID)

getPostsByEmail :: PGS.Connection -> Email -> AppM [BlogPostRead]
getPostsByEmail con email = liftIO $ O.runQuery con (blogPostsByEmailQuery email)

postPost :: PGS.Connection -> BlogPostWrite -> AppM (Maybe BlogPostID)
postPost con post = liftIO $ listToMaybe <$>
  O.runInsertManyReturning con blogPostTable [blogPostToPG post] bpId

--data BlogPost = BlogPost
              --{ bpId         :: BlogPostID
              --, bpTitle      :: String
              --, bpBody       :: String
              --, bpUsersEmail :: Email
              --, bpTimestamp  :: UTCTime
              --}

--instance ToJSON BlogPost where
    --toJSON post = object [ "id" .= bpId post
                         --, "title" .= bpTitle post
                         --, "body" .= bpBody post
                         --, "email" .= bpUsersEmail post
                         --, "timestamp" .= bpTimestamp post
                         --]

--instance FromJSON BlogPost where
    --parseJSON (Object o) = BlogPost <$>
        --o .: "id" <*>
        --o .: "title" <*>
        --o .: "body" <*>
        --o .: "email" <*>
        --o .: "timestamp"
    --parseJSON _ = mzero


--type BlogPostAPI = Get '[JSON] [BlogPost]
          -- :<|> Capture "id" BlogPostID :> Get '[JSON] (Maybe BlogPost)
          -- :<|> ReqBody '[JSON] BlogPost :> Post '[JSON] [BlogPost]

--blogPostAPI :: Proxy BlogPostAPI
--blogPostAPI = Proxy

--blogPostServer :: Server BlogPostAPI
--blogPostServer = getBlogPosts
        -- :<|> getBlogPostByID
        -- :<|> postBlogPost

--posts :: [BlogPost]
--posts = [ BlogPost 1 "First Post" "I don't like apples very much right now." "isaacnewton@gmail.com" (fromGregorian' 1726 4 15)
        --, BlogPost 2 "My Blog" "Bored at the patent office, thought I'd start a blog." "alberteinstein@hotmail.com" (fromGregorian' 1903 6 16)]
    --where
        --fromGregorian' y m d = UTCTime (fromGregorian y m d) 0

--getBlogPosts :: AppM [BlogPost]
--getBlogPosts = return posts

--getBlogPostByID :: BlogPostID -> AppM (Maybe BlogPost)
--getBlogPostByID id = return $ listToMaybe $ filter ((== id) . bpId) posts

--postBlogPost :: BlogPost -> AppM [BlogPost]
--postBlogPost post = return $ posts ++ [post]
