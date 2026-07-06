---
title: Parsing and stringifying — parse5 driver and the serializers
source: README.md
source_repo: gutentags/wizdom
source_commit: 35906edce3902e947c1ea73308f9c70310c960c0
source_date: 2015-03-14
source_authors: [Kris Kowal]
ingested: 2026-07-06
ingested_by: scholar
topics: [virtual-dom]
status: current
---

Abstract: Wizdom builds documents from text and serializes them back. The `wizdom/parse5` module accepts a string of HTML, a document (any valid document), and a parse5 `SimpleApiParser` (or facsimile), and drives the population of that document from the string — so parse5 supplies the parser and Wizdom supplies the DOM builder. For the reverse direction Wizdom provides `wizdom/inner-text` (tags stripped), `wizdom/inner-html`, and `wizdom/outer-html`, each a standalone function over a node.

The parse5 HTML parser package provides a utility for driving a DOM builder. For the convenience of constructing Wizdom documents from text, Wizdom provides a module that accepts a string of HTML, a document (any valid document), and a parse5 `SimpleApiParser` (or facsimile thereof), and drives the population of that document from the string.

```js
var Document = require("wizdom");
var parseInto = require("wizdom/parse5");
var parse5 = require("parse5");

var document = new Document();
parseInto("<!doctype><html></html>", document, parse5.SimpleApiParser);
```

Wizdom provides functions for serializing a document as either HTML or text (stripping out the tags).

```js
var Document = require("wizdom");
var getInnerText = require("wizdom/inner-text");
var getInnerHtml = require("wizdom/inner-html");
var getOuterHtml = require("wizdom/outer-html");

var document = new Document();
var body = document.createElement("body");
body.appendChild(document.createTextNode("Guten Tag, Welt!"));

expect(getInnerText(body)).toBe("Guten Tag, Welt!");
expect(getInnerHtml(body)).toBe("Guten Tag, Welt!");
expect(getOuterHtml(body)).toBe("<body>Guten Tag, Welt!</body>");
```

Source: [README.md](https://github.com/gutentags/wizdom/blob/35906edce3902e947c1ea73308f9c70310c960c0/README.md) at commit `35906ed`.
