---
title: Stage 2 — promises, op:deliver with replies, op:listen
source: implementation-guide/Implementation Guide.md
source_repo: kriscendobot/ocapn
source_commit: 8704f69e01f93701de8bc5eb4bb22b9927a2665a
source_date: 2026-03-12
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
topics: [ocapn, captp, eventual-send]
status: current
notes: The "promise pair = vow + resolver" decomposition matches Endo's promise-kit (endo--pkg-promise-kit-readme--*) and eventual-send (endo--pkg-eventual-send-readme--*). The `desc:import-promise` distinction (vs `desc:import-object`) at the receive boundary is the canonical place to set up the local promise pair and the `op:listen` follow-up. The op:abort-breaks-all-pending-promises pattern is necessary for correctness and is mirrored in Endo's HandledPromise infrastructure.
---

> Abstract: Stage 2 milestone: get a response back. A "promise pair" is a vow (the future-value object) + a resolver (the capability to resolve the vow once). The sender of an `op:deliver` puts a fresh resolver as the `resolve-me-desc`; the remote object delivers `['fulfill <value>]` to it when ready. Replies can themselves be promises (`desc:import-promise` instead of `desc:import-object`); the receiver creates a local promise pair and sends `op:listen` (`to-desc` = the remote promise, `listen-desc` = the resolver) to chain. When `op:abort` happens, all unresolved promises in the session break with a network-partition error. Promises can also resolve as `['break <reason>]`, e.g., when the robot can't move forward.

### Stage 2: promises, op:deliver with replies, op:listen

#### Promises

When sending messages, you often want a response. If the object is remote it might take a while; it might fail entirely. CapTP provides this via **promises**. A promise has two parts (a "promise pair"):

- a **promise** (or **vow**): represents the eventual answer.
- a **resolver**: a capability which accepts a resolution and notifies listeners.

Alisha implements a local object for each promise she creates (the "vow"). The vow tracks whether it has a value and supports adding listeners. She then implements the resolver, which has the capability to resolve the vow once; once resolved, it stops accepting new answers.

She looks at `op:deliver` again:

```
<op:deliver to-desc           ; desc:export
            args              ; sequence
            answer-pos        ; positive integer | false
            resolve-me-desc>  ; desc:import-object | false
```

`answer-pos` is for promise pipelining (stage 4) — set false for now. `resolve-me-desc` is the resolver she's implemented. She tests by calling `fetch` on the bootstrap with a resolver:

```
<op:deliver <desc:export 0>
            ['fetch "..."]
            #f
            <desc:import-object 1>>
```

And gets back a fulfill message:

```
<op:deliver <desc:export 1>
            ['fulfill <desc:import-object 1>]
            #f
            #f>
```

The remote object delivers `['fulfill <value>]` to the resolver. Alisha generalizes her send-message function to accept a vow and chain — when the vow resolves, the next message is sent to the resolved reference.

She asks the robot to beep. Reply comes back with `desc:import-promise` (not `desc:import-object`):

```
<op:deliver <desc:export 2>
            ['fulfill <desc:import-promise 2>]
            #f
            #f>
```

The robot has returned a promise (it's beeping asynchronously). To get notified of *its* resolution, Alisha sends `op:listen`:

```
<op:listen to-desc          ; desc:export | desc:answer
           listen-desc>     ; desc:import-object
```

She implements: at her CapTP boundary, when she sees a `desc:import-promise`, create a local promise pair, replace the reference with the local promise, and transmit `op:listen` with the resolver. Later she gets `['fulfill "beeeep!"]` and the promise resolves.

She updates `op:abort` to break all unresolved promises in the session: maintain a set of unresolved-promise resolvers; on abort, iterate and break each with a network-partition error.

Promises can also be **broken** (resolved as failure):

```
;; If the robot can't move forward for some reason
<op:deliver <desc:export 4> ['break "Unknown error occured"] #f #f>
```

Source: [implementation-guide/Implementation Guide.md](https://github.com/ocapn/ocapn/blob/8704f69e01f93701de8bc5eb4bb22b9927a2665a/implementation-guide/Implementation%20Guide.md) at commit `8704f69e`.
