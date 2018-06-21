module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )



-- MODEL


type alias Model =
    { score : Int
    , username : String
    , view : Page
    , quizData : List QuizData
    }


type Page
    = StartPage
    | QuestionPage
    | GameOverPage


type alias QuizData =
    { question : String
    , correct_answer : String
    , options : List String
    }


type Msg
    = Username String
    | Score Int
    | UpdatePage


initModel : Model
initModel =
    { score = 0
    , username = ""
    , view = StartPage
    , quizData = []
    }



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Username username ->
            ( { model | username = username }, Cmd.none )

        Score score ->
            ( { model | score = score }, Cmd.none )

        UpdatePage ->
            ( { model | view = QuestionPage }, Cmd.none )



-- function to switch between pages


changePage : Model -> Html Msg
changePage model =
    case model.view of
        StartPage ->
            section []
                [ input [ placeholder "Enter your name", onInput Username ]
                    []
                , button
                    []
                    [ text "Play" ]
                ]

        QuestionPage ->
            section []
                [ p [] [ text "This is the question page" ]
                ]

        GameOverPage ->
            section []
                [ p [] [ text "This is the gameover page" ]
                ]



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ header []
            [ h1 [] [ text "ElmQuiz" ]
            ]
        , (changePage model)
        ]
