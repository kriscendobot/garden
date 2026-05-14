---
title: Stage 6 — 3rd Party Handoffs (gifter / receiver / exporter certificates)
source: implementation-guide/Implementation Guide.md
source_repo: kriscendobot/ocapn
source_commit: 8704f69e01f93701de8bc5eb4bb22b9927a2665a
source_date: 2026-03-12
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
topics: [ocapn, captp, capability-security]
status: current
notes: The most security-critical section of the guide. The "no secret messages" property — all certificates can be public and the protocol stays secure — is foundational; the handoff-count replay protection and per-session keypair construction support that property. The gifter-signs-with-key-from-gifter↔exporter-session structure (counterintuitive at first) is canonical for OCapN-family handoff protocols. Soft-flag with the spec's `desc:handoff-give` / `desc:handoff-receive` formal definitions in ocapn--draft-specifications-captp--*.
---

> Abstract: Stage 6 milestone: three-party handoffs (the OCapN-family answer to introducing two peers who don't know each other). Three roles: **Gifter** (initiates), **Receiver** (gets the reference), **Exporter** (hosts the reference being shared). High-level flow: the Gifter deposits a "gift" (the reference + a 32-byte random gift-id) into a per-session gifting table on the Exporter via `deposit-gift` on the bootstrap object. The Gifter creates a `desc:handoff-give` certificate containing both sessions' identifying info + the gift-id, signed with the gifter's key from the **gifter↔exporter** session. The Receiver creates a `desc:handoff-receive` certificate that contains the signed handoff-give, plus a `handoff-count` (replay protection) and the receiver↔exporter session info, signed with the receiver's key from the **gifter↔receiver** session. The Exporter walks four checks (session open with gifter? gifter signed the give? receiver signed the receive? handoff-count not a replay?) and fulfills the handoff. All messages can be public; security comes entirely from the per-session keypair architecture.

### Stage 6: 3rd Party Handoffs

An important feature of the upstream protocol is that programmers need not worry about *where* objects live. A proper implementation provides the illusion of local asynchronous programming being identical in experience to networked asynchronous programming. Third Party Handoffs extends this illusion to the case where peer A wants to give peer B a reference to an object on peer C — even when B and C have no prior connection.

The protocol achieves this despite imports/exports being pairwise (per-session) arrangements. The handoff mechanism uses **certificates** to bridge intentional introductions across the network while preserving the pairwise import/export design.

**Roles** (Alisha gives Ben a reference to Carol's gallery):

- **Gifter** = Alisha (Peer A) — initiates the handoff.
- **Receiver** = Ben (Peer B) — receives the reference.
- **Exporter** = Carol (Peer C) — hosts the reference.

High-level: Alisha deposits a "gift" on Peer C's gift table for her session with C. She then creates a `desc:handoff-give` certificate (info from both her sessions, plus the gift ID at C) and gives it to Ben. Ben creates a `desc:handoff-receive` certificate wrapping the signed give, sends it to Carol, and gets the reference back.

The message Alice initially sends to Ben looks conceptually like:

```
<op:deliver <reference to Ben (desc:import-object)>
            [<desc:handoff-give representing the reference to the gallery>]
            #f #f>
```

#### Depositing the gift

Each peer maintains a per-session gifting table mapping gift-id → reference. The gift-id is 32 random bytes. The Exporter's bootstrap object has a `deposit-gift` method that takes (gift-id, reference) and inserts into the table.

When the implementer's `op:deliver` machinery sees a reference to a remote object on a *different session's* peer in the args, it initializes a handoff: generate a fresh 32-byte gift-id, deposit the gift, replace the reference with a `desc:handoff-give`. The deposit message:

```
<op:deliver <desc:export 0>
            ['deposit-gift <gift-id-bytes> <desc:export 1>]
            #f #f>
```

#### Creating the `desc:handoff-give` certificate

The Gifter creates the give:

```
<desc:handoff-give receiver-key       ; public key of receiver in gifter↔receiver session
                   exporter-location  ; OCapN Locator for the exporter
                   session            ; session ID for the gifter↔exporter session
                   gifter-side        ; public key of gifter in gifter↔exporter session
                   gift-id>           ; Bytearray (length 32)
```

This pulls info from **both** of the gifter's sessions (the one with the receiver and the one with the exporter). Handoffs do not rely on secrecy: all messages can be public; security comes from the per-session keypair architecture.

The Gifter signs the give in a `desc:sig-envelope` with its private key from the **gifter↔exporter** session. Counterintuitive (the give is going to the receiver, not the exporter), but it's the exporter who must verify this signature — and only the gifter's key from the gifter↔exporter session can produce a signature the exporter can check.

#### Creating the `desc:handoff-receive` certificate

The Receiver wraps the signed give in its own certificate:

```
<desc:handoff-receive receiving-session  ; ID of receiver↔exporter session
                      receiving-side     ; public key of receiver in receiver↔exporter session
                      handoff-count      ; positive integer
                      signed-give>       ; desc:sig-envelope wrapping the gifter's desc:handoff-give
```

The `handoff-count` is per-session: each session has an incrementing integer for handoff-receives sent. The exporter tracks how many it has *received* in the session. This prevents replay: the exporter only honors handoff-counts strictly greater than the last one received.

The Receiver signs in a `desc:sig-envelope` using its private key from the **gifter↔receiver** session. Again counterintuitive (it's going to the exporter), but the exporter has access to the receiver's public key from this session because the gifter wrote it into `receiver-key` of the handoff-give.

The Receiver implementation: when an incoming `op:deliver` contains a signed `desc:handoff-give`, replace the reference with a local promise; check if there's a session with the exporter (open one if not); build the `desc:handoff-receive`; sign with the gifter↔receiver key; send to the exporter's bootstrap via `withdraw-gift`:

```
<op:deliver <desc:export 0>
            ['withdraw-gift <desc:sig-envelope <desc:handoff-receive ...> <signature....>>]
            #f
            <desc:import-object 1>>
```

When the resulting promise resolves (fulfill or break), the local promise the implementation made when receiving the signed handoff-give is settled.

#### Checking the certificates and fulfilling the handoff (exporter side)

The exporter checks four things on receiving a signed `desc:handoff-receive`:

**1. Do we have an open session with the gifter?**
Look up the session named in `desc:handoff-give.session`. If no open session exists, the handoff cannot proceed (the gift table and verification keys live on that session).

**2. Did the gifter actually make the `desc:handoff-give`?**
The give is signed with the gifter's private key from the gifter↔exporter session. Verify against the public key already known from that session. If valid, trust the `receiver-key` and `gift-id` fields.

**3. Is the receiver who made the `desc:handoff-receive`?**
The receive is signed with the receiver's private key from the gifter↔receiver session. Extract the receiver's public key from the trusted `receiver-key` field of the give and verify the receive's signature. This proves the receiver is the one the gifter intended.

**4. Replay-attack check.**
The receiver's `handoff-count` must be strictly greater than the last handoff-count seen from this receiver in this session (or zero, if first). The signed certificate cannot be replayed (count too low) or modified (signature would fail).

If all four checks pass: look up the gift-id in the gifter↔exporter session's gift table. If the gift is there, extract it, fulfill the promise the receiver created with the reference, and remove the gift (handoffs are one-shot). If the gift is *not* yet there (ordering: the receiver's withdraw-gift arrived before the gifter's deposit-gift), set up a local promise resolver and register it in a "gift deposit notification table"; the `deposit-gift` implementation must check this table on every insert and trigger waiting resolvers instead of inserting.

#### Worked example: Alisha hands Carol's gallery to Ben

Alisha generates a gift-id and deposits the gallery at Carol's bootstrap:

```
;; Robot gallery is exported by Carol at position 4.
<op:deliver (desc:export 0)
            ['deposit-gift <gift-id-bytes> (desc:export 4)]
            #f #f>
```

Alisha sends Ben the signed handoff-give:

```
<op:deliver (desc:export 5)
            ['send-robot-photos
             (desc:sig-envelope
               (desc:handoff-give
                 <Ben's public key for his session with Alisha>
                 (ocapn-peer "tcenolezzq7vleywviuvwl74dh2nhs3nf7lun5zuhtjpwhjed5ojw6qd" 'onion #f)
                 <ID of the session Alisha and Carol's peer have>
                 <Alisha's public key in her session with Carol>
                 <gift-id-bytes>)
               <signature Alisha made with her private key in the session with Carol's Peer>)]
            #f #f>
```

Ben sees a signed handoff-give in args, replaces with a local promise, opens a session to Carol if needed, builds + signs his handoff-receive, sends to Carol's bootstrap via `withdraw-gift`:

```
<op:deliver (desc:export 0)
            ['withdraw-gift
             (desc:sig-envelope
              (desc:handoff-receive
                <ID of the newly-created session Ben has with Carol>
                0
                (desc:sig-envelope
                  (desc:handoff-give
                    <Ben's public key for his session with Alisha>
                    (ocapn-peer "tcenolezzq7vleywviuvwl74dh2nhs3nf7lun5zuhtjpwhjed5ojw6qd" 'onion #f)
                    <ID of the session Alisha and Carol's peer have>
                    <Alisha's public key in her session with Carol>
                    <gift-id-bytes>)
                  <signature Alisha made with her private key in the session with Carol's Peer>)))]
           #f
           <desc:import-object 1>>
```

Carol checks the four items above, finds the gift in her table, fulfills:

```
;; Fulfilling the promise created in Ben's `op:deliver`
<op:deliver (desc:export 1) ['fulfill (desc:import-object 1)] #f #f>
```

…and removes the gift from her table (one-shot).

Source: [implementation-guide/Implementation Guide.md](https://github.com/ocapn/ocapn/blob/8704f69e01f93701de8bc5eb4bb22b9927a2665a/implementation-guide/Implementation%20Guide.md) at commit `8704f69e`.
