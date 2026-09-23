---
title: Sending Messages with Presences (E() wrapper, return values, rejected promises)
source: packages/SwingSet/README.md
source_repo: agoric/agoric-sdk
source_commit: 7d95438c0888b5f7e903e258013d30b66f2458cf
source_date: 2025-10-25
source_authors: [Richard Gibson]
ingested: 2026-05-14
ingested_by: scholar
topics: [eventual-send, capability-security]
status: current
notes: The "E() can target a not-yet-fulfilled Promise" property is what makes promise pipelining (the next section) possible. The rejection-becomes-rejected-eventual-send rule is the standard error-propagation semantics for capability-bearing async messaging.
---

> Abstract: Each Remotable that arrives in inbound-message data is represented locally as a **Presence** — a special empty object representing a non-local Remotable. The `E()` wrapper sends messages to Presences (or Remotables, or Promises). Eventual-sends return a Promise for the eventual result. Eventual-sends can target a **not-yet-fulfilled Promise**, deferring invocation until the Promise fulfills to an object; if the target Promise rejects or fulfills to something that's not a Remotable/Presence supporting the method, the method is not invoked and the eventual-send's promise is rejected.

### Sending Messages with Presences

Each Remotable object in the data of inbound messages arrives locally as a Presence. This is a special (empty) object that represents a non-local Remotable (i.e., a Remotable hosted by a remote Vat), and can be used to send it messages via the special `E()` wrapper.

Suppose Vat "bob" defines a Root Object with a method named `bar`. The bootstrap vat receives this as `vats.bob`, and can send a message like so:

```js
function bootstrap(argv, vats) {
  void E(vats.bob).bar('hello bob');
}
```

### Return Values

Eventual-sends return a Promise for their eventual result:

```js
const fooP = E(bob).foo();
fooP.then(
  fulfillment => console.log('foo said', fulfillment),
  rejection => console.log('foo errored with', rejection),
);
```

### Sending Messages to Promises

Eventual-sends can target a not-yet-fulfilled Promise, deferring invocation of the method until the Promise fulfills to an object.

If the target Promise rejects, or fulfills to something other than a Remotable or Presence which supports the method, the method is not invoked and the eventual-send promise is rejected.

```js
const badP = Promise.reject(Error());
const p2 = E(badP).foo();
p2.then(undefined, rej => console.log('rejected', rej));
// prints 'rejected'
```

Source: [packages/SwingSet/README.md](https://github.com/Agoric/agoric-sdk/blob/7d95438c0888b5f7e903e258013d30b66f2458cf/packages/SwingSet/README.md) at commit `7d95438c`.
