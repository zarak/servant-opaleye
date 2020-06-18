{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_servant_opaleye (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/zarak/Courses/servant-opaleye/.stack-work/install/x86_64-osx/040bb5188a4ba49ee0723aa455f310e63e1098cd8a9bc2ca41feed75b352a9f9/8.8.3/bin"
libdir     = "/Users/zarak/Courses/servant-opaleye/.stack-work/install/x86_64-osx/040bb5188a4ba49ee0723aa455f310e63e1098cd8a9bc2ca41feed75b352a9f9/8.8.3/lib/x86_64-osx-ghc-8.8.3/servant-opaleye-0.1.0.0-6R3AGhuLYIpCRHExW8dCiV"
dynlibdir  = "/Users/zarak/Courses/servant-opaleye/.stack-work/install/x86_64-osx/040bb5188a4ba49ee0723aa455f310e63e1098cd8a9bc2ca41feed75b352a9f9/8.8.3/lib/x86_64-osx-ghc-8.8.3"
datadir    = "/Users/zarak/Courses/servant-opaleye/.stack-work/install/x86_64-osx/040bb5188a4ba49ee0723aa455f310e63e1098cd8a9bc2ca41feed75b352a9f9/8.8.3/share/x86_64-osx-ghc-8.8.3/servant-opaleye-0.1.0.0"
libexecdir = "/Users/zarak/Courses/servant-opaleye/.stack-work/install/x86_64-osx/040bb5188a4ba49ee0723aa455f310e63e1098cd8a9bc2ca41feed75b352a9f9/8.8.3/libexec/x86_64-osx-ghc-8.8.3/servant-opaleye-0.1.0.0"
sysconfdir = "/Users/zarak/Courses/servant-opaleye/.stack-work/install/x86_64-osx/040bb5188a4ba49ee0723aa455f310e63e1098cd8a9bc2ca41feed75b352a9f9/8.8.3/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "servant_opaleye_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "servant_opaleye_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "servant_opaleye_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "servant_opaleye_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "servant_opaleye_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "servant_opaleye_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
