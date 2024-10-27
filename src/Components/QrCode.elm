module Components.QrCode exposing (qrCode, view, withSize)

import Html exposing (Html)
import Html.Attributes as Attr
import QRCode


type alias QrCode =
    { text : String
    , size : Int
    , errorCorrection : QRCode.ErrorCorrection
    }


qrCode : String -> QrCode
qrCode text =
    { text = text
    , size = 400
    , errorCorrection = QRCode.High
    }


withSize : Int -> QrCode -> QrCode
withSize size qrCodeInput =
    { qrCodeInput | size = size }


view : QrCode -> Html msg
view config =
    Html.div
        [ Attr.class "flex justify-center items-center w-full overflow-hidden my-4 sm:max-w-[250px] sm:mx-auto"
        ]
        [ QRCode.fromString config.text
            |> Result.map
                (QRCode.toSvg
                    [ Attr.width config.size
                    , Attr.height config.size
                    ]
                )
            |> Result.withDefault (Html.text "Error while encoding to QRCode.")
        ]
