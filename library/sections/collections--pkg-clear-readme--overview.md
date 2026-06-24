---
title: clear operator
source: packages/clear/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-11-06
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/clear` exports a `clear` operator that empties a collection in place. For arrays it removes all entries; for plain objects it deletes all enumerable properties; for any object implementing a `clear` method it delegates to that method. The method-delegation is the [[polymorphic-operator]] dispatch pattern, and it is what lets `clear` work uniformly on a plain array and on an observable array whose `clear` is overridden to dispatch ranged content-change notifications.

This package exports a clear operator that accepts an array, object, or any other object that implements the clear method. For objects, the clear method deletes all enumerable properties.

```js
var clear = require("@collections/clear");

var array = [1, 2, 3];
clear(array);
expect(array).toEqual([]);

var object = {a: 10, b: 20};
clear(object);
expect(object).toEqual({});

var instance = {
    clear: function () {
        throw new TypeError("Can't clear");
    }
};
expect(function () {
    clear(instance);
}).toThrow();
```

## Polymorphic operator

The clear operator delegates to the `clear` method of the given object if it is implemented. This is particularly useful for cases where the object may be an array or an observable array, for which the `clear` method has been overridden to dispatch ranged content changes. See [[polymorphic-operator]] for the shared dispatch discipline (cover for higher architectural layers, defer to a method name a later type may define, rather than monkey-patching backward).

(Copyright 2015 Kristopher Michael Kowal and contributors, MIT License.)

Source: [packages/clear/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/clear/README.md) at commit `4688abad`.
