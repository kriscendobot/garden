---
title: "[`op:get`](#opget)"
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

`op:get` requests the value for the named field of an eventually settled
[Struct](Model.md#struct).
The get operation follows promise resolutions, inheriting the rejection reason
of any intermediate rejected promise.
The operation rejects the answer if the ultimate fulfillment of the receiver
is not a Struct or if the named field is absent on the Struct.

The messages looks like:
```
<op:get receiver-desc       ; <desc:answer | desc:export>
        field-name          ; String
        new-answer-pos>     ; Positive Integer
```

> The `op:get` operation allows a sender to pipeline messages to a
> [Target](Model.md#target) that is deeply embedded in one or more enveloping
> Structs, [Lists](Model.md#list), or [Tagged](Model.md#tagged) values.
> For cases where the receiver of a get operation is an answer slot with no
> listeners, sending `op:get` obviates the transmission of uninteresting fields
> of a potentially large Struct.

### Sending
#### `receiver-desc`
This must be the `desc:answer` or a `desc:export` value which
eventually leads to the Struct you wish to get the value from.
#### `field-name`
This must be a [String](Model.md#string) designating a field of the Struct
you wish to get the value from.
#### `new-answer-pos`
This should be a new unique answer position that the selected value should be
exported at.

### Receiving
When receiving the `op:get` message, export a promise at the
answer position specified by `new-answer-pos`.
The promise should eventually resolve to the value at the field specified by
`field-name`, in fields of the `receiver-desc` Struct.
If the `receiver-desc` promise breaks, or the `field-name` is absent on the
eventual receiver, the promise breaks.

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
