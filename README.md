Free Op
=======

This provides free monads from GADTs of operations.

Example:

```haskell
data Command a where
  GetLine :: Command String
  PutLine :: String -> Command ()

runCommand :: Command a -> IO a
runCommand GetLine = getLine
runCommand (PutLine s) = putStrLn s

type MyIO = Op Command

main' :: MyIO ()
main' = do liftOp $ PutLine "Hello, world!"
           liftOp $ PutLine "Enter your name:"
           name <- liftOp $ GetLine
           liftOp $ PutLine $ "Hello, " ++ name ++ "!"
           return ()

main :: IO ()
main = runOp runCommand main'
```
