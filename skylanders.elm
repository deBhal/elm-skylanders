import Html exposing (Html, button, div, text, h1, img, hr)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, src, style, height, width)
import Dict
import Set


-- MODEL

type alias Model = Skylander

type alias Skylander =
    { name : String
    , element : String
    , class : String }

main =
    Html.beginnerProgram { model = Skylander "" "" "", view = view, update = update }


mappings : List Skylander
mappings =
  [
  Skylander "Air Strike" "Air" "Brawler",
  Skylander "Ambush" "Life" "Knight",
  Skylander "Aurora" "Light" "Swashbuckler",
  Skylander "Barbella" "Earth" "Sentinel",
  Skylander "Boom Bloom" "Life" "Ninja",
  Skylander "Buckshot" "Magic" "Bowslinger",
  Skylander "Chain Reaction" "Tech" "Swashbuckler",
  Skylander "Chopscotch" "Undead" "Smasher",
  Skylander "Ember" "Fire" "Sentinel",
  Skylander "Flare Wolf" "Fire" "Bazooker",
  Skylander "King Pen" "Water" "Brawler",
  Skylander "Mysticat" "Magic" "Sorcerer",
  Skylander "Pit Boss" "Undead" "Sorcerer",
  Skylander "Ro-Bow" "Tech" "Bowslinger",
  Skylander "Starcast" "Dark" "Ninja",
  Skylander "Tidepool" "Water" "Quickshot",
  Skylander "Tri-Tip" "Earth" "Smasher",
  Skylander "Wild Storm" "Air" "Knight",
  Skylander "Bad Juju" "Air" "Swashbuckler",
  Skylander "Blaster-Tron" "Light" "Knight",
  Skylander "Chompy Mage" "Life" "Bazooker",
  Skylander "Dr. Krankcase" "Tech" "Quickshot",
  Skylander "Golden Queen" "Earth" "Sorcerer",
  Skylander "Grave Clobber" "Water" "Brawler",
  Skylander "Hood Sickle" "Dark" "Sentinel",
  Skylander "Pain-Yatta" "Magic" "Smasher",
  Skylander "Tae Kwon Crow" "Fire" "Ninja",
  Skylander "Wolfgang" "Undead" "Bowslinger",
  Skylander "Crash Bandicoot" "Life" "Brawler",
  Skylander "Dr. Neo Cortex" "Tech" "Sorcerer",
  Skylander "Kaos" "KaosElement" "KaosClass"
  ]

skylanders = mappings

type Element = Air | Dark | Earth | Fire | Life | Light | Magic | Tech | Undead | Water | KaosElement
type BattleClass = Bazooker | Bowslinger | Brawler | Knight | Ninja | Quickshot | Sentinel | Smasher | Sorcerer | Swashbuckler | KaosClass

type Thing = Element | BattleClass | Sensei

imageFileNameForBattleClass : BattleClass -> String
imageFileNameForBattleClass class =
    toString class ++ "_symbol.png"

battleClassesList = ["Bazooker", "Bowslinger", "Brawler", "Knight", "Ninja", "Quickshot", "Sentinel", "Smasher", "Sorcerer", "Swashbuckler", "KaosClass"]
battleClassesSet = Set.fromList battleClassesList

elementList = ( Set.toList <| Set.remove "KaosElement" <| Set.fromList <| List.map .element mappings ) ++ ["KaosElement"]

--imageFileName : { Element | BattleClass } -> String
--imageFileName kind thing = case kind of
--   BattleClass -> imageFileNameForBattleClass thing
--   Element -> "images/AirSymbolSkylanders.png"

--image : Sting -> Html


buttonStyle : List (String, String)
buttonStyle =
    let size = "75px"
    in
        [ ("height", size), ("width", size )
        , ("-webkit-appearance", "none"), ("-moz-appearance", "none")
        , ("padding", "0"), ("border", "0")
        , ("background","transparent")
        ]

selectedButtonStyle = [
    ("outline", "dashed black 4px")]

imgFor : String -> Html Msg
imgFor thing =
    img [src (imageFor thing)] []


checkSelected : Model -> Thing -> String -> Bool
checkSelected model thing name =
    case thing of
        Element ->  model.element == name
        BattleClass -> model.class == name
        Sensei -> False

