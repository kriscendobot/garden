---
title: "[`desc:handoff-receive`](#desc-handoff-receive)"
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
parent: ocapn--draft-specifications-captp--descriptors
---

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
