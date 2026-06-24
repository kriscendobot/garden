---
title: "[Promise and Resolver Objects](#promise-objects)"
source: "draft-specifications/CapTP Specification.md"
source_repo: kriscendobot/ocapn
source_commit: 8704f69e01f93701de8bc5eb4bb22b9927a2665a
source_date: 2026-03-12
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn, captp, eventual-send]
status: current
notes: Maps to library/sections/endo--pkg-eventual-send-readme--handled-promise.md and library/sections/endo--pkg-eventual-send-readme--promise-pipelining.md.
parent: ocapn--draft-specifications-captp--promises
---

Promises work like regular objects in CapTP. Promises come as a pair:

- The promise object itself which represents a value.
- The resolver object which is used to provide the promise with its resolved
  value, or break it in the case of an error.

 The promise object may eventually resolve to either a concrete value, object
 reference, another promise (in the case of promise pipelining), or may break.
 When a promise breaks its resolved with an error, breakages can be caused by
 either explicit instruction, by implicit error propagation, or network
 partition.

Promises can be listened to with the [`op:listen`](#oplisten) operation, or
messages can be sent to them as if it were the resolved object. The messages
will be relayed to the eventual object if it is `fulfill`ed to one. If the
promise instead `break`s and thus has no resolved object, messages cannot be
delivered and promises created during the sending of those messages should also
break.

The behavor of the two messages on the resolver object are as follows:

- `fulfill`: Provide the promise with its fulfillment values (success case)
- `break`: Breaks the promise (usually due to an error)

### `fulfill`

This method takes exactly one argument, the fulfillment value for the promise.
The value may be any passable value.

### `break`

Break takes a single argument, a value that represents an error that occured.
This error should be delivered to any listeners of the promise.

**NOTE:** The value of errors transmitted over CapTP is up to the transmitting
party. However, including the contents of exception objects or debugging
information such as backtraces could unintentionally leak sensitive information.
It may be valuable at a CapTP border to strip certain kinds of debugging
information, to encrypt its contents, or to use the sealer/unsealer pattern from
capability literature to secure its contents so that only parties with the
relevant sealers/unsealers can safely decode them.

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
