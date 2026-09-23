---
title: "[`op:deliver`](#opdeliver)"
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

This operation delivers a message to an object. The message may or may not 
expect a result. The `op:deliver` message is:

``` text
<op:deliver to-desc           ; desc:export
            args              ; List
            answer-pos        ; positive integer | false
            resolve-me-desc>  ; desc:import-object | desc:import-promise | false
```

### Sending

When sending a message which expects a result, a promise should be generated on
the side which is sending the `op:deliver`. This promise should be provided
to the object sending this message. See the [promises section](#promises) for
more information.

#### `to-desc`
This value corresponds to the object the message is being sent to. When 
messaging a promise created through a previous `op:deliver` message with a 
non-false `answer-pos` (promise pipelining), this MUST be a 
[`desc:answer`](#desc-answer) representing the answer position. In other cases, 
this MUST be a [`desc:export`](#desc-export) representing an object that has 
been exported by the recipient in the CapTP session.

### `args`
`args` is a [List](./Model.md#list) of the arguments to invoke the object with.

### `answer-pos`
When [promise pipelining](#promise-pipelining) is being enabled, this value 
should represent the location the promise should be created at. This location is
described as the "answer position", this is different form the regular exporting
position used when a session exports an object. This is because the position is
decided by the sender of the message, not the receiver. The answer position is a
positive integer, which must be unique within the CapTP session. This is usually
incremented as an incrementing integer, however provided the answer position is
not in use, it is a valid answer position.

This answer position is then referenced with a [`desc:answer`](#desc-answer)
descriptor. Note that when the answer position is no longer needed, it's
important to notify the other side with a [`op:gc-answer`](#opgc-answer)
message (see section for details).

If no result is expected from the message being sent, then this value MUST be
false. If a result is expected but no promise pipelining is needed, this value 
can be false so long as a non-false `resolve-me-desc` is provided.

### `resolve-me-desc`

If it is known when the `op:deliver` is created that the settled return value of
the message is desired, a `resolve-me-desc` can be included. This is a
`desc:import-object` which represents a reference to a resolver object which
will be notified upon the resolution of the promise.

If a non-false `answer-pos` is provided but `resolve-me-desc` is set to false,
then an [`op:listen`](#oplisten) can be sent at a later time to request
notification of the resolution of the promise.

### Receiving
The message should be delivered to the object referenced by `to-desc` with the
arguments specified in `args`.

If `answer-pos` is a positive integer, then promise pipeling is used. In this
case, a promise MUST be created and exported at the answer position specified by
`answer-pos`. This promise MUST resolve to the result the object returns.
Messages sent to this promise MUST be delivered to the object when the promise
resolves (unless the promise breaks). This promise should remain available until
the [`op:gc-answer`](#opgc-answer) message is received. If the `answer-pos` is
false, then promise pipelining is not used.

If `resolve-me-desc` is non-false, the result returned by the target object
should be delivered to the specified resolver object when available.

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
