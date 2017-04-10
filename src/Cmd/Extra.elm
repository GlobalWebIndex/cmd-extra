module Cmd.Extra exposing (perform, attempt)

{-| Extra functions for working with Cmds.
# Basics
@docs perform, attempt
-}

import Task


-- Public Api


{-| Cmd costructor.
Usefull when you want to artificially emit Cmd from update function.

```
perform "Hi" : Cmd String
perform 1 : Cmd number
```

"real world" exaple:

```
type alias Model = ()
type Msg = Fire | FireRockets

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Fire ->
      ((), perform FireRockets)
    FireRockets ->
      Debug.crash "World ended:("
```

-}
perform : msg -> Cmd msg
perform =
    Task.perform identity << Task.succeed


{-| Similar to perform but takes `Result msg` and performs action only on `Ok`.
```
attempt (Ok 1) : Cmd number
attempt (Ok "I'm fine") : Cmd String
attempt (Err "Failed") == Cmd.none => True
```
-}
attempt : Result x msg -> Cmd msg
attempt =
    Result.withDefault Cmd.none << Result.map perform
