---
title: TrapCaps
source: packages/captp/README.md
source_repo: endojs/endo
source_commit: 1b767034b305
source_date: 2022-01-13
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [captp, capability-security]
status: current
---

> Abstract: TrapCaps: a mechanism for synchronously trapping remote calls into a CapTP system, useful for hooking debuggers or interceptors. Lets code observe (and potentially modify) the message flow at well-defined boundaries.

## TrapCaps

In addition to the normal CapTP facilities, this library also has the notion of
"TrapCaps", which enable a "guest" endpoint to call a "host" object (which may
resolve an answer promise at its convenience), but the guest synchronously
blocks until it receives the resolved answer.

This is a specialized and advanced use case, not for mutually-suspicious CapTP
parties, but instead for clear "guest"/"host" relationship, such as user-space
code and synchronous devices.

1. Supply the `trapHost` and `trapGuest` protocol implementation (such as the
   one based on `SharedArrayBuffers` in `src/atomics.js`) to the host and guest
   `makeCapTP` calls.
2. On the host side, use the returned `makeTrapHandler(target)` to mark a target
   as synchronous-enabled.
3. On the guest side, use the returned `Trap(target)` proxy maker much like
   `E(target)`, but it will return a synchronous result.  `Trap` will throw an
   error if `target` was not marked as a TrapHandler by the host.

To understand how `trapHost` and `trapGuest` relate, consider the `trapHost` as
a maker of AsyncIterators which don't return any useful value.  These specific
iterators are used to drive the transfer of serialized data back to the guest.

`trapGuest` receives arguments to describe the specific trap request, including
`startTrap()` which sends data to the host to perform the actual work of the
trap.  The returned (synchronous) iterator from `startTrap()` drives the async
iterator of the host until it fully transfers the trap results to the guest, and
the guest unblocks.

The Loopback implementation provides partial support for TrapCaps, except it
cannot unwrap promises.  Loopback TrapHandlers must return synchronously, or an
exception will be thrown.

Source: [packages/captp/README.md](https://github.com/endojs/endo/blob/1b767034b305/packages/captp/README.md) at commit `1b767034`.
