---
title: Body node API — createBody, nesting, and container-free interpolation
source: README.md
source_repo: gutentags/koerper
source_commit: 16e26cc0c08382a22d0d6e99d562d140b5bcf18a
source_date: 2016-10-26
source_authors: [Kris Kowal]
ingested: 2026-07-06
ingested_by: scholar
topics: [virtual-dom, html-modules]
status: current
---

Abstract: Koerper's `Document` constructor wraps an element from the actual document and controls its content. `document.createBody()` returns a body node; body nodes can be appended and removed from the virtual document (their content appears or disappears at the corresponding position in the actual document), can nest arbitrarily deeply while retaining the ability to add and remove their children from the actual document, and — because they introduce no container element — can interpolate text directly into the actual document and be inserted into or removed from within another body.

Koerper provides a `Document` constructor that accepts an element from the actual document. The virtual document will control the content of the actual node.

```js
var Document = require("koerper");
var document = new Document(window.document.body);
```

The document has a `createBody()` method that returns an instance of the new body node type.

```js
var body = document.createBody();
```

Body elements can be added and removed from the virtual document, and their content will be added or removed from their corresponding position in the actual document.

```js
body.appendChild(document.createTextNode("Guten Tag, Welt!"));
var em = document.createElement("em");
em.appendChild(body);
document.documentElement.appendChild(em);
```

Body elements can contain deeply nested body elements and retain the ability to add and remove their children from the actual document.

```js
var subBody = document.createBody();
body.appendChild(subBody);
```

Because body nodes do not introduce container elements, you can interpolate text directly on the actual document.

```js
var body = document.createBody();
var greet = document.createTextNode("Guten Tag");
var who = document.createTextNode("Welt");
body.appendChild(greet);
body.appendChild(document.createTextNode(", "));
body.appendChild(who);
body.appendChild(document.createTextNode("!"));
document.documentElement.appendChild(body);
```

And you can insert or remove the body within another body.

```js
var quoted = document.createBody();
quoted.appendChild(document.createTextNode("\""));
quoted.appendChild(body);
quoted.appendChild(document.createTextNode("\""));

// later ...
quoted.removeChild(body);
```

Source: [README.md](https://github.com/gutentags/koerper/blob/16e26cc0c08382a22d0d6e99d562d140b5bcf18a/README.md) at commit `16e26cc`.
