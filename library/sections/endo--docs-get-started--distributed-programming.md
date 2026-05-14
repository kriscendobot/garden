---
title: Distributed Programming with Endo
source: docs/get-started.md
source_repo: endojs/endo
source_commit: 5fefef59b558ba6fb07aad42e3d089e49f81341a
source_date: 2025-12-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [getting-started, eventual-send, captp, ocapn, capability-security]
status: current
---

> Abstract: Distributed programming concepts via Endo: eventual-send (E() / E.when), capability-bearing remotables, the OCapN family of transport protocols (CapTP, marshal, netstring), and the daemon model. The second substantial section; introduces the distributed half of the Endo programming model after the local-confinement half.

## Distributed Programming with Endo

Endo also provides tools that let programmers communicate between processes
and over networks with asynchronous, object-oriented message passing.
This is not merely RPC.
With a _Capability Transfer Protocol_, we can serialize references
to remote objects without moving their state, and we can
[pipeline](https://en.wikipedia.org/wiki/Futures_and_promises#Promise_pipelining)
invocations through a locally pending promise for a remote reference.

The heart of this abstraction is _eventual send_, which generalizes promises so
that messages can pass through a pending _handled promise_ for a remote
reference.
In this example, we send three method invocations immediately and wait once for
the final result.
With this form, we can interact with remote objects without any degree of
coupling to the specific protocol used to communicate with the remote side.

```js
const promise1 = E(remote1).method1();
const promise2 = E(promise1).method3();
await E(promise2).method3();
```

For a concrete protocol, we provide `@endo/captp` and are participating
in the development of a new protocol, [OCapN][].

> Other _capability transfer protocols_ include
> [Cap’n Proto](https://capnproto.org/),
> [Cap’n Web](https://github.com/cloudflare/capnweb),
> and the original [CapTP from the E programming language](http://erights.org/elib/distrib/captp/index.html).

We can demonstrate CapTP locally by creating a message pipe between two
parties, Alice and Bob, in a single process.
We will need some kit.

```
npm install @endo/init
npm install @endo/captp
npm install @endo/stream
npm install @endo/eventual-send
npm install @endo/exo
npm install @endo/patterns
```

- `@endo/init` is a thin wrapper around `ses` that ensures that `lockdown` gets
  as part of the initialization of this module, so every subsequent module can
  use the HardenedJS base environment.
- `@endo/captp` is our protocol, but is not coupled to a particular transport
  layer, so you can run it over `WebSocket`, `MessagePort`, or any other
  message framing protocol.
- `@endo/stream` is a utility for connecting async iterators, included here
  just to emulate a duplex connection locally.
- `@endo/eventual-send` lets us send messages to targets.
- `@endo/exo` lets us make targets that can receive messages.
- `@endo/patterns` lets us define schemas for targets and validate them at
  runtime.
  This greatly reduces the target's burden to defend against misshapen
  arguments.

In the program, we have separate sections for Alice and Bob, which you can
imagine to be in different processes or connected only through a network.
Some low-level machinery moves messages between them.
Alice defines a _bootstrap_ object which is the first target that Bob can
send messages to when they're connected.

In this example, Alice implements `ping` and Bob invokes `ping` remotely.

```js
import '@endo/init';
import { makeCapTP } from '@endo/captp';
import { makePipe } from '@endo/stream';
import { makeExo } from '@endo/exo';
import { M } from '@endo/patterns';
import { E } from '@endo/eventual-send';

// Construct a fake duplex connection
const [fromAlice, toBob] = makePipe();
const [fromBob, toAlice] = makePipe();

// Define the valid method invocation patterns of Alice targets.
const AliceShape = M.interface('Alice', {
  ping: M.call().returns(),
});

// This is Alice's program, where she provides a Pinger.
(async function makeAlice() {
  const bootstrap = makeExo('Alice', AliceShape, {
    ping() {
      console.log('Ping!');
    },
  });

  // This bit of machinery pumps messages through the pipes above.
  const send = message => {
    toBob.next(message);
  };
  const { dispatch, abort } = makeCapTP('alice', send, bootstrap);
  for await (const message of fromBob) {
    dispatch(message);
  }
})();

(async function makeBob() {
  // Bob's CapTP message pump.
  const send = message => {
    toAlice.next(message);
  };
  const { dispatch, getBootstrap, abort } = makeCapTP('alice', send);
  (async () => {
    for await (const message of fromAlice) {
      dispatch(message);
    }
  })();

  // We get the first (and currently only) target exported
  // by Alice.
  const alice = getBootstrap();

  // And we invoke its one method. Ping!
  await E(alice).ping();
})();
```

This system eliminates the need for ad-hoc message protocols for the control
plane between processes or in distributed systems and frees the developer to
design secure protocols with _objects_ and _interfaces_, while retaining
the expressivity of object oriented programming.
The protocol naturally multiplexes messages from any process to any object.
Additionally, OCapN enables us to introduce references to third-party
capabilities, such that connections between peers are created and destroyed
automatically, securely, and on-demand.

We expect this programming model to enable JavaScript programs to more readilly
harness local parallism and also compose much more easily and safely express
policy in distributed systems.


Source: [docs/get-started.md](https://github.com/endojs/endo/blob/5fefef59b558ba6fb07aad42e3d089e49f81341a/docs/get-started.md) at commit `5fefef59`.
