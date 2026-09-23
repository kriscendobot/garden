---
title: "[`op:listen`](#oplisten)"
source: "draft-specifications/CapTP Specification.md"
source_repo: kriscendobot/ocapn
source_commit: 8704f69e01f93701de8bc5eb4bb22b9927a2665a
source_date: 2026-03-12
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn, captp]
status: current
notes: 9 H2 ops consolidated into one section. op:start-session, op:deliver, op:abort, op:listen, op:get, op:index, op:untag, op:gc-exports, op:gc-answers. Each is independently looked-up-able by the H2 anchor within the consolidated body.
parent: ocapn--draft-specifications-captp--operations
---

This is used to listen to a promise. This is done in order to get notified when
the promise is:

1. Fulfilled with a value
2. Broken on an error
3. Eventually fulfilled with a promise on our peer
4. Eventually fulfilled with a promise on a third peer

Please see the [promises section](#promises) for more information on how 
promises work.

The `op:listen` message is:

```text
<op:listen to-desc           ; desc:export | desc:answer
           listen-desc>      ; desc:import-object | desc:import-promise
```

Any notification is considered to conclude the `op:listen` interaction, and if 
future notifications are desired (e.g., after chaining to a promise on a third 
peer) then further `op:listen` operations should be sent.

### Sending

`to-desc` MUST be a `desc:export` or `desc:answer` which corresponds to a
promise on the remote side.

`listen-desc` MUST be a `desc:import` that is being imported. This will be
invoked when the promise comes to a resolution.

### Receiving

When receiving this message, providing `to-desc` matches a promise exported to
this session, a mechanism MUST be setup to fulfill or break the provided
resolver when a resolution is available to the `listen-desc` object. If a
resolution is already available, the resolver provided in `listen-desc` MUST be
fulfilled or broken.

An `op:listen` request should NOT be notified when the promise is fulfilled 
with another promise on the same peer unless that promise has been settled to
either a value or an error, in which case the `op:listen` request is informed
of the settled result.

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
