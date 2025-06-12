module Main exposing (main)
import Browser
-- element is the central piece of the elm UI
import Element
-- allows to control fonts
import Element.Font
import Element.Background
import Element.Input
import Element.Border
import Element.Region
-- instead we could do import Html and then reference it as Html.Html inside the code
import Html exposing (Html)


darkColors : Model
darkColors = {
  primary = Element.rgb255 0xFF 0xAB 0x00
  , primaryLight = Element.rgb255 0xFF 0xDD 0x4B
  , primaryDark = Element.rgb255 0xC6 0x7C 0x00
  , secondary = Element.rgb255 0x3E 0x27 0x23
  , secondaryLight = Element.rgb255 0x6A 0x4F 0x4B
  , secondaryDark = Element.rgb255 0x1B 0x00 0x00
  , textOnPrimary = Element.rgb255 0x00 0x00 0x00
  , textOnSecondary = Element.rgb255 0xFF 0xFF 0xFF
  }

lightColors : Model
lightColors = {
  secondary = Element.rgb255 0xFF 0xAB 0x00
  , secondaryLight = Element.rgb255 0xFF 0xDD 0x4B
  , secondaryDark = Element.rgb255 0xC6 0x7C 0x00
  , primary = Element.rgb255 0x3E 0x27 0x23
  , primaryLight = Element.rgb255 0x6A 0x4F 0x4B
  , primaryDark = Element.rgb255 0x1B 0x00 0x00
  , textOnSecondary = Element.rgb255 0x00 0x00 0x00
  , textOnPrimary = Element.rgb255 0xFF 0xFF 0xFF
  }  


-- in the model we are initializoing with the darkColors. When we access colors now elsewhere we will use the model and then say model.primary or model.primaryDark etc
-- the type - main is the starting point, it is a Program, the () - the configuration of how the application starts. For example it could have a cookie value for a user session or language starting point. Then the Model is our data and finally the Message which is what allows us to make changes based on events.
main : Program () Model Msg
main = Browser.sandbox 
  {
    init = darkColors
    , view = viewLayout
    , update = update
  }

type Msg = MsgChangeColors

-- we used underscore because it isn't being used but, we replaced msg with the underscore
update : Msg -> Model -> Model
update _ model = 
  if model.primary == darkColors.primary then  
    lightColors
  else  
    darkColors

type alias Model = 
  {
    primaryDark : Element.Color
    , secondaryDark : Element.Color
    , textOnSecondary : Element.Color
    , primaryLight : Element.Color
    , primary : Element.Color
    , secondary : Element.Color
    , secondaryLight: Element.Color
    , textOnPrimary: Element.Color
  }


-- can be any name 
-- This is calling the layout function from elm-ui, which is used to create the root node for rendering your Elm UI. It returns a Html msg value. options = []: These are layout configuration options. You can specify things like Element.width, Element.height, Element.padding, etc. An empty list means no custom layout options are applied.
-- [] - The second argument to Element.layout is a list of Element.Attribute items, such as styles or events. This is also empty here, so no special attributes are applied to the root element.
-- This is the content of the layout: a single text node that displays the string "My dog", wrapped in elm-ui's layout system.
viewLayout : Model -> Html Msg
viewLayout model =
  Element.layoutWith {
    options = [
      Element.focusStyle {
        backgroundColor = Nothing
        , borderColor = Just model.primaryDark
        , shadow = Nothing
      }
    ]
  }
  [ 
    Element.Background.color model.secondaryDark 
    , Element.padding 22
    , Element.Font.color model.textOnSecondary
  ]
  -- can do column or row
  -- because we need the model to be accesible within the "functions" we pass it like this to let these views know that the model is being passed in
  ( Element.column []
    [
      buttonChangeColors model
      , viewTitle model
      , viewSubtitle model
      , dogImage
      , viewContent
    ])

