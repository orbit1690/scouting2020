module Autonomous exposing (Model, Msg, getter, init, subscriptions, update, view)

import Colors exposing (blue, purple, sky, white)
import Counter
import Element exposing (centerX, centerY, column, el, padding, spacing, text)
import Element.Background as Background
import Element.Border as Border exposing (rounded)
import Element.Font as Font exposing (center)
import Element.Input as Input exposing (button, radioRow)


type Msg
    = Moved
    | LowLevel Counter.Msg
    | LevelTwo Counter.Msg
    | LevelThree Counter.Msg
    | Missed Counter.Msg
    | TrenchCollection Counter.Msg
    | EnemyTrenchCollection Counter.Msg
    | RendezvousCollection Counter.Msg
    | BallsAmount BallsInitAmount


type alias Model =
    { ballsAmount : BallsInitAmount
    , moved : Bool
    , lowlevel : Counter.Model
    , levelTwo : Counter.Model
    , levelThree : Counter.Model
    , missed : Counter.Model
    , trenchCollection : Counter.Model
    , enemyTrenchCollection : Counter.Model
    , rendezvousCollection : Counter.Model
    }


getter : Model -> String
getter model =
    let
        boolToString : Bool -> String
        boolToString bool =
            if bool then
                "true"

            else
                "false"

        ballsAmountToString : BallsInitAmount -> String
        ballsAmountToString ball =
            case ball of
                NoBalls ->
                    "none"

                OneBall ->
                    "1"

                TwoBalls ->
                    "2"

                ThreeBalls ->
                    "3"
    in
    String.join ","
        [ ballsAmountToString model.ballsAmount
        , boolToString model.moved
        , String.fromInt model.lowlevel
        , String.fromInt model.levelTwo
        , String.fromInt model.levelThree
        , String.fromInt model.missed
        , String.fromInt model.trenchCollection
        , String.fromInt model.enemyTrenchCollection
        , String.fromInt model.rendezvousCollection
        ]


type BallsInitAmount
    = NoBalls
    | OneBall
    | TwoBalls
    | ThreeBalls


createButton : Msg -> String -> Element.Element Msg
createButton msg name =
    button
        [ Font.color white
        , Font.size 60
        , Font.glow blue 5
        , Border.rounded 4
        , Font.bold
        , Font.family
            [ Font.external
                { name = "Open Sans"
                , url = "https://fonts.googleapis.com/css?family=Open+Sans:700i&display=swap"
                }
            ]
        , Background.color purple
        , center
        , centerX
        , centerY
        ]
        { onPress = Just msg, label = text name }


view : Model -> Element.Element Msg
view model =
    let
        radios :
            Input.Label Msg
            -> BallsInitAmount
            -> Element.Element Msg
            -> BallsInitAmount
            -> Element.Element Msg
            -> Element.Element Msg
        radios label ballAmount1 txtMsg1 ballAmount2 txtMsg2 =
            radioRow
                [ padding 10
                , spacing 50
                , Font.size 50
                ]
                { onChange = BallsAmount
                , selected = Just model.ballsAmount
                , label = label
                , options =
                    [ Input.option ballAmount1 <| txtMsg1
                    , Input.option ballAmount2 <| txtMsg2
                    ]
                }
    in
    column
        [ Background.color blue
        , padding 50
        , spacing 50
        , centerX
        , centerY
        , Element.height <| Element.fillPortion 5
        ]
        [ radios
            (Input.labelAbove [ Font.size 50, padding 10, spacing 20, Font.underline ] <| text "started with:")
            NoBalls
            (text "0 balls")
            OneBall
            (text "1 ball")
        , radios
            (Input.labelHidden "option2")
            TwoBalls
            (text "2 balls")
            ThreeBalls
            (text "3 balls")
        , createButton Moved <|
            if model.moved then
                "moved."

            else
                "moved?"
        , Element.map LowLevel <| Counter.view "low Level:" model.lowlevel
        , Element.map LevelTwo <| Counter.view "second Level:" model.levelTwo
        , Element.map LevelThree <| Counter.view "third Level:" model.levelThree
        , Element.map Missed <| Counter.view "missed:" model.missed
        , el [ Font.size 50, padding 10, Font.underline ] (text "Collected from:")
        , Element.map TrenchCollection <| Counter.view "their trench:" model.trenchCollection
        , Element.map EnemyTrenchCollection <| Counter.view "enemy's trench:" model.enemyTrenchCollection
        , Element.map RendezvousCollection <| Counter.view "rendezvous:" model.rendezvousCollection
        ]


init : Model
init =
    Model NoBalls False Counter.init Counter.init Counter.init Counter.init Counter.init Counter.init <| Counter.init


update : Msg -> Model -> Model
update msg model =
    let
        counterUpdate : Counter.Msg -> Counter.Model -> Counter.Model
        counterUpdate =
            Counter.update
    in
    case msg of
        Moved ->
            { model | moved = not model.moved }

        LowLevel count ->
            { model | lowlevel = counterUpdate count model.lowlevel }

        LevelTwo count ->
            { model | levelTwo = counterUpdate count model.levelTwo }

        LevelThree count ->
            { model | levelThree = counterUpdate count model.levelThree }

        Missed count ->
            { model | missed = counterUpdate count model.missed }

        TrenchCollection count ->
            { model | trenchCollection = counterUpdate count model.trenchCollection }

        BallsAmount ballsAmount ->
            { model | ballsAmount = ballsAmount }

        EnemyTrenchCollection count ->
            { model | enemyTrenchCollection = counterUpdate count model.enemyTrenchCollection }

        RendezvousCollection count ->
            { model | rendezvousCollection = counterUpdate count model.rendezvousCollection }


subscriptions : Sub Msg
subscriptions =
    Sub.none
