module Router exposing (..)
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>))

type Route =
  RouteAboutPage
  | RouteHomePage


aboutPageParser : Parser.Parser a a
aboutPageParser =
  Parser.s "about"

homePageParser : Parser.Parser a a
homePageParser =
  Parser.top

-- not used, just to show how you would do something like about/contact
refercenceOnlyContactPageParger : Parser.Parser a a
refercenceOnlyContactPageParger =
  Parser.s "about" </> Parser.s "contact"

routerParser : Parser.Parser (Route -> c) c
routerParser = 
  Parser.oneOf [
    Parser.map RouteAboutPage aboutPageParser
    , Parser.map RouteHomePage homePageParser
  ]

fromUrl: Url -> Maybe Route
fromUrl url =
  Parser.parse routerParser url

asPath: Route -> String
asPath route =
  case route of
        RouteAboutPage ->
          "/about"
        RouteHomePage ->
          "/"
  