module WithContext exposing
    ( WithContext
    , fromHtml
    , toHtml
    , node
    , text
    , lift
    )

{-| Cleaner, hack-free way to pass contexts to Elm view functions


# Types

@docs WithContext


# Converters

@docs fromHtml
@docs toHtml
@docs withHtml


# Core functions

@docs node
@docs text


# Low level functions

@docs lift

-}

import Html exposing (Attribute, Html)
import Html.Lazy as Html


{-| An opaque type representing `Html` with a context.
-}
type WithContext context msg
    = Node (context -> List (Html msg) -> Html msg) (List (WithContext context msg))
    | Leaf (context -> Html msg)


{-| A constructor for `WithContext` from `Html`.
-}
fromHtml : (context -> Html msg) -> WithContext context msg
fromHtml =
    Leaf


{-| Convert to `Html`.
-}
toHtml : context -> WithContext context msg -> Html msg
toHtml context wc =
    case wc of
        Node f children ->
            f context <| List.map (toHtml context) children

        Leaf f ->
            Html.lazy f context


{-| Custom node.
-}
node : (context -> List (Html msg) -> Html msg) -> List (WithContext context msg) -> WithContext context msg
node =
    Node


{-| Text node.
-}
text : (context -> String) -> WithContext context msg
text f =
    Leaf <| \context -> Html.text <| f context


{-| This function is supposed to be used with functions in `WithContext.Lazy`.
Please see [actual use case](#todo) for detail.
-}
lift : (context -> subContext) -> WithContext subContext msg -> WithContext context msg
lift f wc =
    case wc of
        Node g children ->
            Node (g << f) <| List.map (lift f) children

        Leaf g ->
            Leaf <| g << f
