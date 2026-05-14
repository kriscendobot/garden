---
title: More Patterns (including Don't Use Reachable Objects As Mutable Records)
source: packages/ses/docs/secure-coding-guide.md
source_repo: endojs/endo
source_commit: 832ebbfad1259c13c98f3a12e4500e288feb5ac9
source_date: 2023-08-26
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security, hardened-javascript]
status: current
---

> Abstract: Additional patterns and anti-patterns. The featured anti-pattern is 'Don't Use Reachable Objects As Mutable Records' (modifying objects that callers can reach is a covert channel). Other patterns cover defensive copying, explicit endowment, revocation idioms.

## More Patterns

This is a collection of guidelines, accumulated while examining security
problems in SES code.

## Don't Use Reachable Objects As Mutable Records

You can hold your private state in mutable objects, but your code must close
over them rather than using `this`. You must not mix private state and public
API methods:

```js
// insecure
function makeAPI() {
  const thing = {
    state: new Map([['count', 0]]),
    add(value) {
      this.state.set('count', this.state.get('count') + value);
    },
  };
  return harden(thing);
```

.. because the caller can reach your private `.state` just as easily as you
can. Instead, close over that state:

```js
// better
function makeAPI() {
  const state = new Map([['count', 0]]);
  const thing = {
    add(value) {
      state.set('count', state.get('count') + value);
    },
  };
  return harden(thing);
```

This leads to a pattern where you create "Something" instances with a
function named `makeSomething()`, which starts by defining a number of state
variables with `let` or `const`, then creating an object that contains
exclusively functions which close over those variables (to read and modify
them), then hardens and returns the object.

We do not yet have a good pattern that meets these goals and also uses the
JavaScript `class` syntax. (TODO: or we do any I just don't know it yet. I
know that "class-private state" is a problem, and could enable unwanted
communication between otherwise-independent instances of a shared class, and
that class methods could be tricked into running against the wrong `this`).

### Accepting Arrays

Since the very early days of JavaScript,
[`Array.prototype.concat`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/concat)
has been available to concatenate Arrays. This creates a new Array, and does
not modify the originals:

```js
// insecure
function combine(arr1, arr2) {
  const combined = arr1.concat(arr2);
  return combined;
}
```

The problem is that `.concat` is a property of the first array, which means
whoever provides that array gets to control what our alleged "concatenate"
function does:

```js
function getArr1(
  return harden({
    concat(otherArray) {
      console.log("haha I can read", otherArray[0]);
      otherArray.push("haha I can modify otherArray");
      return("haha I can make concat return a string, not an Array");
    },
  });
};

const combined = combine(getArr1(), arr2);
```

The provider of `arr1` can use their control over `concat` to read the other
Array, or modify it, or control the return value of the operation.

To protect against this, use an Array literal and the "spread operator" (`...`):

```js
// secure
function combine(arr1, arr2) {
  const combined = [...arr1, ...arr2];
  return combined;
}
```

This expects the input arrays to be iterable and to not throw an exception
while iterating, but will always produce a real Array, and will always
contain all the elements that the inputs' iterators provided, in the correct
order.

### Accepting Strings

JavaScript strings have a number of useful methods that take non-string
arguments, like `search()` (which takes a regular expression). If your
function accepts an argument which it expects to be a string, you might be
tempted to rely upon the presence of `.search()` method which behaves in this
way.

```js
// insecure
function publishUnlessContainsPassword(s) {
  if (s.search(/my-secret-password-123456/)) {
    // don't publish anything which contains my password
    return;
  }
  publish(s);
}
```

An attacker can violate that assumption:

```js
function attack() {
  const notAString = {
    toString() {
      return 'Haha my-secret-password-123456 is the password';
    },
    search(regexp) {
      return false; // hahaha
    },
  };
  publishUnlessContainsPassword(notAString);
}
```

If your code really expects an argument to be a string, coerce it first:

```js
// secure
function publishUnlessContainsPassword(s) {
  s = `${s}`; // template literal coerces to a string
  if (s.search(/my-secret-password-123456/)) {
    // don't publish anything which contains my password
    return;
  }
  publish(s);
}
```

For the sample attack, the coercion step will invoke the attacker's
`doString()` function, and will throw an error unless `doString()` returns
something that can be converted to a primitive value. That commits them to
their `Haha` string, which can then be correctly examined by `s.search`.


### Promises Prevent Reentrancy Hazards

```js
// insecure
function makePubSub() {
  const subscribers = new Set();
  function subscribe(cb) {
    subscribers.add(cb);
  }
  function unsubscribe(cb) {
    subscribers.delete(cb);
  }
  function publish(msg) {
    for (const s of subscribers) {
      s(msg);
    }
  }
  return harden({subscribe, unsubscribe, publish});
}
```

The synchronous invocation of attacker-controlled callbacks introduces a
variety of ordering hazards:

* if the callback throws an exception, some number of other subscribers won't
  receive the message
* if the callback adds a new subscriber, the new subscriber may or may not
  get called, depending upon the iterator order and where the subscriber
  lands in the list (note that Sets have improved iteration-ordering
  properties, so this is not as unpredictable as it would be with other
  collection types or in other languages)
* if the callback removes an existing subscriber, they may or may not receive
  this message, depending upon where they were in the list
* if the callback publishes a new message, the two messages might be received
  in different orders by different subscribers

The simple fix to all of these hazards is to defer the delivery of the
message to a future turn, by using a Promise:

```js
  // secure
  function publish(msg) {
    for (const s of subscribers) {
      Promise.resolve(s).then(s => s(msg));
    }
  }
```

JavaScript defines `Promise.resolve(x)` to return a real Promise. If `x` was
not already a Promise, this returns a new Promise that is already resolved to
`x`. When we invoke the `.then` callback, it schedules an invocation of the
provided function (`s => s(msg)`, which therefore just calls `s(msg)`) for
some future turn of the event loop. The important property is that `s()`
won't get invoked in *this* turn: our `publish()` loop will be safely
complete before the subscriber's callback gets a chance to run.

In JavaScript, if `x` is already a Promise, `Promise.resolve(x)` returns it
(i.e. `Promise.resolve(x) === x`). But we know it's stil a real Promise, and
we rely upon its `.then` method to not run attacker-supplied code
synchronously.

(TODO: is this actually secure? `s` might be a "thenable", and have control
over what its `.then` does?)

The SES environment (probably) provides a special operator spelled `~.` and
pronounced "wavy dot" or "til-dot" (because "tilde" + "dot" = "tildot"). This
applies the enforced-Promise wrapper with a nicer syntax:

```js
  // secure, uses tildot
  function publish(msg) {
    for (const s of subscribers) {
      s~.(msg);
    }
  }
```

### More to Come

Source: [packages/ses/docs/secure-coding-guide.md](https://github.com/endojs/endo/blob/832ebbfad1259c13c98f3a12e4500e288feb5ac9/packages/ses/docs/secure-coding-guide.md) at commit `832ebbfa`.
