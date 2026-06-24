---
created: 2026-06-09
updated: 2026-06-09
author: liaison
project: ocapn
source: [Nominations for First Consensus Draft Criteria](https://github.com/ocapn/ocapn/issues/272)
milestone: [a finish line](https://github.com/ocapn/ocapn/milestone/2) (empty as of 2026-06-09; plenary moved to populate at July 2026 plenary)
constraint: internal-only; no comments posted; no outward-facing references
---

# Consensus-draft criteria → corresponding issues

Issue [#272](https://github.com/ocapn/ocapn/issues/272) (*Nominations for First Consensus Draft Criteria*, opened 2026-06-09 by @dckc) records the June 2026 plenary move "to collect criteria for consensus on a first draft of OCapN, with the intention to seek consensus to populate a milestone for these criteria at the July, 2026 plenary meeting." The milestone is [*a finish line*](https://github.com/ocapn/ocapn/milestone/2) and is currently empty.

Two contributors nominated criteria in the comment thread:

- **@kriskowal** (via @dckc): four items — concrete encoding; captp - 3PH (embargo? flush? ordering?); grant matching for a network of peers on the web and off the web where at least off the web do don't have redundant cryptography; mutual authentication of peers and sessions.
- **@erights**: failure / partition (@cwebber answered "more or less... sturdyref").

This file maps each nominated criterion to the corresponding open and closed issues in the upstream repository.

## 1. Concrete encoding

The wire-format and data-model criterion. The closed baseline (abstract syntax, smallcaps cheatsheet, IEEE floats, ordering guarantees, ByteArray test/interop, string-detail conventions, selector→symbol rename) is the floor; the open issues below are the unresolved work.

**Open:**

- [#249](https://github.com/ocapn/ocapn/issues/249) — CBOR — @kriskowal
- [#246](https://github.com/ocapn/ocapn/issues/246) — Add a representation for tagged values — @kriskowal
- [#194](https://github.com/ocapn/ocapn/issues/194) — Three ways to negotiate/upgrade/migrate the concrete format — @kriskowal
- [#186](https://github.com/ocapn/ocapn/issues/186) — Should Swiss num be serialized as String or Bytes? — @RidleyWrites — `focus`
- [#173](https://github.com/ocapn/ocapn/issues/173) — Sortable Passable Key — @kriskowal
- [#138](https://github.com/ocapn/ocapn/issues/138) — Streaming Netstring message framing — @kriskowal — `Meeting, focus`
- [#131](https://github.com/ocapn/ocapn/issues/131) — Calling Convention — @tsyesika
- [#235](https://github.com/ocapn/ocapn/issues/235) — Editors: Document calling convention — @kriskowal
- [#144](https://github.com/ocapn/ocapn/issues/144) — Disprefer the name Struct — @kriskowal
- [#122](https://github.com/ocapn/ocapn/issues/122) — Immutability of passable data — @kriskowal
- [#121](https://github.com/ocapn/ocapn/issues/121) — Data Model based Compression — @kriskowal
- [#117](https://github.com/ocapn/ocapn/issues/117) — Add versioning to facilitate transport negotiation — @tsyesika
- [#66](https://github.com/ocapn/ocapn/issues/66) — S-expressions in keys and signatures — @dpwiz
- [#48](https://github.com/ocapn/ocapn/issues/48) — core data types: ByteArray test / interop — @dckc
- [#47](https://github.com/ocapn/ocapn/issues/47) — core data types: string details, e.g. lone surrogate — @dckc

**Closed baseline:**

- [#92](https://github.com/ocapn/ocapn/issues/92) — Working document for abstract syntax (data model) — closed 2025-01-06
- [#93](https://github.com/ocapn/ocapn/issues/93) — Working document for concrete syntax requirements — closed 2024-05-14
- [#56](https://github.com/ocapn/ocapn/issues/56) — Concrete syntax ordering guarantees — closed 2026-06-09
- [#58](https://github.com/ocapn/ocapn/issues/58) — core data types: IEEE floating point — closed 2025-12-13
- [#91](https://github.com/ocapn/ocapn/issues/91) — Smallcaps Cheatsheet — closed 2025-12-13
- [#165](https://github.com/ocapn/ocapn/issues/165) — Let's rename Selector to Symbol — closed 2025-12-13
- [#211](https://github.com/ocapn/ocapn/issues/211) — Wrong receiver-desc in op:untag, op:index, op:get — closed 2026-01-23
- [#258](https://github.com/ocapn/ocapn/issues/258) — Should `desc:handoff-give`'s `gift-id` be a bytearray or integer — closed 2026-05-01 — `Meeting, focus`

## 2. CapTP — 3PH (embargo / flush / ordering)

Third-party handoff is [#12](https://github.com/ocapn/ocapn/issues/12); the embargo/flush/ordering parenthetical points at the unresolved coordination questions that surface inside 3PH flows. Today's (2026-06-09) closure of [#265](https://github.com/ocapn/ocapn/issues/265) — the *Two Generals' Problem* of 3PH — is the most recent movement in this cluster.

**Open:**

- [#12](https://github.com/ocapn/ocapn/issues/12) — 3rd-party handoff design requirements — @zenhack — `focus` — assigned @erights
- [#11](https://github.com/ocapn/ocapn/issues/11) — Promise Shortening — @erights — 61 comments (the long-running thread where 3PH embargo and flush surface)
- [#40](https://github.com/ocapn/ocapn/issues/40) — Ordering Guarantees (E-Order vs. point-to-point FIFO?) — @zenhack — `Meeting, focus`
- [#195](https://github.com/ocapn/ocapn/issues/195) — Explicit delivery ordering aka op:deliver-after — @kriskowal
- [#197](https://github.com/ocapn/ocapn/issues/197) — Spec Ambiguity: Referencing answerPos in its own op:deliver args — @kumavis
- [#199](https://github.com/ocapn/ocapn/issues/199) — Question: Can desc:answer appear in op:deliver args? — @kumavis
- [#191](https://github.com/ocapn/ocapn/issues/191) — Document promise pipelining cases where fulfilled object not on same peer as resolver — @RidleyWrites
- [#15](https://github.com/ocapn/ocapn/issues/15) — Replacing deliver.rdr with op:listen? — @zenhack — `focus`
- [#167](https://github.com/ocapn/ocapn/issues/167) — Proposal: Single op:deliver with op:listen subscription — @kumavis — `focus`
- [#13](https://github.com/ocapn/ocapn/issues/13) — Distributed Garbage Collection — @zarutian

**Closed baseline:**

- [#34](https://github.com/ocapn/ocapn/issues/34) — Third Party Handoffs — closed 2023-02-23
- [#67](https://github.com/ocapn/ocapn/issues/67) — To conflate or divide the family of op:deliver — closed 2026-01-13 — `focus`
- [#169](https://github.com/ocapn/ocapn/issues/169) — Proposal: Descriptor for imported AnswerPromise — closed 2025-09-30
- [#202](https://github.com/ocapn/ocapn/issues/202) — Fold op:deliver-only into op:deliver — closed 2026-02-17 — `focus`
- [#206](https://github.com/ocapn/ocapn/issues/206) — Change op:listen to have one mode of operation — closed 2026-03-10 — `focus`
- [#213](https://github.com/ocapn/ocapn/issues/213) — Change GC ops to take a list of positions — closed 2026-01-13
- [#214](https://github.com/ocapn/ocapn/issues/214) — Spec needed: Redundant op:session-start — closed 2026-01-13
- [#265](https://github.com/ocapn/ocapn/issues/265) — 3PH Two Generals' Problem — closed 2026-06-09

## 3. Grant matching across web / off-web peers (off-web without redundant cryptography)

The criterion has two halves: the *grant matching* surface (locators, sturdyrefs, certificates, invitation handoff) and the *off-the-web* qualifier (netlayers that don't have TLS-equivalent cryptography underneath them).

**Open — grant matching:**

- [#29](https://github.com/ocapn/ocapn/issues/29) — OCapN locators / introduction by serialized reference — @tsyesika — `focus` — 47 comments
- [#270](https://github.com/ocapn/ocapn/issues/270) — Clarify locator format with no hints — @RidleyWrites
- [#218](https://github.com/ocapn/ocapn/issues/218) — Add sturdyrefs to model — @kriskowal — `Meeting, focus`
- [#222](https://github.com/ocapn/ocapn/issues/222) — Canonical encoding of Certificates &c — @kriskowal
- [#153](https://github.com/ocapn/ocapn/issues/153) — Out-of-band invitations to interact with capabilities — @kriskowal
- [#168](https://github.com/ocapn/ocapn/issues/168) — Document that Answers should be re-exported as newly exported promises — @kumavis — assigned @cwebber/@kriskowal/@erights/@davexunit
- [#41](https://github.com/ocapn/ocapn/issues/41) — Design of the bootstrap object/NonceLocator — @zenhack — `Meeting`
- [#212](https://github.com/ocapn/ocapn/issues/212) — Accommodate store-and-forward netlayers — @RidleyWrites
- [#150](https://github.com/ocapn/ocapn/issues/150) — Specify a netlayer — @davexunit — `focus`

**Open — off-the-web netlayer overload mitigations (the "without redundant cryptography" half):**

- [#233](https://github.com/ocapn/ocapn/issues/233) — Noise Protocol Netlayer Mitigations for Network Overload — @kriskowal
- [#232](https://github.com/ocapn/ocapn/issues/232) — E2EE Web Relay Netlayer mitigations for network overload — @kriskowal
- [#231](https://github.com/ocapn/ocapn/issues/231) — Tor Netlayer mitigations for network overload — @kriskowal
- [#229](https://github.com/ocapn/ocapn/issues/229) — Editors: Netlayer responsibilities for network overload mitigation — @kriskowal/@tsyesika
- [#228](https://github.com/ocapn/ocapn/issues/228) — Editors: Network overload mitigation — @kriskowal/@tsyesika

**Closed baseline:**

- [#174](https://github.com/ocapn/ocapn/issues/174) — Spec Bug: Handoff gift-id type — closed 2025-05-29
- [#215](https://github.com/ocapn/ocapn/issues/215) — Spec/Implementation inconsistency: ocapn-peer Record — closed (note: this is the open one — see Open list above; #216 is the closed sibling)
- [#216](https://github.com/ocapn/ocapn/issues/216) — Spec Ambiguity: ocapn-peer Record value type "hashmap" underspec — closed 2025-12-09
- [#258](https://github.com/ocapn/ocapn/issues/258) — Should `desc:handoff-give`'s `gift-id` be a bytearray or integer — closed 2026-05-01 — `Meeting, focus`

*Correction*: [#215](https://github.com/ocapn/ocapn/issues/215) is open (3 comments), opened 2025-12-02 by @kumavis. The closed sibling is [#216](https://github.com/ocapn/ocapn/issues/216).

## 4. Mutual authentication of peers and sessions

[#255](https://github.com/ocapn/ocapn/issues/255) explicitly enumerates the impersonation/DoS gap left by the current draft; [#53](https://github.com/ocapn/ocapn/issues/53) carries the long-running discussion of where the cryptographic boundary belongs.

**Open:**

- [#255](https://github.com/ocapn/ocapn/issues/255) — Peer authentication — @RidleyWrites — 6 comments
- [#53](https://github.com/ocapn/ocapn/issues/53) — per-session cryptography key pair in CapTP layer? — @dckc — `focus` — assigned @cwebber/@kriskowal/@tsyesika/@erights
- [#81](https://github.com/ocapn/ocapn/issues/81) — Should vats have static keys? — @dpwiz
- [#66](https://github.com/ocapn/ocapn/issues/66) — S-expressions in keys and signatures — @dpwiz (also encoding)
- [#225](https://github.com/ocapn/ocapn/issues/225) — Observability — @kriskowal (auth-events surface)

**Closed baseline:**

- [#78](https://github.com/ocapn/ocapn/issues/78) — Spec/test-suite mismatch in public-key encoding — closed 2025-10-05
- [#163](https://github.com/ocapn/ocapn/issues/163) — Syrup format for "public-key" data structure not specified with syrup representation — closed 2025-05-29

## @erights's failure-partition question (@cwebber → sturdyref)

The exchange in the thread was abbreviated ("failure _something_ partition" / "more or less... _something_ ... sturdyref"). Two plausible readings: (a) partition-tolerant capability survival, which leans on sturdyrefs; (b) failure-mode classification across partitions, which leans on error model and observability.

**Open:**

- [#10](https://github.com/ocapn/ocapn/issues/10) — How should exceptions/errors work? — @zenhack — `focus` — assigned @erights — 25 comments
- [#142](https://github.com/ocapn/ocapn/issues/142) — Error type and passage invariants — @kriskowal — `focus`
- [#218](https://github.com/ocapn/ocapn/issues/218) — Add sturdyrefs to model — @kriskowal — `Meeting, focus` (the sturdyref half of @cwebber's response)
- [#212](https://github.com/ocapn/ocapn/issues/212) — Accommodate store-and-forward netlayers — @RidleyWrites (partition-tolerance dimension)
- [#225](https://github.com/ocapn/ocapn/issues/225) — Observability — @kriskowal

## Context

- **Roadmap framing**: [#208](https://github.com/ocapn/ocapn/issues/208) — *Proposed Roadmap and Derisking Protocol Evolution* — @kriskowal — closed 2025-12-13 — `focus`. Not itself a criterion but the broader framing for the conversation that produced [#272](https://github.com/ocapn/ocapn/issues/272).
- **Plenary cadence**: [#271](https://github.com/ocapn/ocapn/issues/271) is the June 2026 meeting issue under which [#272](https://github.com/ocapn/ocapn/issues/272) was raised. The July 2026 meeting issue is not yet open as of 2026-06-09.
- **Cross-criterion issues**: [#66](https://github.com/ocapn/ocapn/issues/66) (S-expressions in keys), [#173](https://github.com/ocapn/ocapn/issues/173) (Sortable Passable Key), [#246](https://github.com/ocapn/ocapn/issues/246) (tagged values), and [#29](https://github.com/ocapn/ocapn/issues/29) (locators) all touch more than one criterion. Each is listed under its primary criterion above.

## Coverage stats

Of the 19 `focus`-labeled issues recorded in [issues-index.md](./issues-index.md):

- **13 are open**, distributed across criterion 1 (4), criterion 2 (4), criterion 3 (3), criterion 4 (1), and @erights's question (2). Several appear under more than one criterion above; the counts reflect primary assignment.
- **6 are closed** (#258, #238, #208, #206, #202, #67), which is the closed baseline cited under criteria 1 and 2.

## Method

The mapping was constructed from issue titles + opening text for issues whose criterion-assignment wasn't obvious from the title alone (read selectively: [#218](https://github.com/ocapn/ocapn/issues/218), [#265](https://github.com/ocapn/ocapn/issues/265), [#255](https://github.com/ocapn/ocapn/issues/255), [#212](https://github.com/ocapn/ocapn/issues/212), [#195](https://github.com/ocapn/ocapn/issues/195), [#53](https://github.com/ocapn/ocapn/issues/53), [#29](https://github.com/ocapn/ocapn/issues/29), [#153](https://github.com/ocapn/ocapn/issues/153), [#168](https://github.com/ocapn/ocapn/issues/168)). All reads were anonymous via the public REST API. No comments, reactions, or other writes were made.

The mapping is a starting point, not a recommendation for what should land in [milestone #2](https://github.com/ocapn/ocapn/milestone/2). The plenary will resolve that at the July 2026 meeting.
