---
title: The scope object model — root, parent, this, components, caller, argument
source: README.md
source_repo: gutentags/gutentag
source_commit: 38cdebb355f9c09ffbc9b0dcc8bb13a9421dfc88
source_date: 2017-03-07
source_authors: [Kris Kowal]
ingested: 2026-07-06
ingested_by: scholar
topics: [html-modules]
status: current
---

Abstract: The `caller` object is a scope container whose properties inherit along a prototype chain up to the root scope, making the root an ideal dependency-injection container. Key references: `scope.root` (the root scope reachable from any descendant), `scope.parent` (the immediate parent), `scope.this` (the component instantiated by the containing tag document), `scope.components` (identifier → component-instance map), `scope.caller` (the lexical scope of the instantiating tag), and `scope.argument` (a template for the instantiating tag's content). The structural tags create child scopes whose `scope.components` inherits prototypically from `scope.parent.components`, so a nested component sees its ancestors' components while a header sees itself as if alone.

The `caller` object is a scope container that inherits properties along its
prototype chain up to the root scope. This makes the root scope object an ideal
container for dependency injection. `scope.root` refers to that root scope from
any descendant scope. Each scope also has a direct reference to its
`scope.parent`.

In a component, `scope.this` will always refer to the component instantiated by
the containing tag document. So, in `foo.html`, `scope.this` is the containing
instance of the `Foo` component. The `scope.components` object maps component
identifiers in that scope to their corresponding component instance.

Every subcomponent has a scope, but many scopes share the same
`scope.components`. The body of an HTML tag is the root of a lexical scope and
introduces an empty `scope.components` object to which each child component adds
itself. Note that Guten Tag trims implied white space between tags and the
`<sp>` special tag notes explicit template text.

```html
<!doctype html>
<html>
    <head>
        <link rel="tag" href="gutentag/text.html">
    </head>
    <body>
        <text id="hello"></text><sp>, </sp>
        <text id="person">!
    </body>
</html>
```

The Guten Tag building blocks, `<repeat>`, `<reveal>`, and `<choose>` create
child scopes that introduce a new `scope.components` object that inherits
prototypically from the containing scope's components, `scope.parent.components`.
In this example, the "hello" and "person" components are each within a
"greetings:iteration" component and have access to `scope.components.header`,
but from the perspective of the "header", it is in a scope by itself.

```html
<!doctype html>
<html>
    <head>
        <link rel="tag" href="gutentag/text.html">
        <link rel="tag" href="gutentag/repeat.html">
    </head>
    <body>
        <h1><text id="header"></h1>
        <repeat id="greetings">
            <text id="hello"></text><sp>, </sp>
            <text id="person">!
        </repeat>
    </body>
</html>
```

Each scope may also have a `scope.caller` property, referring to the lexical
scope of the tag that instantiated this component, and a `scope.argument`
referring to a template for the content of the instantiating tag. Instantiating
a tag from within a tag also passes its inner content as a template in the form
requested by that tag through its `<meta accepts>` header. For example,
`text.html` has `<meta accepts="[text]">`, `repeat.html` has `<meta
accepts="[body]">`, and `choose.html` has `<meta accepts="[entries]">`. Each of
these packs the content into `caller.argument` in the fashion expected by the
component.

Source: [README.md](https://github.com/gutentags/gutentag/blob/38cdebb355f9c09ffbc9b0dcc8bb13a9421dfc88/README.md) at commit `38cdebb`.
