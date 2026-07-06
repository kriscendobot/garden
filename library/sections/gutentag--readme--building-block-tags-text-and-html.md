---
title: Building-block tags — text.html and html.html
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

Abstract: The two value-controlling building-block tags. `text.html` controls a text node from its `value` property, defaulting to the argument's innerText when `value` is null/undefined. `html.html` controls a block of HTML at its position from its `value`; like the text tag it introduces no wrapper element, and because `html` is a reserved HTML5 tag name it must be linked under an alternate name (`as="x-html"`) or used in XML. All the Guten Tag building blocks have very simple implementations that you can copy and modify, and each exposes a mutable `value` property; worked examples live under `essays/text` and `essays/html`.

The gutentags project provides the building block tags, all of which have very
simple implementations that you can copy and modify for your needs. They all
have a mutable `value` property:

- `text.html` controls inline text
- `html.html` controls an inline block of HTML
- `repeat.html` repeats its argument
- `reveal.html` shows or hides its argument
- `switch.html` shows one of its argument tags

### text.html

A text tag controls a text node based on its `value` property. The default text,
if its value property is `null` or `undefined`, is the innerText of the
argument.

```html
<!doctype html>
<html>
    <head>
        <link rel="tag" href="gutentag/text.html">
    </head>
    <body>
        <text id="description">Beschreibung bevorstehende.</text>
    </body>
</html>
```

```js
text.value = "Guten Tag, Welt!";
```

Take a peek at `essays/text`.

### html.html

An HTML tag controls the HTML that appears at its position based on its `value`
property. Like a text tag, the HTML tag does not introduce a wrapper element.
Note that `html` is a special tag in the HTML5 vocabulary, so this tag has to be
linked by an alternate tag name or used in XML.

```html
<!doctype html>
<html>
    <head>
        <link rel="tag" href="gutentag/html.html" as="x-html">
    </head>
    <body>
        <x-html id="description"></x-html>
    </body>
</html>
```

```js
html.value = "<b>Bold <i>and</b> italic</b></i>";
```

Take a peek at `essays/html`.

Source: [README.md](https://github.com/gutentags/gutentag/blob/38cdebb355f9c09ffbc9b0dcc8bb13a9421dfc88/README.md) at commit `38cdebb`.
