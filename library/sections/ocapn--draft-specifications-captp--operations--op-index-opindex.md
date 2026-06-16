---
title: "[`op:index`](#opindex)"
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

`op:index` requests the value at the given index of an eventually settled
[List](Model.md#list).
The index operation follows promise resolutions, inheriting the rejection
reason of any intermediate rejected promise.
The operation rejects the answer if the ultimate fulfillment of the receiver
is not a List.

The messages looks like:
```
<op:index receiver-desc       ; <desc:answer | desc:export>
          index               ; Integer
          new-answer-pos>     ; Positive Integer
```

> The `op:index` operation allows a sender to pipeline messages to a
> [Target](Model.md#target) that is deeply embedded in one or more enveloping
> Lists, [Structs](Model.md#struct), or [Tagged](Model.md#tagged) values.
> For cases where the receiver of an index operation is an answer slot with no
> listeners, sending `op:index` obviates the transmission of uninteresting
> values of a potentially large List.

### Sending
#### `receiver-desc`
This must be the `desc:answer` or a`desc:export` value which eventually
leads to the List you wish to get the value from.
#### `index`
This must be a zero-indexed integer which specifies which value should be
picked out of the List.
#### `new-answer-pos`
This must be a new unique answer position that the selected value should be
exported at.

### Receiving
When the `op:index` message is received, a promise should be exported at the
answer position specified by `new-answer-pos`.
The promise should eventually resolve to the value at the index specified by
`index`, in values provided in the List eventually fulfilled at
`receiver-desc`.
If the `receiver-desc` promise breaks, or the `index` is out of
the bounds of the receiver List, the promise should break.

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
