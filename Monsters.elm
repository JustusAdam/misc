import Json.Decoder as Json exposing ((:=))

type alias Model =
  { name : String
  , image : String
  , description : String
  , hp: Int
  }


decodeModel : Decoder Model
decodeModel = 
  Json.object4 Model
    ("name":= Json.string)
    ("image" := Json.string)
    ("description" := Json.string)
    ("hp" := Json.int)
    

decodeDataFile : Decoder (List Model)
decodeDataFile = "data" := Json.list decodeModel