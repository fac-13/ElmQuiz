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
    , view : Pages
    , quizData : List ApiResponse
    }


type Pages
    = StartPage
    | QuestionPage
    | GameOverPage


type alias ApiResponse =
    { question : String
    , correct_answer : String
    , options : List String
    }


initModel : Model
initModel =
    { score = 0
    , username = ""
    , view = StartPage
    , quizData = []
    }
