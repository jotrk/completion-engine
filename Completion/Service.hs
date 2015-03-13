{-# LANGUAGE OverloadedStrings #-}

module Completion.Service (service) where

import Web.Scotty
import Control.Applicative
import Completion.Config
import Completion.Types
import Completion.Completer
import Network.Wai.Handler.Warp (Port)

service :: Port -> IO ()
service p = buildGraph . words <$> readFile defaultDictionary >>= runScotty p

runScotty :: Port -> CompletionGraph -> IO ()
runScotty port graph = scotty port $ do
    get (capture "/:part") $ flip completions graph <$> param "part" >>= json
    notFound               $ json $ Error 400 "service not found" Nothing