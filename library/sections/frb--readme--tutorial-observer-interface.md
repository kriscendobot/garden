---
title: Observers and Nested Observers
source: README.md
source_repo: kriskowal/frb
source_commit: 131db347355789cf2dbb79e49b10881d9716b449
source_date: 2013-09-15
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [reactive-bindings]
status: current
---

> Abstract: FRB's bindings use **observers** and **binders** internally, and the `frb/observe` module exposes the observer directly: `observe(object, path, callback)` returns a `cancel` function. A descriptor may replace the callback, carrying `change`, `beforeChange` (emit the previous value before a change), and `contentChange` (re-emit an array on every content change rather than only once). The crucial architectural aspect surfaces in **nested observers**: an observer callback may return a cancelation function, and that canceler is invoked each time a new value is observed or when the parent observer is canceled. This is what lets observers nest: a parent `observe` returns a child `observe` from its callback, and FRB tears down the child automatically when the parent's value is replaced or the whole tree is canceled.

### Observers

FRB's bindings use observers and binders internally. You can create an observer from a property path with the `observe` function exported by the `frb/observe` module.

```javascript
var results = [];
var object = {foo: {bar: 10}};
var cancel = observe(object, "foo.bar", function (value) {
    results.push(value);
});

object.foo.bar = 10;
expect(results).toEqual([10]);

object.foo.bar = 20;
expect(results).toEqual([10, 20]);
```

For more complex cases, you can specify a descriptor instead of the callback. For example, to observe a property's value *before it changes*, you can use the `beforeChange` flag.

```javascript
var results = [];
var object = {foo: {bar: 10}};
var cancel = observe(object, "foo.bar", {
    change: function (value) {
        results.push(value);
    },
    beforeChange: true
});

expect(results).toEqual([10]);

object.foo.bar = 20;
expect(results).toEqual([10, 10]);

object.foo.bar = 30;
expect(results).toEqual([10, 10, 20]);
```

If the product of an observer is an array, that array is always updated incrementally. It will only get emitted once. If you want it to get emitted every time its content changes, you can use the `contentChange` flag.

```javascript
var lastResult;
var array = [[1, 2, 3], [4, 5, 6]];
observe(array, "map{sum()}", {
    change: function (sums) {
        lastResult = sums.slice();
        // 1. [6, 15]
        // 2. [6, 15, 0]
        // 3. [10, 15, 0]
    },
    contentChange: true
});

expect(lastResult).toEqual([6, 15]);

array.push([0]);
expect(lastResult).toEqual([6, 15, 0]);

array[0].push(4);
expect(lastResult).toEqual([10, 15, 0]);
```

### Nested Observers

To get the same effect as the previous example, you would have to nest your own content change observer.

```javascript
var i = 0;
var array = [[1, 2, 3], [4, 5, 6]];
var cancel = observe(array, "map{sum()}", function (array) {
    function contentChange() {
        if (i === 0) {
            expect(array.slice()).toEqual([6, 15]);
        } else if (i === 1) {
            expect(array.slice()).toEqual([6, 15, 0]);
        } else if (i === 2) {
            expect(array.slice()).toEqual([10, 15, 0]);
        }
        i++;
    }
    contentChange();
    array.addContentChangeListener(contentChange);
    return function cancelContentChange() {
        array.removeContentChangeListener(contentChange);
    };
});
array.push([0]);
array[0].push(4);
cancel();
```

This illustrates one crucial aspect of the architecture. Observers return cancelation functions. You can also return a cancelation function inside a callback observer. That canceler will get called each time a new value is observed, or when the parent observer is canceled. This makes it possible to nest observers.

```javascript
var object = {foo: {bar: 10}};
var cancel = observe(object, "foo", function (foo) {
    return observe(foo, "bar", function (bar) {
        expect(bar).toBe(10);
    });
});
```

Source: [README.md](https://github.com/kriskowal/frb/blob/131db347355789cf2dbb79e49b10881d9716b449/README.md) at commit `131db347`.
