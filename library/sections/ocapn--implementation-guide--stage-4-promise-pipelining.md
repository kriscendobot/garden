---
title: Stage 4 — promise pipelining (desc:answer + answer-pos)
source: implementation-guide/Implementation Guide.md
source_repo: kriscendobot/ocapn
source_commit: 8704f69e01f93701de8bc5eb4bb22b9927a2665a
source_date: 2026-03-12
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
topics: [ocapn, captp, eventual-send]
status: current
notes: Promise pipelining is the canonical performance + readability win for CapTP-family protocols (cuts A=>B=>A=>B=>A to A=>B=>A). The "send a minor delay to coalesce op:listen into op:deliver's resolve-me-desc" optimization and the resulting need to apply the same delay to other messages for ordering is a non-obvious correctness consequence — worth knowing before implementing.
---

> Abstract: Stage 4 milestone: promise pipelining via `<desc:answer answer-pos>`. The `answer-pos` field in `op:deliver` carries a unique-to-the-session positive integer; the sender can then refer to "the answer to that deliver" via `<desc:answer answer-pos>` in subsequent messages without waiting for the result. Two new per-session tables: a *questions* table (mapping remote-promise-descriptor → local answer position) and an *answers* table (mapping position → local promise for received op:delivers). Optimization: if `resolve-me-desc` is false but `answer-pos` is set, the receiver creates the answer entry but no import-table entry. Further optimization: insert a small delay before transmit so the implementation can coalesce a follow-up `op:listen` into the `resolve-me-desc` of the original `op:deliver` (and apply the same delay uniformly so ordering is preserved).

### Stage 4: promise pipelining

Promise pipelining chains promises by sending `op:deliver` messages to promises, creating further promises that can be chained.

Without pipelining: `A => B => A => B => A` (each round-trip waits for the previous reply). With pipelining: `A => B => A` (refer to the promise immediately, send the next message in the same direction).

Example: Alisha wants to create a file in a directory on Ben's peer and then write text to it. Without pipelining she'd send "create file" (`A => B`), wait for the file reference (`B => A`), send the write (`A => B`), wait for the write success (`B => A`). With pipelining she sends "create file" with an answer-pos, then immediately sends "write text" against `<desc:answer N>` referring to the in-flight file, and sets up one combined callback (`B => A`).

CapTP supports this via the `answer-pos` field in `op:deliver` and the `<desc:answer answer-pos>` descriptor:

```
;; Create the directory; answer-pos 0 names this promise
<op:deliver <desc:export 1>
            []
            0
            <desc:import-object 1>>

;; Send a message to that promise (still in the same direction)
<op:deliver <desc:answer 0>
            []
            1
            <desc:import-object 2>>

;; And again
<op:deliver <desc:answer 1>
            []
            2
            <desc:import-object 3>>
```

Per-session tables:

- **Questions**: remote-promise-descriptor → answer position.
- **Answers**: position → local promise for received `op:deliver` calls.

Alisha modifies her send-message function: pick a unique `answer-pos` integer, put it in `op:deliver`, register the local promise in the questions table, return the remote-promise descriptor. She supports `desc:answer` as a `to-desc` target by looking up the local promise in the answers table and queuing the message to deliver when that promise resolves.

She modifies receive: if `answer-pos` is set, register the position in the answers table along with a created promise.

**Optimization 1 (resolve-me-desc default false):** for pure pipelining, she doesn't actually need the *settled* result, only the answer promise. She sets `resolve-me-desc` to false by default and only sends `op:listen` when local code listens for the result.

**Optimization 2 (delay-and-coalesce):** instead of always sending `op:deliver` + `op:listen`, she introduces a minor delay in her send code. If local code listens for the result during the delay, she folds the listen into the original message as `resolve-me-desc` (eliminating the separate `op:listen`). If no listen happens, she sends `op:deliver` with `resolve-me-desc: false` and later sends `op:listen` if/when needed.

**Optimization 2's correctness consequence:** with the delay, messages arrive in a strange order. She applies the same delay to her other messages too, restoring the expected ordering.

Source: [implementation-guide/Implementation Guide.md](https://github.com/ocapn/ocapn/blob/8704f69e01f93701de8bc5eb4bb22b9927a2665a/implementation-guide/Implementation%20Guide.md) at commit `8704f69e`.