buttonImgFor : String -> Html Msg
buttonImgFor thing =
    img [src (imageFor thing), style buttonStyle ] []

addStyle : Html Msg -> List (String,String) -> Html Msg
addStyle thing styles =
    thing

buttonFor : Model -> Thing -> String -> Html Msg
buttonFor model thing name =
    let isSelected = checkSelected model thing name
        totalStyle = buttonStyle ++
            if isSelected then selectedButtonStyle else [] ++
            case thing of
                Sensei -> []
                _ -> [("max-size","60px")] -- Element, Battleclass
    in
    button [ onClick (Choose thing name), class (name ++ " button " ++ (toString isSelected)), style totalStyle ] [ buttonImgFor name ]

imageFor : String -> String
imageFor target =
    case Dict.get target imageFiles of
        Just value -> ( "images/" ++ value )
        Nothing -> "images/" ++ target ++ ".png"


anyone : Skylander -> Bool
anyone _ = True

hasElement : String -> (Skylander -> Bool)
hasElement element =
    (\skylander -> (skylander.element == element))

currentSkylanders : Model -> List Skylander
currentSkylanders model =
    let elements = if model.element == "" then anyone else elementFilter model
        classes = if model.class == "" then anyone else classFilter model
        names = if model.name == "" then anyone else nameFilter model
    in
        (List.filter elements (List.filter classes (List.filter names mappings)))

classFilter model = (\x -> x.class == model.class)
elementFilter model = (\x -> x.element == model.element)
nameFilter model = (\x -> x.name == model.name)



skylandersForClass : String -> List String
skylandersForClass class =
    case class of
    "" -> Dict.keys imageFiles
    string -> List.map .name (List.filter (\skylander -> skylander.class == class ) mappings)

imageFiles = Dict.fromList
  [ ("Air Strike", "Air_Strike_Icon.png")
  , ("Air", "AirSymbolSkylanders.png")
  , ("Ambush", "Ambush_Icon.png")
  , ("Aurora", "Aurora_Icon.png")
  , ("Bad Juju", "Bad_Juju_Icon.png")
  , ("Barbella", "Barbella_Icon.png")
  , ("Bazooker", "Bazooker_symbol.png")
  , ("Blaster-Tron", "Blaster-Tron_Icon.png")
  , ("Boom Bloom", "Boom_Bloom_Icon.png")
  , ("Bowslinger", "Bowslinger_symbol.png")
  , ("Brawler", "Brawler_symbol.png")
  , ("Buckshot", "Buckshot_Icon.png")
  , ("Chain Reaction", "Chain_Reaction_Icon.png")
  , ("Chompy Mage", "Chompy_Mage_Icon.png")
  , ("Chopscotch", "Chopscotch_Icon.png")
  , ("Crash Bandicoot", "Crash_Bandicoot_Icon.png")
  , ("Dark", "DarkSymbolSkylanders.png")
  , ("Dr. Krankcase", "Dr._Krankcase_Icon.png")
  , ("Dr. Neo Cortex", "Dr._Neo_Cortex_Icon.png")
  , ("Earth", "EarthSymbolSkylanders.png")
  , ("Ember", "Ember_Icon.png")
  , ("Fire", "FireSymbolSkylanders.png")
  , ("Flare Wolf", "Flare_Wolf_Icon.png")
  , ("Golden Queen", "Golden_Queen_Icon.png")
  , ("Grave Clobber", "Grave_Clobber_Icon.png")
  , ("Hood Sickle", "Hood_Sickle_Icon.png")
  , ("King Pen", "King_Pen_Icon.png")
  , ("Knight", "Knight_symbol.png")
  , ("Life", "LifeSymbolSkylanders.png")
  , ("Light", "LightSymbolSkylanders.png")
  , ("Magic", "MagicSymbolSkylanders.png")
  , ("Mysticat", "Mysticat_Icon.png")
  , ("Ninja", "Ninja_symbol.png")
  , ("Pain-Yatta", "Pain-Yatta_Icon.png")
  , ("Pit Boss", "Pit_Boss_Icon.png")
  , ("Quickshot", "Quickshot_symbol.png")
  , ("Ro-Bow", "Ro-Bow_Icon.png")
  , ("Senseis", "Senseis.png")
  , ("Sentinel", "Sentinel_symbol.png")
  , ("Smasher", "Smasher_symbol.png")
  , ("Sorcerer", "Sorcerer_symbol.png")
  , ("Starcast", "Starcast_Icon.png")
  , ("Swashbuckler", "Swashbuckler_symbol.png")
  , ("Tae Kwon Crow", "Tae_Kwon_Crow_Icon.png")
  , ("Tech", "TechSymbolSkylanders.png")
  , ("Tidepool", "Tidepool_Icon.png")
  , ("Tri-Tip", "Tri-Tip_Icon.png")
  , ("Undead", "UndeadSymbolSkylanders.png")
  , ("Water", "WaterSymbolSkylanders.png")
  , ("Wild Storm", "Wild_Storm_Icon.png")
  , ("Wolfgang", "Wolfgang_Icon.png")
  , ("KaosElement", "KaosSymbolSkylanders.png")
  , ("Kaos", "Kaos_Icon.png")
  , ("KaosClass", "Kaos_symbol.png")
  ]

