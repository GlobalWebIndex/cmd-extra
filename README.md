# Cmd.Extra

Experimental package with helpful functions for working with Cmd.

This package adds some functions that helps you with constructing of `Cmd msg` from given `msg` and theirs manipulation.

```
    type Msg
        = DoNothing
        | Disarm
        | Fire
        | FireRockets

    update : Msg -> Model -> ( Model, Cmd Msg )
    update msg model =
        case msg of
            DoNothing ->
                Cmd.Extra.pure
                -- equivalent of (model, Cmd.Extra.none)

            Disarm ->
                Cmd.Extra.withTrigger DoNothing model
                -- equivalent of (model, Cmd.Extra.perform DoNothing)

            Fire ->
                ( model, Cmd.Extra.perform FireRockets )

            FireRockets ->
                Rockets.Nukes.fire

```

Feedback and contributions are very welcome.


## License

BSD 3-Clause License
