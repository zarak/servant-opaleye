{-# LANGUAGE Arrows #-}

module Queries.BlogPost where

import qualified Opaleye as O
import Opaleye ((.==))
import Control.Arrow (returnA)

import App
import Models.BlogPost

blogPostsQuery :: O.Query BPColumnRead
blogPostsQuery = O.queryTable blogPostTable

blogPostByIdQuery :: BlogPostID -> O.Query BPColumnRead
blogPostByIdQuery postId = proc () -> do
    post <- blogPostsQuery -< ()
    O.restrict -< bpId post .== O.pgInt8 postId
    returnA -< post

blogPostsByEmailQuery :: Email -> O.Query BPColumnRead
blogPostsByEmailQuery email = proc () -> do
    post <- blogPostsQuery -< ()
    O.restrict -< bpUsersEmail post .== O.pgString email
    returnA -< post
