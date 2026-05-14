---
title: The bootstrap Object (fetch, deposit-gift, withdraw-gift)
source: "draft-specifications/CapTP Specification.md"
source_repo: kriscendobot/ocapn
source_commit: 8704f69e01f93701de8bc5eb4bb22b9927a2665a
source_date: 2026-03-12
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn, captp, capability-security]
status: current
---

> Abstract: The bootstrap object: the initial capability each peer offers on a new session. Three methods documented at H2: fetch (retrieve an existing sturdyref), deposit-gift (place a capability for another peer to claim), withdraw-gift (claim a capability deposited for you). The handoff protocol stands on these.

# [The bootstrap Object](#bootstrap-object)

The bootstrap object is responsible for providing access to local objects on the
session. It has three different behaviors, selected using the conventional CapTP
method mechanism of sending a symbol as the first argument. The following
methods are available:

-   `fetch`
-   `deposit-gift`
-   `withdraw-gift`

The bootstrap object MUST be exported on each newly initialized CapTP session at
export position `0`. A session is considered initialized if both sides send and
receive both [`op:start-session`](#opstart-session) messages.

## `fetch` Method

This method is used to fetch an object from the bootstrap object. To use it you
need a `swiss-number` which is a Binary Data type. This swiss number should
correspond an object which exists in this session. The result will be the object
which corresponds to this `swiss-number` or an error if the object does not
exist or a swiss number was not provided.

An example of how to use this method is:

```text
<op:deliver <desc:export 0>          ; Remote bootstrap object
            ['fetch                  ; Argument 1: Symbol "fetch"
             swiss-number]           ; Argument 2: Binary Data
            3                        ; Answer position: positive integer
            <desc:import-object 5>>  ; resolver exported by us at position 5 should receive the answer
```

## `deposit-gift` Method

The deposit gift method is used in conjunction with sending a [Third Party Handoff](#third-party-handoffs).
This method is used to deposit a gift which has been sent to the bootstrap object. It has two arguments:

1.  A gift ID that is bytearray of 32 generated random bytes.
2.  A [Reference][Model-Reference] which has been exported
    within the given CapTP session.

This should have been sent with the [`op:deliver`](#op-deliver) operation
with no reponse requested.

Here is an example of how to use this method:

```text
<op:deliver <desc:export 0>            ; Remote bootstrap object
            ['deposit-gift             ; Argument 1: Symbol "deposit-gift"
             gift-id                   ; Argument 2: Unique gift ID (bytearray)
             <desc:import-object 5>]   ; Argument 3: object being shared via handoff
             false                     ; No answer promise desired
             false>                    ; No result desired
```

## `withdraw-gift` Method

This method is used to send the [`desc:handoff-receive`](#desc-handoff-receive)
in order to receive a gift. It has one argument:

- The `desc:handoff-receive`

This should have been sent with the [`op:deliver`](#op-deliver) operation, the response the
bootstrap object should give is the gift which was (or will be) deposited.

Here is an example of how to use this method:

```text
<op:deliver <desc:export 0>           ; Remote bootstrap object
            [withdraw-gift            ; Argument 1: Symbol "withdraw-gift"
             <desc:handoff-receive>]  ; Argument 2: sig:envelope containing desc:handoff-receive
            1                         ; Answer position: Non-negative integer (>=0)
            <desc:import-object 3>>   ; The object exported (by us) at position 3, should receive the gift.
```


Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
