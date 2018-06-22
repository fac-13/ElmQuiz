module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Json.Decode as Json


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
    , error : Bool
    }


type Page
    = StartPage
    | QuestionPage
    | GameOverPage


type alias QuizData =
    { question : String
    , correct_answer : String
    , incorrect_answers : List String
    }


type Msg
    = Username String
    | Score Int
    | UpdatePage
    | GetApiData
    | ApiResponse (Result Http.Error QuizData)


initModel : Model
initModel =
    { score = 0
    , username = ""
    , view = StartPage
    , quizData =
        [ { question = ""
          , correct_answer = ""
          , incorrect_answers = []
          }
        ]
    , error = False
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

        GetApiData ->
            ( model, sendHttpRequest )

        ApiResponse (Ok quizData) ->
            let
                log =
                    Debug.log "Quiz api data: " quizData
            in
                ( { model | quizData = quizData :: model.quizData }, Cmd.none )

        ApiResponse (Err err) ->
            let
                log =
                    Debug.log "Quiz api error:" err
            in
                ( { model | error = True }, Cmd.none )


sendHttpRequest =
    Http.send ApiResponse <| getRequest


getRequest =
    let
        url =
            "https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&type=multiple"
    in
        Http.get url apiDecoder


apiDecoder : Json.Decoder QuizData
apiDecoder =
    Json.map3 QuizData
        (Json.at [ "results", "question" ] Json.string)
        (Json.at [ "results", "correct_answer" ] Json.string)
        (Json.at [ "results", "incorrect_answers" ] (Json.list Json.string))



-- function to switch between pages


changePage : Model -> Html Msg
changePage model =
    case model.view of
        StartPage ->
            section []
                [ input [ placeholder "Enter your name", onInput Username ]
                    []
                , button
                    [ onClick GetApiData ]
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
        [ Html.header []
            [ h1 [] [ text "ElmQuiz" ]
            ]
        , (changePage model)
        ]