-- Element.Region.heading - for screen readers so gives this title an h1 tag
viewTitle : Model -> Element.Element msg
viewTitle model = 
  Element.paragraph [
      Element.Font.bold
    , Element.Font.color model.primary
    , Element.Font.size 52
    , Element.Region.heading 1
  ]
  [ 
     Element.text "My Dog"
  ]
 

viewSubtitle : Model -> Element.Element msg
viewSubtitle model = 
  Element.paragraph [ Element.Font.color model.primaryLight, Element.Font.regular, Element.Region.heading 2 ]
  [
    Element.text "A web page for my dog"
  ]

-- type is based on the fact that it is an HTML element that will appear on the page
dogImage : Element.Element msg
dogImage = 
  Element.image [ 
    Element.width (Element.maximum 500 Element.fill)
    , Element.paddingXY 0 20
    , Element.centerX
  ]
  {
    src = "dog.jpg"
    , description = "picture of a dog"
  }

buttonChangeColors : Model -> Element.Element Msg
buttonChangeColors model = 
  Element.Input.button [
    Element.Background.color model.primaryLight
    , Element.Border.rounded 8
    , Element.Font.color model.secondaryDark
    , Element.alignRight
    , Element.padding 8
    , Element.Font.size 14
    , Element.Font.bold 
    , Element.mouseOver [
      Element.Background.color model.primary
    ]
  ] 
    {
      onPress = Just MsgChangeColors
      , label = Element.text "Change colors"
    }

text1 : String
text1 = "Soufflé marzipan apple pie danish halvah tiramisu. Sugar plum cake chupa chups candy canes bonbon dessert bear claw. Biscuit icing oat cake chocolate cake sweet donut dragée dessert liquorice. Cake bear claw dessert gummies sweet roll marshmallow chocolate cake liquorice bear claw. Jelly-o toffee tiramisu gummi bears powder. Cupcake candy cake chocolate bar jelly-o chupa chups chocolate bar chocolate cake. Powder lollipop powder brownie halvah dessert shortbread. Dragée sugar plum halvah toffee pie chocolate cake powder brownie shortbread. Bonbon lollipop marzipan dessert dessert jelly-o gingerbread croissant bear claw. Sesame snaps candy canes chocolate cake cotton candy pastry pastry powder."

text2 : String
text2 = "Marshmallow apple pie dessert powder jelly-o marshmallow gummies sweet croissant. Cake dragée muffin icing sweet cookie. Wafer sweet roll tiramisu chocolate bar jelly marshmallow macaroon brownie candy canes. Ice cream tiramisu icing jelly beans toffee pastry brownie jelly-o dessert. Liquorice topping shortbread dragée cupcake biscuit. Pudding pastry marzipan jujubes muffin. Tootsie roll soufflé marzipan sweet powder bear claw. Danish gummies caramels dessert brownie jelly-o lemon drops. Dessert soufflé cake muffin lollipop bear claw cake marzipan cake. Candy cupcake carrot cake gummies fruitcake gingerbread chocolate bar."

text3 : String
text3 = "Biscuit danish apple pie gingerbread jelly. Chupa chups marshmallow cake cake cotton candy danish. Wafer gummies bear claw pastry topping tiramisu. Apple pie oat cake candy canes cotton candy jujubes gummies powder dessert bonbon. Pastry bear claw halvah tart dragée toffee gummi bears dessert lollipop. Macaroon sesame snaps jelly-o jelly beans pie sweet bear claw pudding."

viewContent : Element.Element msg
viewContent = 
  Element.column [ 
    Element.Font.size 16 
    , Element.Region.mainContent
  ]
  [
      Element.paragraph 
        [Element.paddingXY 0 20] 
        [Element.text text1]
      , Element.paragraph
         [Element.paddingXY 0 20] 
         [Element.text text2]
      , Element.paragraph 
        [Element.paddingXY 0 20] 
        [Element.text text3]
  ]