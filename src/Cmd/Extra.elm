module Cmd.Extra
    exposing
        ( add
        , addTrigger
        , attempt
        , fromMaybe
        , fromResult
        , maybe
        , perform
        , pure
        , with
        , withTrigger
        )

{-| Extra functions for working with Cmds.


# Constructors

@docs perform, attempt, maybe, fromResult, fromMaybe


# Chaining in update

@docs pure, with, add, withTrigger, addTrigger

-}

import Task


-- Constructors


{-| Cmd costructor.
Usefull when you want to artificially emit Cmd from update function.

    performed : Cmd String
    performed =
        perform "foo"

"real world" example:

    type alias Model =
        ()

    type Msg
        = Fire
        | FireRockets

    update : Msg -> Model -> ( Model, Cmd Msg )
    update msg () =
        case msg of
            Fire ->
                ( (), perform FireRockets )

            FireRockets ->
                Debug.crash "World ended:("

-}
perform : msg -> Cmd msg
perform =
    Task.perform identity << Task.succeed


{-| Similar to perform but takes `Result msg` and performs action only on `Ok`.

    attempted : Cmd String
    attempted =
      attempt <| Ok "I'm fine"

    attempt (Err "Failed") == Cmd.none
    --> True

-}
attempt : Result x msg -> Cmd msg
attempt =
    Result.withDefault Cmd.none << Result.map perform


{-| Similar to attempt but works with `Maybe` instead

    maybeCmd : Cmd String
    maybeCmd =
        maybe <| Just 1

    maybe Nothing == Cmd.none
    --> True

-}
maybe : Maybe msg -> Cmd msg
maybe maybe =
    Maybe.map perform maybe
        |> Maybe.withDefault Cmd.none


{-| Construct from Result.

    resultCmd : Cmd String
    resultCmd =
      fromResult toString (Ok 1)

    fromResult toString (Err ())
    --> Cmd.none

-}
fromResult : (a -> msg) -> Result x a -> Cmd msg
fromResult const res =
    Result.map const res
        |> attempt


{-| Construct from Maybe.

    stringCmd : Cmd String
    stringCmd =
      toString (Just 1)

    fromMaybe toString Nothing
    --> Cmd.none

-}
fromMaybe : (a -> msg) -> Maybe a -> Cmd msg
fromMaybe const m =
    Maybe.map const m
        |> maybe



-- Chaining in update


{-| Creates pair `model` with `Cmd.none`

    pair : ( String, Cmd msg )
    pair = pure "foo"

    pair
      |> Tuple.second
      |> ((==) Cmd.none)
    --> True

-}
pure : model -> ( model, Cmd msg )
pure model =
    ( model, Cmd.none )


{-| Add Cmd to model to create a pair.
-}
with : Cmd msg -> model -> ( model, Cmd msg )
with cmd model =
    ( model, cmd )


{-| Add new cmd to an existing pair.
-}
add : Cmd msg -> ( model, Cmd msg ) -> ( model, Cmd msg )
add newCmd ( model, prevCmd ) =
    ( model, Cmd.batch [ newCmd, prevCmd ] )


{-| Trigger Cmd from Msg and create a pair
-}
withTrigger : msg -> model -> ( model, Cmd msg )
withTrigger msg =
    with <| perform msg


{-| Add new trigger of Msg to an existing pair.
-}
addTrigger : msg -> ( model, Cmd msg ) -> ( model, Cmd msg )
addTrigger msg =
    add <| perform msg
