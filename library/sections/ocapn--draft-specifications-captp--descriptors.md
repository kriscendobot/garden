---
title: Descriptors (desc:import-object through desc:handoff-receive)
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
notes: 7 H2 descriptors consolidated. Each independently looked-up-able by H2 anchor.
---

> Abstract: The 7 wire descriptor types: desc:import-object, desc:import-promise, desc:export, desc:answer, desc:sig-envelope, desc:handoff-give, desc:handoff-receive. Each describes how a particular kind of capability or signature appears on the wire. Consolidated as H2 sub-sections within this single library section.

# Descriptors

Several operations (e.g. `desc:import-object` and `desc:export`) are describing
importing and exporting objects. There had to be a choice if these actions
should be described from the sender's or receiver's side, in this case we
choose the receiver's side. This means if an object is exported from
Alice to Bob, Alice sends a `desc:import-object` as Alice is describing
it from Bob's perspective.

## [`desc:import-object`](#desc-import-object)

Any object which is exported over CapTP is described with a positive integer.
This positive integer MUST be unique to this CapTP session and refer to this
specific object.

```text
<desc:import-object position>  ; position: positive integer
```

Position `0` is reserved for the [bootstrap object](#bootstrap-object).

## [`desc:import-promise`](#desc-import-promise)

When a promise is exported over a CapTP boundary is it described with a
`desc:import-promise` message. This message contains a positive integer which is
unique to the exporting party within the CapTP session and refers to
this specific promise.

```text
<desc:import-promise position>  ; position: positive integer
```

## [`desc:export`](#desc-export)

When a message is sent across a CapTP boundary that refers to an imported object
within the session the message is being sent to (either a `desc:import-object`
or a `desc:import-promise`), then this should be referred to with a
`desc:export`. The position MUST be the positive integer provided in the import
descriptor.

If an object reference is being sent from a different session, see the [Third
Party Handoffs](#third-party-handoffs) section.

```text
<desc:export position>  ; position: positive integer
```

## [`desc:answer`](#desc-answer)

This is used to refer to a promise which is being pipelined. The position MUST
be the positive integer provided in the [`op:deliver`](#opdeliver) message.
This should not be referenced after the [`op:gc-answer`](#opgc-answer) message
has been sent for this position.

```text
<desc:answer answer-pos> ; position: positive integer
```

## [`desc:sig-envelope`](#desc-sig-envelope)

This encapsulates a CapTP object and provides a signature. The signature is
created on the binary data of the serialized CapTP object in the `signed` field.

The process of generating this is:

1.  Fully serialize to a CapTP object to Syrup octets.
2.  Sign the result of step 1 using the private key.
3.  Create a `desc:sig-envelope` with the (original, unserialized) CapTP object
    and signature.

```text
<desc:sig-envelope signed      ; captp-object
                   signature>  ; Signature (see cryptography section)
```

When this is received, the signature must be valid using the corresponding
public key. If the signature is not valid, the operation should be aborted.

NOTE: The value of `signed` should be the object itself (opposed to the binary
data produced via serialization in step 1).  Syrup itself provides
canonicalization, which allows for serialization to always produce the same
result.

## [`desc:handoff-give`](#desc-handoff-give)

In [Third Party Handoffs](#third-party-handoffs), the Gifter creates a `desc:handoff-give` and sends it to the Receiver.
The Receiver uses the `desc:handoff-give` to redeem the gift from the Exporter.
This record is a certificate created by the Gifter, sent to the Recevier,
and ultimately used by the Receiver to redeem the gift from the Exporter.

The Gifter prepares the record by,
1.  Creating a `desc:handoff-give`
2.  Signing the `desc:handoff-give` and wrapping it within a `desc:sig-envelope`
3.  Replace the [Reference][Model-Reference] to the remote object being gifted in the message with
    the signed record produced in step 2.

### The record

```text
<desc:handoff-give receiver-key       ; Public Key (see cryptography section)
                   exporter-location  ; OCapN Locator (see Locator document)
                   session            ; Session ID (ByteArray)
                   gifter-side        ; Public Identifier (ByteArray)
                   gift-id>           ; Gift ID (ByteArray)
```

1.  `receiver-key` This is the Receiver's [Public Key](#public-key) in the **Gifter-Receiver** session.
2.  `exporter-location` This is the [OCapN Locator][Locators] of the Exporter.
3.  `session` This is the [Session ID](#session-id) for the **Gifter-Exporter** session.
4.  `gifter-side` This is the [Public Identifier](#public-identifier) for the gifter in the **Gifter-Exporter** session.
5.  `gift-id` This is the gift ID that is generated by the Gifter that the gift
    will be deposited at. This gift ID should be a randomly generated 32 byte
    bytearray.

This message MUST always be encapsulated in a
[`desc:sig-envelope`](#desc-sig-envelope) with a valid signature.

The signature is made using the Gifter's key from the **Gifter-Exporter** session.

### Validating the record

The Receiver is the first to get the `desc:handoff-give`.
The only field that the Receiver can verify is the receiver-key, it should match
the Receiver's Public Key from the **Gifter-Receiver** session.

The Exporter later receives the `desc:handoff-give` inside of the `desc:handoff-receive`,
and the process for validating the `desc:handoff-give` is detailed in [`desc:handoff-receive`](#desc-handoff-receive).


## [`desc:handoff-receive`](#desc-handoff-receive)

This record is used in [Third Party Handoffs](#third-party-handoffs).

The `desc:handoff-receive` record is created by the Receiver and sent to the Exporter.
It includes the signed [`desc:handoff-give`](#desc-handoff-give) from the Gifter,
as well as some additional data provided by the Receiver.

The primary purpose of this certificate is to associate the Receiver's **Exporter-Receiver** session
identity with the Receiver's **Gifter-Receiver** session identity. The Gifter specifies the gift recipient
to the Exporter as the Receiver's **Gifter-Receiver** session identity.

### The record

```text
<desc:handoff-receive receiving-session  ; Session ID (ByteArray)
                      receiving-side     ; Public Identifier (ByteArray)
                      handoff-count      ; Non-negative integer (>=0)
                      signed-give>       ; desc:sig-envelope containing desc:handoff-give
```

1.  `receiving-session` This is the [Session ID](#session-id) in the **Exporter-Receiver** session.
2.  `receiving-side` This is the Receiver's [Public ID](#public-id) in the **Exporter-Receiver** session.
3.  `handoff-count` This is a non-negative integer which MUST not have been used in the **Exporter-Receiver** session.
4.  `signed-give` This is the [`desc:handoff-give`](#desc-handoff-give) that is encapsulated in the
    `desc:sig-envelope` from the Gifter.

This message MUST always be encapsulated in a
[`desc:sig-envelope`](#desc-sig-envelope) with a valid signature.

The signature is made using the Receiver's key from the **Gifter-Receiver** session (**NOT** the **Exporter-Receiver** session).

### Checking the validity of the `desc:handoff-receive`

There are a number of steps which must be followed to verify the
`desc:handoff-receive`, these rely on information that is specific to the two
sessions.

#### Identifying the Gifter session & Receiver session

The two sessions are:
-  **Gifter-Exporter**: The session where the Gifter designates the gift.
-  **Exporter-Receiver**: The session where the Receiver is redeeming the gift.

The **Gifter-Exporter** session can be found via the `session` field in the [`desc:handoff-give`](#desc-handoff-give)
which specifies a [Session ID](#session-id). The **Exporter-Receiver** session can be found via
the `receiving-session` field which specifies a [Session ID](#session-id) on the [`desc:handoff-receive`].

#### Checking the signature on the [`desc:handoff-give`](#desc-handoff-give)

The [`desc:handoff-give`](#desc-handoff-give) must have been wrapped in a `desc:sig-envelope`. This
envelope carries with it a signature made using the Gifter's key from the **Gifter-Exporter**
session.

The signature MUST be verified as correct.

Once this has been verified the information in the [`desc:handoff-give`](#desc-handoff-give) is known
to have been created by the Gifter.

#### Checking the signature on the `desc:handoff-receive`

The information provided to the Exporter must be verified to have come from the
receiver that the Gifter has designated. This can be done as the Gifter has
provided the Receiver's Public Key in the **Gifter-Receiver** session and the
`desc:handoff-receive` has been signed by the Receiver using their private key
for that same **Gifter-Receiver** session.

To verify, take the Receiver's public key for the **Gifter-Receiver** session
from the `receiver-key` field in the `handoff-give` and use it to check the
signature in the `desc:sig-envelope` encapsulating the `desc:handoff-receive`.

If the signature is invalid, the handoff procedure MUST be aborted. Otherwise if
it is valid, the information is now known to have been created by the receiver
that the Gifter has designated.

#### Checking the `handoff-count`

The `handoff-count` in the `desc:handoff-receive` MUST be a non-negative integer
that has NOT been used before in the **Exporter-Receiver** session.
If the `handoff-count` has been used before in this session, the handoff should
be aborted. This protects against replay attacks.

### Receiving a `desc:handoff-receive`

When the Bootstrap's [`withdraw-gift` method](#withdraw-gift-method) is invoked, the following must happen:

1.  A local promise is created and exported.
2.  The `desc:handoff-receive` is verified, if invalid the promise MUST be
    broken and the handoff aborted.
3.  If the handoff-receive is valid:
  -   If the gift has already been deposited, fulfill the promise with the gift
  -   If the promise has not yet been deposited, wait until it has and then
      fulfill the promise with the gift if/when it is deposited.


Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
