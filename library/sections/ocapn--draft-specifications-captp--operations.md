---
title: Operations (op:start-session through op:gc-answers)
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
---

> Abstract: The 9 wire operations: op:start-session, op:deliver, op:abort, op:listen, op:get, op:index, op:untag, op:gc-exports, op:gc-answers. Each is consolidated as an H2 sub-section here rather than split into its own library section, to keep the section count manageable. Future cycle could split if specific operations need standalone lookup pages.

# Operations

## [`op:start-session`](#opstart-session)

When setting up a new session, a EdDSA key pair should be generated.

This operation is used when a new session is initiated over CapTP. Both
parties MUST send an `op:start-session` message upon a new session. The
operation looks like this:

```text
<op:start-session captp-version             ; String value
                  session-pubkey            ; CapTP public key value
                  acceptable-location       ; OCapN Reference type
                  acceptable-location-sig>  ; CapTP signature
```

An important aspect of CapTP is that only one active session between two peers
should exist. This allows peers to perform equality checks against objects from
a remote peer and prevents [3rd Party Handoffs](#third-party-handoffs) when the
receiver and exporter are on the same peer.

There are several mechanisms put in place to ensure that only one session exists
between two peers. The first is that a CapTP implementation MUST check if it has
an active session with a given peer, before trying to establish a new
connection. If the peer already has an active session, that session MUST be used
instead of creating a new one.

### Constructing and sending

The `captp-version` MUST be `1.0`.

The `session-pubkey` is the public key part of the per-session key pair
generated for this connection. This is serialized in accordance with
[Cryptography](#cryptography)

The `acceptable-location` is a OCapN Locator which represents the location where
the session is accessable.

The `acceptable-location-sig` is the signature of the serialized
`acceptable-location`. The signature is created using the private key from the
per-session key pair. This is serialized in accordance with
[Cryptography](#cryptography)

### Receiving

If the session has already received an `op:start-session`, the session MUST be
aborted.

The `captp-version` MUST be equal to `1.0`. If the version does not match, the
connection MUST be aborted.

The `acceptable-location-sig` MUST be valid that the `session-pubkey` provided a
valid signature of `acceptable-location`.

The implementation should check if an active valid session already exists
between the two peers, if one does exist the new session should be aborted.

Detection and (if needed) mitigation of the Crossed Hellos problem described
below MUST be performed.

### Crossed Hellos Resolution

Crossed hellos is a race condition which occurs when two peers attempt to open a
new session to one another simultaneously. If both sessions were to succeed
the result would be multiple sessions between the same peers. Since this is
not permitted in CapTP, all implementations are responsible for detecting and
resolving the problem.

Implementations are responsible for keeping track the sessions they've
initiated. After receiving the `op:start-session` message from the other side,
the receiving side should check to see if it has a session it has opened with
the peer located at the `acceptable-location` provided. If it both received a
session from a peer that it has also opened a session to, the crossed hellos
problem has been detected and must be resolved.

The way to resolve the problem is by choosing which of the two sessions should
be allowed to "win" (and the other to be aborted). This is done by
deterministically calculating the [Public Identifier](#public-identifier) for
its outbound connection and the other side's inbound connection. These two keys
(in their syrup serialization) should be compared bytewise to each other. The
lower of the two has its connection aborted. The higher of the two should
continue to be the valid session for the two peers.

## [`op:deliver`](#opdeliver)

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

## [`op:abort`](#opabort)

This is used to abort a CapTP session, when this is sent the connection should
be severed and any per session information (e.g. session key pair, etc.) should
be removed.

The `op:abort` message is:

```text
<op:abort reason>  ; reason: String
```

## [`op:listen`](#oplisten)

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

## [`op:get`](#opget)

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

## [`op:index`](#opindex)

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

## [`op:untag`](#opuntag)

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

## [`op:gc-exports`](#opgc-exports)

When a reference is given out over CapTP, the reference must be kept
valid until the other party within a session is done with it. This is
achieved by reference counting the object with respect to how many
times a reference has been sent. Each time a reference is sent, the
count MUST be incremented (the first time it is sent, the reference
count should be set to 1).

When the remote session becomes aware that it no longer needs a set of
references, it MUST send an `op:gc-exports` message with two lists: one list
containing the `export-pos` of each reference it no longer needs and another
list containing the corresponding `wire-delta` that reflects the number of
times the reference has been received since the last `op:gc-exports` message
for that reference was sent.

When receiving an `op:gc-exports` message, the reference count for each 
`answer-pos` is decremented by its corresponding `wire-delta`. When a reference
count reaches 0, the corresponding object can be garbage collected.


The message looks like:

```text
<op:gc-exports export-pos-list   ; list of positive integers
               wire-delta-list>  ; list of positive integers
```

## [`op:gc-answers`](#opgc-answers)

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
