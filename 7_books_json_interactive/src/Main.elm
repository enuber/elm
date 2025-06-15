module Main exposing (main)
import Browser
import Http exposing (Error(..))
import Json.Decode as Decode exposing (Decoder, field, string, maybe)
import Html exposing (Html)
import Element
import Element.Font
import Element.Background
import Element.Input
import Element.Border
import Svg
import Svg.Attributes as SA
import Browser.Events


type alias Model = 
  {
    searchText : String
    , results: List Book
    , errorMessage : Maybe String
    , loading: Bool
  }

type alias Book = 
  {
    title: String
    , thumbnail: Maybe String
    , link: String
    , pages: Maybe Int
    , publisher: Maybe String
  }

type Msg 
  = MsgSearch 
  | MsgGotResults (Result Http.Error (List Book))
  | MsgInputTextField String
  | MsgKeyPressed String


main: Program () Model Msg
main = Browser.element {
    init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
  }

init: () -> (Model, Cmd Msg )
init _ = 
  ( initModel, cmdSearch initModel )

initModel: Model
initModel = {
  searchText = "Spy X Family"
  , results = []
  , errorMessage = Nothing
  , loading = False
  }


view: Model -> Html Msg
view model = 
  viewLayout model


update: Msg -> Model -> ( Model, Cmd Msg )
update msg model = 
  case msg of
      MsgInputTextField newTextInput ->
        ({ model | searchText = newTextInput }, Cmd.none)

      MsgSearch ->
        updateStartSearch model

      MsgKeyPressed key ->
        if key == "Enter" then
          updateStartSearch model
        else
          ( model, Cmd.none )

      MsgGotResults result ->
          let
              newModel = { model | loading = False }
          in
          case result of
              Ok data ->
                  ( { newModel | results = data, errorMessage = Nothing }, Cmd.none )

              Err error ->
                  let
                      errorMessage =
                          case error of
                              Http.NetworkError ->
                                  "Network Error"

                              Http.BadUrl _ ->
                                  "Bad URL"

                              Http.Timeout ->
                                  "Timeout"

                              Http.BadStatus _ ->
                                  "Bad Status"

                              Http.BadBody reason ->
                                  reason
                  in
                  ( { newModel | errorMessage = Just errorMessage }, Cmd.none )


updateStartSearch : Model -> (Model, Cmd Msg)
updateStartSearch model =
   ({ model | loading = True }, cmdSearch model)

subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onKeyPress keyPressed

keyPressed : Decoder Msg
keyPressed =
  Decode.map MsgKeyPressed (Decode.field "key" Decode.string)

-- added options with layoutWith so that we can keep focus not having any weird borders.
viewLayout : Model -> Html Msg
viewLayout model = 
  Element.layoutWith {
    options = [
      Element.focusStyle {
          borderColor = Just (Element.rgb255 0x00 0x33 0x66)
          , backgroundColor = Nothing
          , shadow = Nothing
      }
    ]
  } [] (
    Element.column [Element.padding 20] [
      viewSearchBar model
      , viewErrorMessage model
      , viewResults model
      ]
  )

viewSearchBar : Model -> Element.Element Msg
viewSearchBar model = 
  Element.row [ Element.spacing 10, Element.paddingXY 0 12] 
    [ Element.Input.search [] 
        {
          onChange = MsgInputTextField
          , text = model.searchText
          , placeholder = Nothing
          , label = Element.Input.labelLeft [] (
              Element.text "Search books"
          )
        }
        , viewSearchButton
        , if model.loading then
            Element.html loadingImage
          else 
            Element.none
    ]

loadingImage : Html msg
loadingImage = 
  Svg.svg [
    SA.width "64px"
    , SA.height "64px"
    , SA.viewBox "0 0 48 48"
  ]
  [
    Svg.circle [
      SA.cx "24"
      , SA.cy "24"
      , SA.stroke "#6699AA"
      , SA.strokeWidth "4"
      , SA.r "8"
      , SA.fill "none"
    ] [
      Svg.animate [
        SA.attributeName "opacity"
        , SA.values "0;.8;0"
        , SA.dur "2s"
        , SA.repeatCount "indefinite"
      ][]
    ]
  ]

