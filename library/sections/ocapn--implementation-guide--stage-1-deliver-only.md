---
title: Stage 1 — deliver-only messages, sturdyrefs, import/export
source: implementation-guide/Implementation Guide.md
source_repo: kriscendobot/ocapn
source_commit: 8704f69e01f93701de8bc5eb4bb22b9927a2665a
source_date: 2026-03-12
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
topics: [ocapn, captp, marshal]
status: current
notes: The "everything described from the receiving perspective" frame for import/export terminology is the canonical mental model. The bootstrap-object-at-position-0 + `fetch` method idiom is shared with the Endo realization (endo--pkg-captp-readme--*). Soft-flag overlap with ocapn--draft-specifications-locators--sturdyref (the formal sturdyref spec) and with ocapn--draft-specifications-captp--operations-and-descriptors.
---

> Abstract: Stage 1 milestone: receive an object reference and send a one-way message. Sturdyrefs are OCapN locators encoding "an object on a specific peer" as `<ocapn-sturdyref peer swiss-num>`; the implementer decodes them from the string form (per the Locators spec). The bootstrap object at export position 0 is always exported by the receiving side; it carries a `fetch` method that takes a swiss-num and returns the named object. Import/export: descriptors are `<desc:import-object position>` and `<desc:export position>`; everything is described from the *receiving* perspective. Two per-session tables: an import table (position → remote-object-reference) and an export table (position → local-reference). `op:deliver to-desc args answer-pos resolve-me-desc` — for deliver-only, `answer-pos` and `resolve-me-desc` are both false.

### Stage 1: deliver-only messages, sturdyrefs, import/export

In stage 0, Alisha was able to have her session establish a channel and initialize a CapTP session, but the only thing she has been able to do so far has been to abort it. She'd like to be able to connect to her friend Ben and ask him if she can try out one of his new robots. Ben has given her his sturdyref, but to use that she'll need to add support to:

- Decode and enliven sturdyrefs
- Export the bootstrap object at position 0
- Have a bootstrap object that provides fetching objects
- Support `op:deliver` to send deliver-only messages to objects

#### Sturdyrefs

Sturdyrefs are a type of OCapN locator used to encode an object on a specific peer. They can be encoded as a record:

```
<ocapn-sturdyref peer        ; ocapn-peer record
                 swiss-num>  ; Binary data identifying a specific object
```

Alisha has a sturdyref as a string (Ben shared it outside of OCapN). The mapping between string and record encodings is defined in the OCapN Locators specification, so she implements a conversion to the record form. She uses the peer information to form a session via her existing CapTP implementation, but she needs to be able to reference the object identified by `swiss-num`.

The steps to get a reference to that object are:

1. Ask the bootstrap object for the object by using its `fetch` method.
2. Keep track of the object so she can use it.

#### Importing and Exporting

In order to begin sending messages, Alisha needs references to objects. CapTP does this by `exporting` and `importing` objects. Whether an object is being exported or imported depends on whose perspective you're looking from; in CapTP **everything is described from the receiving perspective**. CapTP also assigns each shared object a positive integer position; the specific number doesn't matter, so long as it's unique to the object within the session.

CapTP describes objects across the network with descriptors. The two basic forms:

```
<desc:import-object position>
<desc:export position>
```

To make this concrete: two peers, Peer A (with objects Alisha and Arthur) and Peer B (with Ben). Peer B exports Ben at position 3; when Peer B refers to it, it sends `<desc:export 3>`. Peer A receives this and stores it as `<desc:import-object 3>`. Now if Alisha sends Ben a reference to Arthur, that's Peer A exporting Arthur to Peer B:

```
<op:deliver <desc:import-object 3>  ; (to-desc) Ben from Peer A's view
            [<desc:export 4>]       ; (args) Arthur, Peer A's export pos 4
            #f #f>
```

Each CapTP session gets two tables on each side: an import table (position → remote-object-reference, given to local actors) and an export table (position → local reference). Objects exported go into the export table; objects imported go into the import table.

#### Exporting the bootstrap object

The very first object ever to be exported is always the **bootstrap object** at position 0. The bootstrap object helps you bootstrap the connection: it lets you get a reference to an object on the peer when you have no other references. Sturdyrefs contain a `swiss-num` that the bootstrap object uses to look up the named object. Methods are normal message sends, except the first argument of the list is a symbol naming the method.

#### Delivering messages

There are two ways to send a message:

- Send a message, not expecting any response from the object (deliver-only).
- Send a message while setting up promise machinery to get a reply.

Stage 1 focuses on deliver-only. `op:deliver` has the following structure:

```
<op:deliver to-desc           ; desc:export
            args              ; sequence
            answer-pos        ; positive integer | false
            resolve-me-desc>  ; desc:import-object | false
```

For deliver-only, set `answer-pos` and `resolve-me-desc` to false. Alisha implements a send-message function that takes a remote-object reference and arguments, then constructs the record. She tests by calling the bootstrap object's `fetch`:

```
<op:deliver <desc:export 0>
            ['fetch "..."]
            #f
            #f>
```

She sends; she doesn't hear back. That's expected for deliver-only. She moves on to stage 2 to learn how to actually receive responses.

Source: [implementation-guide/Implementation Guide.md](https://github.com/ocapn/ocapn/blob/8704f69e01f93701de8bc5eb4bb22b9927a2665a/implementation-guide/Implementation%20Guide.md) at commit `8704f69e`.
