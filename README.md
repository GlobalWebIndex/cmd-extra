# Cmd.Extra

Experimental package with helpful functions for working with Cmd.

This package adds some functions that helps you with constructing of `(model, Cmd msg)` pair from given `model` and `msg` and theirs manipulation.

```
    type Msg
        = NoOp
        | Disarm
        | Fire
        | FireRockets

    update : Msg -> Model -> ( Model, Cmd Msg )
    update msg model =
        case msg of
            DoNothing ->
                Cmd.Extra.pure model
                -- equivalent of (model, Cmd.Extra.none)

            Disarm ->
                Cmd.Extra.withTrigger NoOp model
                -- equivalent of (model, Cmd.Extra.perform NoOp)

            Fire ->
                ( model, Cmd.Extra.perform FireRockets )

            FireRockets ->
                Rockets.Nukes.fire

```

Feedback and contributions are very welcome.


## License

BSD 3-Clause License
