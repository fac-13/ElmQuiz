module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


main : Program Never Model Msg
main =
    program
        { init = initModel
        , update = update
        , view = view
        , subscription = \_ -> Sub.none
        }



-- MODEL


type alias Model =
    { score : Int
    , username : String
    , view : Page
    , quizData : List ApiResponse
    }


type Page
    = StartPage
    | QuestionPage
    | GameOverPage


type alias ApiResponse =
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
