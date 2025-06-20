module About exposing (..)
import Element exposing (..)
import Element.Font as EF
import Element.Input as Input


type alias Model = 
  {
    showDetail: Bool
  }
type Msg =
  MsgShowDetailClicked

initModel : { showDetail : Bool }
initModel = {
    showDetail = False
  }

-- node by exposing all above, don't have to do Element.column...etc
view: Model -> Element Msg
view model = 
  column [ Element.padding 20 ]
  [
    text "About page"
    , paragraph [ 
        paddingXY 0 20
        ,  EF.size 14
      ]
    [
      text "This is a website for learning about navigation."
    ]
    , paragraph [
        EF.size 14
      ]
      [
        viewDetail model.showDetail
      ]
  ]
  
viewDetail : Bool -> Element Msg
viewDetail showDetail = 
  if showDetail then 
    text "The authors of this website are amaizing"
  else  
    Input.button [ EF.underline]
    {
      onPress = Just MsgShowDetailClicked
      , label = text "Show more"
    }


update: Msg -> Model -> (Model, Cmd.Cmd Msg)
update msg model = 
  case msg of
      MsgShowDetailClicked ->
        ({ model | showDetail = True }, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none