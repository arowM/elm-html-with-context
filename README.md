# elm-html-with-context

Cleaner, hack-free way to pass contexts to Elm view functions.

[![sakura-chan-under-the-bed](https://user-images.githubusercontent.com/1481749/46577798-bc836e00-ca29-11e8-9ea5-97029d9e6c47.jpg)](https://twitter.com/hashtag/%E3%81%95%E3%81%8F%E3%82%89%E3%81%A1%E3%82%83%E3%82%93%E6%97%A5%E8%A8%98?src=hash)

## What's this?

This is an Elm library to pass contexts to all Elm view functions without hacks.
The term "contexts" in this document means some information shared with almost all view functions such as:

* "Which language should we use in this page in the term of i18n?"
* "How we can transform class names in the manner of CSS modules?"
* "Is this page in high contrast mode for accessibility?"

(If you know other use cases, please tell me as an issue.)

In these case, the most simple way to pass contexts to each view function is just pass it as an argument.

```elm
view : Model -> Html Msg
view model =
    column model.context
        [ child0 model.context
        , child1 model.context model.child1
        , child2 model.context
        ]


child1 : Context -> ModelForChild1 -> Html Msg
child1 context model =
    row model.context
        [ grandchild0 context model.foo model.bar
        , grandchild1 context model.baz
        ]

grandchild0 : Context -> Foo -> Bar -> Html Msg
grandchild0 context foo bar =
    ...
```

This strategy works nicely for small projects, but it would be a sort of bucket brigade in large projects.

One of the ways to resolve this is [the technique Ellie app uses](https://discourse.elm-lang.org/t/dependency-injection-how-to-switch-api-server/570/10)

> In Ellie I write a variable with a string value that looks like "%API_BASE%" and then I use a string replacement plugin in my build to replace that string with whatever is in the process env

It's a simple technique, but it's a little hacky and also it only can be used for passing contexts that available on compile time.

## How `elm-html-with-context` works?

The `elm-html-with-context` provide a cleaner, hack-free way to resolve the bucket brigade problem.
The example code above can be rewritten with `elm-html-with-context` as follows.

```elm
{-| First, let's declare our custom `Html_ msg`.
The `Context` is implicitly passed to each view functions.
-}
type alias Html_ msg =
    WithContext Context msg

view : Model -> Html Msg
view model =
    -- Convert from `Html_` to normal `Html` on root view function by passing context.
    WithContext.toHtml model.context <|
        column
            [ child0
            , child1 model.child1
            , child2
            ]


child1 : ModelForChild1 -> Html_ Msg
child1 model =
    row
        [ grandchild0 model.foo model.bar
        , grandchild1 model.baz
        ]

grandchild0 : Foo -> Bar -> Html_ Msg
grandchild0 foo bar =
    WithContext.fromHtml <|
        \context ->
            ...
```

Woohoo! There is no bucket brigade any more.

## Example apps

The `arowM/elm-css-modules-helper` provide [an example app](https://github.com/arowM/elm-css-modules-helper/tree/master/examples/real-world) that shows how to use `elm-html-with-context` for real world applications.
It covers following contents.

* How to create `Html_ msg` elements?
* How to take `Content` in `Html_ msg` elements?
* How to do performance optimization using `Html.lazy` in `elm-html-with-context`?
* How to introduce hack-free CSS modules in Elm?
* How to realize a very beginning of atomic design in Elm?
