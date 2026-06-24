---
title: "[`op:untag`](#opuntag)"
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

`op:untag` requests the value for an eventually settled
[Tagged](Model.md#tagged) value.
The operation rejects the answer if the ultimate fulfillment of the receiver is
not a Tagged value.

The messages looks like:
```
<op:untag receiver-desc       ; <desc:answer | desc:export>
          tag                 ; A String
          new-answer-pos>     ; Positive Integer
```

> The `op:untag` operation allows a sender to pipeline messages to a
> [Target](Model.md#target) that is deeply embedded in one or more enveloping
> tagged values and to assert the expected tag, possibly enveloped in further
> [Structs](Model.md#struct), [Lists](Model.md#list), or Tagged values.
> For cases where the receiver of an untag operation is an answer slot with no
> listeners, sending `op:untag` obviates the transmission of the uninteresting
> intermediate tag.

### Sending
#### `receiver-desc`
This must be the `desc:answer` or a`desc:export` value which eventually
leads to the Tagged value.
#### `tag`
This must be a [String](Model.md#string) corresponding to the expected tag
string of the eventually settled receiver [Tagged](Model.md#tagged).
#### `new-answer-pos`
This must be a new unique answer position that the selected value should be
exported at.

### Receiving
When the `op:untag` message is received, a promise should be exported at the
answer position specified by `new-answer-pos`.
The promise should eventually resolve to the tagged value, provided in the
Tagged value eventually fulfilled at `receiver-desc` (the receiver), or rejected
if the received tag does not match the tag of the receiver.

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