-- UPDATE

type Msg
    = Choose Thing String


thingAccessor thing =
    case thing of
        Element -> (.element, (\x y -> {x | element = y}))
        BattleClass -> (.class, (\x y -> {x | class = y}))
        Sensei -> (.name, (\x y -> {x | name = y}))

getter thing =
    case thing of
        Element -> .element
        BattleClass -> .class
        Sensei -> .name

accessor thing =
    let (getter, setter) = thingAccessor thing in
        getter

clearName model =
    {model | name = ""}

clearClassElement model =
    {model | class = "", element = ""}

update: Msg -> Model -> Model
update msg model =
    case msg of
        Choose BattleClass name ->
            clearName { model | class = if model.class == name then "" else name }

        Choose Element name ->
            clearName { model | element = if model.element == name then "" else name }

        Choose Sensei name ->
            let target = lookupSkylander name in
            if model.name == name ||
                ( model.element == target.element && model.class == target.class)
                then Skylander "" "" ""
                else lookupSkylander name

lookupSkylander : String -> Skylander
lookupSkylander name =
    let candidate = List.head <| List.filter (\skylander -> skylander.name == name) skylanders
    in
    case candidate of
        Nothing -> { name = "", element = "", class = "" }
        Just x -> x

nameOnly : Model -> Bool
nameOnly model =
    model.name /= "" &&
    model.class == "" &&
    model.element == ""

-- VIEW

selectedButtons : Model -> List ( Html Msg )
selectedButtons model =
    let source =
            if nameOnly model
                then lookupSkylander model.name
                else model
    in
    List.concat
        (List.map
            (\(get, thing) -> case get source of
                "" -> []
                x -> [ buttonFor model thing x ] )
            [ (.class, BattleClass), (.element, Element)] )

selectorButtons : Model -> Html Msg
selectorButtons model =
    div [class "selector-buttons", style[("flex-direction","column")]] [
        div [class "battle-class"] ( List.map (\name -> buttonFor model BattleClass name) battleClassesList )
        , div [class "Elements"] ( List.map (\name -> buttonFor model Element name) elementList )
    ]

selectedSkylanderButtons : Model -> List (Html Msg)
selectedSkylanderButtons model =
    let skylanderButtons = ( List.map (\key -> ( buttonFor model Sensei key ) ) (List.map .name (currentSkylanders model)))
    in
    skylanderButtons

skylanderName : Model -> String
skylanderName model =
    let { name, element, class } = model
    in case (name, element, class ) of
        ("", "", _) -> ""
        ("", _, "") -> ""
        ("", class, element) ->
            case List.head (currentSkylanders model) of
                Just x -> x.name
                Nothing -> ""
        ( name, _, _ ) -> name

view : Model -> Html Msg
view model =
    div [ style [("display", "flex"),("flex-flow", "column wrap")]]
        [ selectorButtons model
        , hr [] []
        --, div [ class "images"] ( List.map (\key -> ( buttonFor model Sensei key ) ) (List.map .name (currentSkylanders model)))
        , div [ class "images", style [("flex-wrap", "wrap")]] (selectedSkylanderButtons model)
        --, div [ class "foo"] [ text (toString model) ]
        --, div [] [ text (toString (List.map .name (currentSkylanders model) ))]
        , div [] [text (skylanderName model)]
        ]


