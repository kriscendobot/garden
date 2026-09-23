---
title: copy micro-utility
source: packages/copy/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-11-06
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/copy` is a micro-utility that copies owned (enumerable, `hasOwnProperty`-checked) properties from a source object to a target object. The `@collections` suite uses it to mix generic prototypes: `copy(Map.prototype, GenericMap.prototype)` grafts a mixin's derived methods onto a concrete structure's prototype. Unlike the other `@collections/*` operators it is **not** a [[polymorphic-operator]]: there is no method-delegation branch, just the property copy.

Copy is a micro-utility that copies owned properties from one object to another.

```js
function copy(target, source) {
    for (var name in source) {
        if (hasOwnProperty.call(source, name)) {
            target[name] = source[name];
        }
    }
}
```

The `@collections` suite uses the copy method to mix generic prototypes.

```js
var copy = require("@collections/copy");
var GenericMap = require("@collections/generic-map");

function Map() {}

copy(Map.prototype, GenericMap.prototype);
```

(Copyright 2017 Kristopher Michael Kowal and contributors, MIT License.)

Source: [packages/copy/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/copy/README.md) at commit `4688abad`.
