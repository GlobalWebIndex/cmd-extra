# Cmd.Extra

Experimental package with helpful functions for working with Cmd.

This package can help you with construction of `Cmd msg` and composition of pair `(model, Cmd msg)` that can be used to streamline your flow of actions in `update`.

```elm
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
                -- equivalent of (model, Cmd.none)

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