viewErrorMessage: Model -> Element.Element Msg
viewErrorMessage model =
  case model.errorMessage of
      Just errorMessage ->
        Element.text errorMessage
      Nothing ->
        Element.none

viewResults : Model -> Element.Element msg
viewResults model =  
  Element.wrappedRow [ Element.spacing 6, Element.centerX] 
    (List.map viewBook model.results)


viewBook : Book -> Element.Element msg
viewBook book =  
  let
      titleE = Element.paragraph  [Element.Font.bold, Element.Font.underline, Element.paddingXY 0 12] [Element.text book.title]
      thumbnailE = case book.thumbnail of
            Just thumbnail ->
              viewBookCover thumbnail book.title
            Nothing ->
              Element.none
      pagesE = case book.pages of
          Just pages ->
            Element.el [ Element.Font.size 12 ]
            (Element.text ("(" ++ String.fromInt pages ++ " pages)"))
          Nothing ->
            Element.none
      publisherE = case book.publisher of
          Just publisher ->
            Element.paragraph [Element.Font.size 16][Element.text publisher]
          Nothing -> 
            Element.none
  in
  
  Element.newTabLink [
    Element.width (Element.px 360)
    , Element.height (Element.px 300)
    , Element.Background.color (Element.rgb255 0xe3 0xea 0xed)
    , Element.Border.rounded 20
    , Element.padding 10
    , Element.mouseOver [
        Element.Background.color (Element.rgb255 0x33 0x66 0x99)
        , Element.Font.color (Element.rgb255 255 255 255 )
    ]
    , Element.focused [
        Element.Background.color (Element.rgb255 0x33 0x66 0x99)
        , Element.Font.color (Element.rgb255 255 255 255 )
    ]
  ] {
    url = book.link
    , label =
      Element.row [ Element.centerX ]
      [ thumbnailE
      , Element.column [ Element.padding 20 ]
        [ 
          titleE
          , publisherE
          , pagesE
        ]
      ]
  }

viewBookCover : String -> String -> Element.Element msg
viewBookCover thumbnail title =
  Element.image [] {
    src = thumbnail
    , description = title
  }

viewSearchButton : Element.Element Msg
viewSearchButton = 
  Element.Input.button [
    Element.Background.color (Element.rgb255 0x00 0x33 0x66)
    , Element.Font.color (Element.rgb255 0xee 0xee 0xee)
    , Element.Border.rounded 5
    , Element.padding 12
    , Element.mouseOver [
      Element.Background.color (Element.rgb255 0x33 0x66 0x99)
      , Element.Font.color (Element.rgb255 0xdd 0xdd 0xdd)
    ]
    , Element.focused [
      Element.Background.color (Element.rgb255 0x33 0x66 0x99)
      , Element.Font.color (Element.rgb255 0xdd 0xdd 0xdd)
    ]
  ] {
    onPress = Just MsgSearch
    , label = Element.text "Search"
  }
  

cmdSearch : Model -> Cmd Msg
cmdSearch model = 
  Http.get {
    url = "https://www.googleapis.com/books/v1/volumes?q=" ++ model.searchText
    , expect = Http.expectJson MsgGotResults decodeJson
  }

decodeJson : Decoder (List Book)
decodeJson = 
  Decode.field "items" decodeItems



decodeItems : Decoder (List Book)
decodeItems = 
  Decode.list decodeItem


decodeItem : Decoder Book
decodeItem =
  Decode.field "volumeInfo" decodeVolumeInfo

decodeVolumeInfo : Decoder Book
decodeVolumeInfo = 
  Decode.map5 Book
    (Decode.field "title" Decode.string)
    (Decode.maybe (Decode.field "imageLinks" decodeImageLinks))
    (Decode.field "canonicalVolumeLink" Decode.string)
    (Decode.maybe (Decode.field "pageCount" Decode.int))
    (Decode.maybe (Decode.field "publisher" Decode.string))

decodeImageLinks : Decoder String
decodeImageLinks = 
  Decode.field "thumbnail" Decode.string

