---
title: Basic SES Example
source: packages/ses/docs/secure-coding-guide.md
source_repo: endojs/endo
source_commit: 832ebbfad1259c13c98f3a12e4500e288feb5ac9
source_date: 2023-08-26
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security, hardened-javascript, compartments]
status: current
---

> Abstract: The same example rewritten under SES discipline: hardened values, explicit endowments, no shared mutable globals. Demonstrates the safe patterns: harden() at the boundary, Far() for capabilities, Compartment for guest-code isolation, defensive receive. The substantial body of the document.

## Basic SES Example

The basic logger example in SES looks exactly the same.

```js
// in SES, but not secure
function makeLogger() {
  const log = [];
  function write(msg) {
    log.push(msg);
  }
  function read() {
    return log;
  }

  // give 'write' to writer, 'read' to reader
  return { write, read };
}
```

Under SES, we no longer need to worry about `Array` being modified, but we're
still giving the reader too much authority:

```js
function writer(write) {
  Array.prototype.push = function(msg) {
    console.log('haha I ate your message');
  }; // throws error: Array.prototype is frozen
}

function reader(log) {
  log.pop(); // still works
}
```

To fix this, we must not reveal the mutable array to anyone unless we want
them to be able to mutate it. Since JavaScript does not have any form of
snapshot or copy-on-write data structures, we must return a new copy of the
array.

```js
// more secure
function makeLogger() {
  const log = [];
  function write(msg) {
    log.push(msg);
  }
  function read() {
    return [...log];
  }
  return { write, read };
}
```

This still suffers from a problem: it grants a communication channel between
multiple holders of one of the API functions. Two principles of
object-capability security are **no ambient authority**, and **connectivity
begets connectivity**. That means the *only* way for two objects to talk to
each other or have any causal influence over each other is for there to be a
path in the object graph that reaches both of them. Every object in that path
gets to decide how much influence to allow.

The log Array is obviously a communication channel between writers and
readers: that one is explicit and intentional. The surprising channel is
through the `write` function itself (and `read` too), because in JavaScript,
`Function`s are just callable `Object`s, and Objects are mutable. SES freezes
the *prototypes* of `Object` and `Function`, but it is up to application code
to freeze any new instances it makes.

```js
function writer1(write) {
  write.messageToWriter2 = "psst hey buddy";
}

function writer2(write) {
  console.log("got message", write.messageToWriter2);
}
```

To fix this, we should use [`harden`](https://github.com/Agoric/harden) to
recursively freeze the surface of any objects we use in the API. This applies
`Object.freeze` to its argument, to all its enumerable properties, and its
prototype, recursively. This does not require the object to be immutable:
hardened `Set` and `Map` objects can still be modified with the usual
`get/set/add` methods, but it means that the `Map` will behave as expected:
one caller cannot modify `set` to mean something different. Hardened `Array`s
are entirely immutable, however.

It is extremely common for the hardened object to close over mutable state.
This is a standard pattern for the construction of object-oriented behavior
in SES.

```js
// even more secure
import harden from '@agoric/harden';
function makeLogger() {
  const log = [];
  function write(msg) {
    log.push(msg);
  }
  function read() {
    return [...log];
  }
  return harden({ write, read });
}
```

Hardening also protects against one client changing the behavior of a shared
API object. Imagine a different service that provides two methods to one
customer, and a third method to another:

```js
// insecure
function makeCounter() {
  let count = 0;
  function increment() {
    count += 1;
  }
  function decrement() {
    count -= 1;
  }
  function read() {
    return count;
  }
  const updown = { increment, decrement };
  return { updown, read };
}
```

Without the hardening, one `updown` client could change the behavior of
`decrement` that the other client is relying upon, violating our requirement
of Defensive Consistency (a badly-behaving customer should not be able to
induce bad results for correctly-behaving customers):

```js
function writer1(updown) {
  updown.decrement = function() {
    console.log('haha today is backwards day');
    updown.increment();
  };
}
function writer2(updown) {
  updown.decrement(); // NARRATOR VOICE: .. not actually decrementing
}
```

The fix, of course, is to harden the composite return object, remembering
that `harden()` is recursive:

```js
// better
function makeCounter() {
  let count = 0;
  function increment() {
    count += 1;
  }
  function decrement() {
    count -= 1;
  }
  function read() {
    return count;
  }
  const updown = { increment, decrement };
  return harden({ updown, read });
}
```

Going back to our `makeLogger` example, there is one more problem remaining,
although it is a subtle one: the API grants storage to the reader. It may not
be obvious why this is troublesome, but consider that the ability to remember
things is an interesting authority, which one compartment might want to
withhold from another. Think of a videogame that you're trying to complete:
you'd like to be able to reset the game to the beginning, but if the game can
hold state, then it may stubbornly insist upon bringing you back to the same
place where you keep losing every time. You (as the owner of the container in
which the game runs) would like to be able to erase its memory, or prevent it
from remembering things in the first place.

The `reader` is being granted a *mutable* array, albeit a separate copy than
the one the logger is relying upon. If everyone else has been careful to not
give any long-term storage to the reader, then this would violate that plan.
To avoid this, we should `harden` the array before returning it:

```js
// most secure
import harden from '@agoric/harden';
function makeLogger() {
  const log = [];
  function write(msg) {
    log.push(msg);
  }
  function read() {
    return harden([...log]);
  }
  return harden({ write, read });
}
```

If we hadn't hardened the `write` and `read` objects, then their mutable
properties could have been used to store data as well. Each `read()` call is
made by a single caller, so a mutable return value isn't opening up an
obvious communication channel between previously non-communicating parties.
But the mutability of that Array is effectively enabling communication across
*time*, between two subsequent instances of the same party.

You should get into the habit of applying `harden()` to all objects, just
before you return from each function. Remember that `harden` is recursive,
which has two consequences:

* you don't need to `harden` an object that will be included as a property of
  some other hardened object: you only have to `harden` the top-most object
* any Arrays reachable from the hardened object will become immutable


Source: [packages/ses/docs/secure-coding-guide.md](https://github.com/endojs/endo/blob/832ebbfad1259c13c98f3a12e4500e288feb5ac9/packages/ses/docs/secure-coding-guide.md) at commit `832ebbfa`.
