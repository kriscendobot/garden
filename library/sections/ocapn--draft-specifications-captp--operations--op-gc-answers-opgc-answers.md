---
title: "[`op:gc-answers`](#opgc-answers)"
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

When an [`op:deliver`](#opdeliver) is sent with an `answer-pos` for use with
promise pipelining, the receiver will create a promise at the provided answer
position. The receiver needs to know when it's able to garbage collect these
promises. This is done by sending an `op:gc-answers` message. Each element of
`answer-pos-list` in this message MUST correspond to the `answer-pos` in an
[`op:deliver`](#opdeliver) message that you are no longer interested in.

Once the `answer-pos` has been GC'd through sending the `op:gc-answers`
operation, the `answer-pos` can be re-used.

```text
<op:gc-answers answer-pos-list>  ; answer-pos-list: list of positive integers
```

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
