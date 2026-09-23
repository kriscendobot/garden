---
title: The JavaScript implementation and the hookup convention
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

Abstract: An HTML module exports a component constructor and, if a sibling JavaScript module exists, calls into its `hookup(id, child, scope)` method as each child component is added to the scope. The `hookup` method is where the author wires reactive behavior — copying a child iteration's value into a text component, capturing `this`, and so on. Trivial tags need no underlying JavaScript. Compiled, a tag module exports a `Component(body, caller)` constructor: `body` is the virtual-document point the tag controls and `caller` is the scope from which it was instantiated.

A JavaScript module, `list.js`, connects the components of the list. The HTML
module exports a constructor for the module and calls into the `hookup` method
of the underlying JavaScript implementation, if it exists.

```js
'use strict';
module.exports = List;
function List() {}
List.prototype.hookup = function hookup(id, child, scope) {
    if (id === "items:iteration") {
        scope.text.value = child.value;
    } else if (id === "this") {
        this.items = scope.items;
    }
};
```

Trivial tags can live without an underlying JavaScript implementation.

Tag modules compile to JavaScript that export a component constructor. The
constructor accepts a `body` and a `caller` scope.

```
"use strict";
module.exports = Component;
function Component(body, caller) {
    this.scope = caller.root.nestComponents();
    body.appendChild(document.createTextNode("Guten Tag, Welt!\n"));
}
```

Source: [README.md](https://github.com/gutentags/gutentag/blob/38cdebb355f9c09ffbc9b0dcc8bb13a9421dfc88/README.md) at commit `38cdebb`.
