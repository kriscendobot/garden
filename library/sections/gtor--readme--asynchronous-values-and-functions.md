---
title: gtor — asynchronous values and functions (promise/resolver/deferred; promise vs task; the async-function promise trampoline)
source: README.md
source_repo: kriskowal/gtor
source_commit: d2a238fce2cc0b73bbaec795a7230473b584fa9d
source_date: 2017-12-04
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [change-propagation, streams]
status: current
---

> Abstract: gtor's singular-temporal column, the promise family. A **promise** is the asynchronous analogue of a getter; its **resolver** is the asynchronous setter; together they are a **deferred** value. The promise's `then` is the singular-temporal analogue of `map`/`flatMap` (it accepts an observer returning either a value or another promise), and `done` is the analogue of `forEach` (observe without capturing a result). The resolver is the singular analogue of a generator but can only `return` or `throw` (not `yield`): `resolve`/`return` is the temporal analogue of `return`, `reject`/`throw` the analogue of `throw`. The load-bearing distinction for the corpus: a **promise is broadcast** (information flows from the first resolver call to all observers, registered before or after resolution, and no observer can interfere with another, so a promise cannot abort the work behind it) whereas a **task is unicast** (one observer, and the observer can push *upstream* by unsubscribing with an error via `task.throw`, foreshadowing streams). The section closes with the async-function promise trampoline: a generator decorated by `Promise.async` that `yield`s promises to await intermediate values, the precedent that, once async functions decouple from generator functions, opens the door to **async generator functions**, the plural-temporal getter and the standard form of a readable stream.

## Promises, resolvers, deferreds

The asynchronous analogue of a getter is a promise. Each promise has a corresponding resolver as its asynchronous setter. Collectively the promise and resolver are a **deferred** value.

The salient method of a promise is `then`, which creates a new promise for the result of a function that will eventually observe the value of the promise. If a promise were plural, `then` might be called `map`; if you care to beg an esoteric distinction, it might be called `map` when the observer returns a value and `flatMap` when it returns a promise. The `then` method allows either.

```js
var promiseForThirty = promiseForTen.then(function (ten) {
    return ten + 20;
})
```

Promises can also have a `done` method that observes the value but does not return a promise nor capture the result of the observer. If a promise were plural, `done` might be called `forEach`. The `then` method also supports a second function observing whether the input promise radiates an exception, with a `catch` shorthand for the error-only case.

A **resolver** is the singular analogue of a generator. Rather than yielding, returning, and throwing, the resolver can only return or throw.

```js
resolver.return(10);
resolver.throw(new Error("Sorry, please return during business hours."));
```

In all positions, `resolve` is the temporal analogue of `return` and `reject` is the temporal analogue of `throw`. (Promises bridged the migration gap from ECMAScript 3 to ECMAScript 6, so non-keyword method names were necessary.) A deferred value can be deferred further by resolving it with another promise, either expressly through the resolver or implicitly by returning a promise from an observer; `then` internally creates a new deferred, returns its promise, and later forwards the observer's return value (or caught error) to the resolver.

The standard `Promise` hides `Promise.defer()`: the constructor reveals `resolve`/`reject` as free arguments to a setup function instead of exposing the deferred and resolver objects, furthering the need for non-keyword names.

```js
var promise = new Promise(function (resolve, reject) {
    // ...
});
```

## Promise (broadcast) versus task (unicast)

The distinction that the rest of the taxonomy turns on:

- With a **promise**, information flows only from the first call to a resolver method to *all* promise observers, whether registered before or after the resolution. A promise is broadcast: no observer can interfere with another, which is exactly why a promise represents a result, not the work leading to it, and cannot abort that work.
- With a **task**, information flows from the first resolver call to the *first* observer call regardless of order, but one kind of information can flow upstream: the observer may unsubscribe with an error. This is conceptually similar to throwing an error back into a generator from an iterator and warrants the same interface.

```js
task.throw(new Error("Never mind"));
```

This upstream-error interface foreshadows the task's plural analogue: streams. See [[gtor--readme--reactivity-taxonomy]] for the broadcast/unicast cut in full.

## Asynchronous functions: the promise trampoline

Combining promises and generator functions emulates asynchronous functions. The key insight is a concise decorator that creates an internal "promise trampoline": an async function returns a promise for the eventual return value (or thrown error) of the generator, but the generator may `yield` promises to wait for intermediate values on its way to completion, taking advantage of an iterator's ability to send a value from `next` to `yield`.

```js
var authenticated = Promise.async(function *() {
    var username = yield getUsernameFromConsole();
    var user = getUserFromDatabase(username);
    var password = getPasswordFromConsole();
    [user, password] = yield Promise.all([user, password]);
    if (hash(password) !== user.passwordHash) {
        throw new Error("Can't authenticate because the password is invalid");
    }
})
```

Mark Miller's `async` decorator is the reference. Each requested iteration has three possible outcomes: **yield** waits for the given promise and resumes the generator with the eventual value; **return** stops the trampoline and returns the value all the way out to the promise the async function returned; a yielded promise that throws resumes the generator with that error, giving it a chance to recover.

```js
Promise.async = function async(generate) {
    return function () {
        function resume(verb, argument) {
            var result;
            try {
                result = generator[verb](argument);
            } catch (exception) {
                return Promise.throw(exception);
            }
            if (result.done) {
                return result.value;
            } else {
                return Promise.return(result.value).then(donext, dothrow);
            }
        }
        var generator = generate.apply(this, arguments);
        var donext = resume.bind(this, "next");
        var dothrow = resume.bind(this, "throw");
        return donext();
    };
}
```

The standards committee later contemplated dedicated `async`/`await` syntax for this case (inspired by C#); one compelling reason for special syntax is that `await` may have higher precedence than `yield`. The closing observation is the bridge to the plural-temporal world: by decoupling **async functions** from **generator functions**, JavaScript opens the door for **async generator functions**, foreshadowing a plural and temporal getter, a standard form for readable streams (developed in [[gtor--readme--asynchronous-generator-functions]]).

Source: [README.md](https://github.com/kriskowal/gtor/blob/d2a238fce2cc0b73bbaec795a7230473b584fa9d/README.md) at commit `d2a238fc` (§ Asynchronous Values / Asynchronous Functions).
