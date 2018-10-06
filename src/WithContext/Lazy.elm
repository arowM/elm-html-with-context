module WithContext.Lazy exposing
    ( lazy
    , lazy2
    , lazy3
    , lazy4
    , lazy5
    , lazy6
    , lazy7
    )

{-| `WithContext` version of `Html.Lazy`.
Rather than immediately applying functions to their arguments, the lazy functions just bundle the function and arguments up for later. When diffing the old and new virtual DOM, it checks to see if all the arguments are equal by reference. If so, it skips calling the function!

See [Html.Lazy](https://package.elm-lang.org/packages/elm/html/latest/Html-Lazy) for detail.

@docs lazy
@docs lazy2
@docs lazy3
@docs lazy4
@docs lazy5
@docs lazy6
@docs lazy7

-}

import Html exposing (Html)
import Html.Lazy as Html
import WithContext exposing (WithContext)


{-| Similar to `fromHtml` but this function does some sort of performance optimization that delays the building of virtual DOM nodes.
-}
lazy : (context -> a -> Html msg) -> a -> WithContext context msg
lazy f a =
    WithContext.fromHtml <| \context -> Html.lazy2 f context a


{-| Same as lazy but checks on two arguments.
-}
lazy2 : (context -> a -> b -> Html msg) -> a -> b -> WithContext context msg
lazy2 f a b =
    WithContext.fromHtml <| \context -> Html.lazy3 f context a b


{-| Same as lazy but checks on three arguments.
-}
lazy3 : (context -> a -> b -> c -> Html msg) -> a -> b -> c -> WithContext context msg
lazy3 f a b c =
    WithContext.fromHtml <| \context -> Html.lazy4 f context a b c


{-| Same as lazy but checks on four arguments.
-}
lazy4 : (context -> a -> b -> c -> d -> Html msg) -> a -> b -> c -> d -> WithContext context msg
lazy4 f a b c d =
    WithContext.fromHtml <| \context -> Html.lazy5 f context a b c d


{-| Same as lazy but checks on five arguments.
-}
lazy5 : (context -> a -> b -> c -> d -> e -> Html msg) -> a -> b -> c -> d -> e -> WithContext context msg
lazy5 f a b c d e =
    WithContext.fromHtml <| \context -> Html.lazy6 f context a b c d e


{-| Same as lazy but checks on six arguments.
-}
lazy6 : (context -> a -> b -> c -> d -> e -> f -> Html msg) -> a -> b -> c -> d -> e -> f -> WithContext context msg
lazy6 func a b c d e f =
    WithContext.fromHtml <| \context -> Html.lazy7 func context a b c d e f


{-| Same as lazy but checks on seven arguments.
-}
lazy7 : (context -> a -> b -> c -> d -> e -> f -> g -> Html msg) -> a -> b -> c -> d -> e -> f -> g -> WithContext context msg
lazy7 func a b c d e f g =
    WithContext.fromHtml <| \context -> Html.lazy8 func context a b c d e f g
