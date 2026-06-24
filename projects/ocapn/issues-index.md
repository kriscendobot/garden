---
created: 2026-06-09
updated: 2026-06-09
author: liaison
project: ocapn
generated_at: 2026-06-09T00:20Z
source: GitHub REST API (public, anonymous)
constraint: internal-only; no comments posted; no outward-facing references
---

# Issues index

Snapshot of every issue in the upstream OCapN repository as of 2026-06-09. Pure-read enumeration via the public GitHub REST API; **no comment, reaction, or write of any kind was made to upstream**. Pull requests are excluded (the `/issues` endpoint returns both; this index keeps issues only).

Engagement constraints carried over from this project's [README](README.md) § *Rules of engagement* apply to anyone acting on anything in this file: no comments, no outward cross-references, no monitoring. Reference each entry by issue number within the garden's internal journal only.

## Totals

- **Total issues**: 174
- **Open**: 84
- **Closed**: 90
- **Highest issue number**: 272
- **Oldest open**: #4 (2021-04-16)
- **Most recent open**: #272 (2026-06-09)

## Labels in use

| Label | Count |
|---|---|
| `focus` (any combination) | 22 |
| `Meeting` (any combination) | 8 |
| `duplicate` | 1 |
| (no labels) | 152 |

Most issues carry no labels. `focus` is the load-bearing classifier; `Meeting` tags monthly-meeting tracker issues; `duplicate` appears once.

## Authors (by count)

| Author | Count |
|---|---|
| @jar398 | 47 |
| @kriskowal | 36 |
| @tsyesika | 13 |
| @kumavis | 12 |
| @RidleyWrites | 12 |
| @zenhack | 11 |
| @cwebber | 10 |
| @dckc | 9 |
| @dpwiz | 7 |
| @gibson042 | 7 |
| @erights | 3 |
| @cab404 | 2 |
| @zarutian | 2 |
| @davexunit | 1 |
| @ghost | 1 |
| @lthibault | 1 |

@jar398's count is dominated by monthly-meeting tracker issues.

## `focus`-labeled issues (cross-reference)

These are the issues the upstream has flagged as load-bearing for current consensus work.

- #258 — Should `desc:handoff-give`'s `gift-id` be a bytearray or integer — closed 2026-05-01 — @tsyesika
- #238 — Spec incoherence: Non-passable passables — closed 2025-12-14 — @kriskowal
- #218 — Add sturdyrefs to model — **open** — @kriskowal
- #208 — Proposed Roadmap and Derisking Protocol Evolution — closed 2025-12-13 — @kriskowal
- #206 — Change op:listen to have one mode of operation — closed 2026-03-10 — @RidleyWrites
- #202 — Fold op:deliver-only into op:deliver — closed 2026-02-17 — @RidleyWrites
- #186 — Should Swiss num be serialized as String or Bytes? — **open** — @RidleyWrites
- #172 — Reusability of passable data aka Slots — **open** — @kriskowal
- #167 — Proposal: Single op:deliver message type with resolution subscription via `op:listen` — **open** — @kumavis
- #150 — Specify a netlayer — **open** — @davexunit
- #142 — Error type and passage invariants — **open** — @kriskowal
- #138 — Streaming Netstring message framing — **open** — @kriskowal
- #67 — To conflate or divide the family of op:deliver — closed 2026-01-13 — @dpwiz
- #53 — per-session cryptography key pair in CapTP layer? — **open** — @dckc
- #40 — Ordering Guarantees (E-Order vs. point-to-point FIFO?) — **open** — @zenhack
- #29 — OCapN locators / introduction by serialized reference — **open** — @tsyesika
- #15 — Replacing deliver.rdr with op:listen? — **open** — @zenhack
- #12 — 3rd-party handoff design requirements — **open** — @zenhack
- #10 — How should exceptions/errors work? — **open** — @zenhack

## Open issues (84, newest first)

- #272 — Nominations for First Consensus Draft Criteria — @dckc — opened 2026-06-09 — 3 comments
- #271 — June 2026 meeting — @jar398 — opened 2026-06-03 — 1 comments
- #270 — Clarify locator format with no hints — @RidleyWrites — opened 2026-05-20
- #268 — Explicit policy on (non) usage of AIgen for OCapn contributions — @cwebber — opened 2026-05-12 — 10 comments
- #266 — May 2026 meeting — @jar398 — opened 2026-05-05 — assigned: @jar398 — 9 comments
- #264 — Version number should not be 1.0 until 1.0 — @cwebber — opened 2026-04-21 — 5 comments
- #262 — April 2026 meeting — @jar398 — opened 2026-04-10 — assigned: @jar398 — 2 comments
- #257 — Implementation guide does not cover `op:get`, `op:index` and `op:untag` — @tsyesika — opened 2026-02-17
- #255 — Peer authentication — @RidleyWrites — opened 2026-02-04 — 6 comments
- #249 — CBOR — @kriskowal — opened 2025-12-18 — 6 comments
- #246 — Add a representation for tagged values — @kriskowal — opened 2025-12-16 — 5 comments
- #243 — `swiss-number` is under-documented — @gibson042 — opened 2025-12-15 — 1 comments
- #242 — Why do `deposit-gift` and `op:get`/`op:index`/`op:untag` expect to receive `desc:import-*`? — @gibson042 — opened 2025-12-15 — 3 comments
- #241 — Senders can impose large storage obligations upon receivers — @gibson042 — opened 2025-12-15 — 2 comments
- #237 — Two party subset — @kriskowal — opened 2025-12-13 — 1 comments
- #236 — Resolver target objects or message operations — @kriskowal — opened 2025-12-13 — assigned: @kriskowal — 40 comments
- #235 — Editors: Document calling convention — @kriskowal — opened 2025-12-13
- #233 — Noise Protocol Netlayer Mitigations for Network Overload — @kriskowal — opened 2025-12-13
- #232 — E2EE Web Relay Netlayer mitigations for network overload — @kriskowal — opened 2025-12-13
- #231 — Tor Netlayer mitigations for network overload — @kriskowal — opened 2025-12-13
- #230 — Editors: Message delivery guarantees — @kriskowal — opened 2025-12-13 — assigned: @kriskowal, @tsyesika
- #229 — Editors: Netlayer responsibilities for network overload mitigation — @kriskowal — opened 2025-12-13 — assigned: @kriskowal, @tsyesika
- #228 — Editors: Network overload mitigation — @kriskowal — opened 2025-12-13 — assigned: @kriskowal, @tsyesika
- #226 — Nuances of Cooperation — @kriskowal — opened 2025-12-11
- #225 — Observability — @kriskowal — opened 2025-12-11 — 2 comments
- #222 — Canonical encoding of Certificates &c — @kriskowal — opened 2025-12-05
- #218 — Add sturdyrefs to model — @kriskowal — opened 2025-12-02 — labels: Meeting, focus — 11 comments
- #217 — December 2025 meeting — @jar398 — opened 2025-12-02 — 4 comments
- #215 — Spec/Implementation inconsistency: ocapn-peer Record — @kumavis — opened 2025-12-02 — 3 comments
- #212 — Accommodate store-and-forward netlayers — @RidleyWrites — opened 2025-11-18 — 2 comments
- #209 — Weekly Implementer Group Meeting — @tsyesika — opened 2025-11-11 — 30 comments
- #207 — November 2025 meeting — @jar398 — opened 2025-11-05 — assigned: @jar398 — 4 comments
- #203 — Suspicious lack of the "turn" in the docs — @dpwiz — opened 2025-10-05 — 3 comments
- #201 — Target round trip expectations — @kumavis — opened 2025-09-30 — 1 comments
- #200 — October 2025 meeting — @jar398 — opened 2025-09-26 — assigned: @jar398 — 4 comments
- #199 — Question: Can desc:answer appear in op:deliver args? — @kumavis — opened 2025-09-10 — 2 comments
- #198 — Aesthetic: s/object/target/ in ops and descs — @kriskowal — opened 2025-09-09
- #197 — (low priority) Spec Ambiguity: Referencing answerPos in its own op:deliver args — @kumavis — opened 2025-09-09 — 3 comments
- #195 — Explicit delivery ordering aka op:deliver-after — @kriskowal — opened 2025-09-09 — 2 comments
- #194 — Three ways to negotiate/upgrade/migrate the concrete format — @kriskowal — opened 2025-09-04
- #193 — September 2025 meeting — @jar398 — opened 2025-08-29 — assigned: @jar398 — 5 comments
- #191 — Document promise pipelining cases where fulfilled object not on same peer as resolver — @RidleyWrites — opened 2025-08-06 — 2 comments
- #186 — Should Swiss num be serialized as String or Bytes? — @RidleyWrites — opened 2025-07-21 — labels: focus — 7 comments
- #184 — Implementation guide import/export mixup — @RidleyWrites — opened 2025-07-16 — 1 comments
- #183 — Perimeter types / Protocol extension — @tsyesika — opened 2025-07-10 — 4 comments
- #182 — website is outdated — @kumavis — opened 2025-07-09 — 4 comments
- #173 — Sortable Passable Key — @kriskowal — opened 2025-05-16
- #172 — Reusability of passable data aka Slots — @kriskowal — opened 2025-05-15 — labels: focus — 3 comments
- #168 — Document that Answers should be re-exported as newly exported promises — @kumavis — opened 2025-05-12 — assigned: @cwebber, @kriskowal, @erights, @davexunit — 13 comments
- #167 — Proposal: Single op:deliver message type with resolution subscription via `op:listen` — @kumavis — opened 2025-05-12 — labels: focus — assigned: @kriskowal, @tsyesika — 16 comments
- #153 — Out-of-band invitations to interact with capabilities (à la OS or Web Intents) — @kriskowal — opened 2025-02-26 — assigned: @kriskowal — 3 comments
- #150 — Specify a netlayer — @davexunit — opened 2025-02-11 — labels: focus — 2 comments
- #144 — Disprefer the name Struct — @kriskowal — opened 2024-12-10 — 3 comments
- #142 — Error type and passage invariants — @kriskowal — opened 2024-11-19 — labels: focus — 3 comments
- #138 — Streaming Netstring message framing — @kriskowal — opened 2024-10-21 — labels: Meeting, focus — 5 comments
- #131 — Calling Convention — @tsyesika — opened 2024-09-10 — 5 comments
- #124 — Arena allocators are a non-goal of OCapN — @kriskowal — opened 2024-07-09 — 1 comments
- #123 — Capture invariant: OCapN is lossless — @kriskowal — opened 2024-07-09 — assigned: @kriskowal
- #122 — Immutability of passable data — @kriskowal — opened 2024-07-09 — 1 comments
- #121 — Data Model based Compression — @kriskowal — opened 2024-07-09 — 1 comments
- #119 — Distributed debugging — @jar398 — opened 2024-06-11 — assigned: @tsyesika — 4 comments
- #117 — Add versioning to facilitate transport negotiation — @tsyesika — opened 2024-06-03
- #113 — iCal file for meetings — @cab404 — opened 2024-04-16
- #111 — Invitation to Cap'n Proto monthly "office hours" chat — @lthibault — opened 2024-03-29 — 7 comments
- #101 — Identifying promise and target references — @kriskowal — opened 2024-01-10 — 4 comments
- #81 — Should vats have static keys? — @dpwiz — opened 2023-09-08 — 1 comments
- #76 — Properties that OCapN has universally, given blockchain constraints — @jar398 — opened 2023-07-11
- #71 — What are our documentation deliverables? — @zenhack — opened 2023-06-30
- #66 — S-expressions in keys and signatures — @dpwiz — opened 2023-06-17 — 3 comments
- #63 — Proposed wire format: passable encoding — @gibson042 — opened 2023-06-13 — assigned: @erights, @gibson042 — 6 comments
- #53 — per-session cryptography key pair in CapTP layer? — @dckc — opened 2023-05-23 — labels: focus — assigned: @cwebber, @kriskowal, @tsyesika, @erights — 12 comments
- #52 — What is Tagged for? — @zenhack — opened 2023-05-22 — 11 comments
- #48 — core data types: ByteArray test / interop — @dckc — opened 2023-05-17 — 8 comments
- #47 — core data types: string details, e.g. lone surrogate — @dckc — opened 2023-05-17 — 39 comments
- #41 — Design of the bootstrap object/NonceLocator — @zenhack — opened 2023-04-11 — labels: Meeting — 4 comments
- #40 — Ordering Guarantees (E-Order vs. point-to-point FIFO?) — @zenhack — opened 2023-03-31 — labels: Meeting, focus — 15 comments
- #30 — Prepare and get consensus on charter — @jar398 — opened 2023-01-29 — assigned: @jar398 — 2 comments
- #29 — OCapN locators / introduction by serialized reference — @tsyesika — opened 2023-01-13 — labels: focus — assigned: @tsyesika — 47 comments
- #15 — Replacing deliver.rdr with op:listen? — @zenhack — opened 2021-10-04 — labels: focus — assigned: @tsyesika — 3 comments
- #13 — Distributed Garbage Collection — @zarutian — opened 2021-09-02 — 12 comments
- #12 — 3rd-party handoff design requirements. — @zenhack — opened 2021-07-20 — labels: focus — assigned: @erights — 12 comments
- #11 — Promise Shortening — @erights — opened 2021-04-27 — 61 comments
- #10 — How should exceptions/errors work? — @zenhack — opened 2021-04-24 — labels: focus — assigned: @erights — 25 comments
- #4 — Verbose record labels while we figure things out, enums or short labels later — @cwebber — opened 2021-04-16 — 3 comments

## Closed issues (90, newest first)

- #265 — 3PH Two Generals' Problem — @RidleyWrites — opened 2026-04-22 — closed 2026-06-09 — 4 comments
- #259 — March 2026 meeting — @jar398 — opened 2026-03-04 — closed 2026-05-05 — 4 comments
- #258 — Should `desc:handoff-give`'s `gift-id` be a bytearray or integer — @tsyesika — opened 2026-02-26 — closed 2026-05-01 — labels: Meeting, focus — 4 comments
- #254 — February 2026 meeting — @jar398 — opened 2026-02-02 — closed 2026-06-03 — 1 comments
- #250 — January 2026 meeting — @jar398 — opened 2025-12-27 — closed 2026-06-03 — 6 comments
- #238 — Spec incoherence: Non-passable passables — @kriskowal — opened 2025-12-13 — closed 2025-12-14 — labels: focus — 1 comments
- #216 — Spec Ambiguity: ocapn-peer Record value type "hashmap" is underspecified — @kumavis — opened 2025-12-02 — closed 2025-12-09 — 3 comments
- #214 — Spec needed: Redundant op:session-start on same connection for established session — @kumavis — opened 2025-12-02 — closed 2026-01-13 — 1 comments
- #213 — Change GC ops to take a list of positions — @RidleyWrites — opened 2025-11-19 — closed 2026-01-13 — 1 comments
- #211 — Wrong receiver-desc in op:untag, op:index, op:get — @RidleyWrites — opened 2025-11-15 — closed 2026-01-23 — 6 comments
- #208 — Proposed Roadmap and Derisking Protocol Evolution — @kriskowal — opened 2025-11-11 — closed 2025-12-13 — labels: focus — 2 comments
- #206 — Change op:listen to have one mode of operation — @RidleyWrites — opened 2025-10-29 — closed 2026-03-10 — labels: focus — 4 comments
- #202 — Fold op:deliver-only into op:deliver — @RidleyWrites — opened 2025-10-03 — closed 2026-02-17 — labels: focus — 8 comments
- #187 — August 2025 meeting — @jar398 — opened 2025-07-22 — closed 2025-09-26 — 7 comments
- #185 — Implementation guide op:deliver example incorrect method name — @RidleyWrites — opened 2025-07-16 — closed 2026-01-27 — 1 comments
- #181 — Remove potentially over ambitious timeframe from README — @tsyesika — opened 2025-07-08 — closed 2025-07-10 — 1 comments
- #180 — July 2025 meeting — @jar398 — opened 2025-07-02 — closed 2025-09-01 — 10 comments
- #177 — June 2025 meeting — @jar398 — opened 2025-05-29 — closed 2025-07-22 — 4 comments
- #174 — Spec Bug: Handoff gift-id inconsistenly defined as "non-negative integer" or "bytestring" — @kumavis — opened 2025-05-22 — closed 2025-05-29 — 1 comments
- #169 — Proposal: Descriptor for imported AnswerPromise — @kumavis — opened 2025-05-13 — closed 2025-09-30 — 3 comments
- #165 — Let's rename Selector to Symbol — @kriskowal — opened 2025-04-25 — closed 2025-12-13 — 8 comments
- #164 — May 2025 meeting — @jar398 — opened 2025-04-25 — closed 2025-06-16 — 11 comments
- #163 — Syrup format for "public-key" data structure not specified with syrup representation — @kumavis — opened 2025-04-24 — closed 2025-05-29 — 2 comments
- #158 — April 2025 meeting — @jar398 — opened 2025-03-13 — closed 2025-04-25 — 5 comments
- #154 — Propose op:get — @kriskowal — opened 2025-03-04 — closed 2025-05-29 — 1 comments
- #152 — March 2025 meeting — @jar398 — opened 2025-02-18 — closed 2025-04-05 — 4 comments
- #149 — February 2025 meeting — @jar398 — opened 2025-02-05 — closed 2025-03-13 — 5 comments
- #146 — January 2025 meeting — @jar398 — opened 2024-12-20 — closed 2025-03-13 — 5 comments
- #143 — December 2024 meeting — @jar398 — opened 2024-11-25 — closed 2025-03-13 — 2 comments
- #137 — November 2024 Meeting — @kriskowal — opened 2024-10-08 — closed 2024-12-29 — 6 comments
- #136 — October 2024 meeting — @jar398 — opened 2024-10-04 — closed 2024-12-29 — 3 comments
- #130 — September 2024 meeting — @jar398 — opened 2024-09-04 — closed 2025-03-13 — 3 comments
- #127 — August 2024 meeting — @jar398 — opened 2024-08-06 — closed 2024-12-29 — 2 comments
- #120 — July 2024 meeting — @jar398 — opened 2024-07-08 — closed 2024-08-13 — 3 comments
- #116 — June 2024 meeting — @jar398 — opened 2024-06-03 — closed 2024-08-13 — 7 comments
- #115 — ocapn.org ssl certificates are incorrect — @cab404 — opened 2024-05-14 — closed 2024-06-03 — 2 comments
- #114 — May 2024 meeting — @jar398 — opened 2024-05-02 — closed 2024-07-08 — 4 comments
- #110 — April 2024 meeting — @jar398 — opened 2024-03-19 — closed 2024-07-08 — 4 comments
- #108 — Abstract Syntax has agreement. Should move to draft-specs — @erights — opened 2024-03-12 — closed 2024-04-09 — 2 comments
- #107 — March 2024 meeting — @jar398 — opened 2024-03-03 — closed 2024-03-19 — 10 comments
- #103 — February 2024 meeting — @jar398 — opened 2024-01-15 — closed 2024-03-03 — 6 comments
- #99 — Jan 2024 meeting — @jar398 — opened 2023-11-18 — closed 2024-02-13 — 8 comments
- #94 — November 2023 meeting — @jar398 — opened 2023-10-10 — closed 2023-12-04 — 6 comments
- #93 — Working document to capture requirements and proposed requirements for concrete syntax(es) — @jar398 — opened 2023-10-10 — closed 2024-05-14 — 7 comments
- #92 — Working document to capture current consensus on abstract syntax (data model) — @jar398 — opened 2023-10-10 — closed 2025-01-06 — 7 comments
- #91 — Smallcaps Cheatsheet — @erights — opened 2023-10-01 — closed 2025-12-13 — 10 comments
- #83 — October 2023 meeting — @jar398 — opened 2023-09-14 — closed 2023-11-18 — 6 comments
- #80 — September 2023 meeting — @jar398 — opened 2023-08-21 — closed 2023-09-14 — 7 comments
- #78 — Spec/test-suite mismatch in public-key encoding — @dpwiz — opened 2023-08-06 — closed 2025-10-05 — 2 comments
- #75 — August 2023 meeting — @jar398 — opened 2023-07-11 — closed 2023-09-14 — 7 comments
- #74 — What to call 'URI serialization' — @jar398 — opened 2023-07-11 — closed 2023-09-12 — labels: duplicate — 5 comments
- #70 — July 2023 meeting — @jar398 — opened 2023-06-23 — closed 2023-09-14 — 7 comments
- #68 — Notation used in the spec — @dpwiz — opened 2023-06-17 — closed 2023-07-10 — 6 comments
- #67 — To conflate or divide the family of op:deliver — @dpwiz — opened 2023-06-17 — closed 2026-01-13 — labels: focus — 4 comments
- #65 — Invoking methods / delivering args — @dpwiz — opened 2023-06-17 — closed 2025-12-13 — 3 comments
- #62 — bootstrap object methods: requirement or convention? — @gibson042 — opened 2023-06-13 — closed 2025-12-13 — 11 comments
- #58 — core data types: IEEE floating point (in)compatibility — @jar398 — opened 2023-05-24 — closed 2025-12-13 — 37 comments
- #57 — June 2023 meeting — @jar398 — opened 2023-05-23 — closed 2023-07-11 — 7 comments
- #56 — Concrete syntax ordering guarantees — @jar398 — opened 2023-05-23 — closed 2026-06-09 — 5 comments
- #55 — Interoperability of promise multi-resolution — @gibson042 — opened 2023-05-23 — closed 2025-04-14 — 13 comments
- #54 — Object method identification: convention or requirement? — @gibson042 — opened 2023-05-23 — closed 2025-12-13 — 8 comments
- #50 — unit / bottom type(s): null / undefined — @dckc — opened 2023-05-17 — closed 2023-09-18 — 41 comments
- #49 — core data types: distinguish Promise vs Remotable? local vs remote? — @dckc — opened 2023-05-17 — closed 2025-12-13 — 3 comments
- #46 — core data types: symbol? — @dckc — opened 2023-05-17 — closed 2024-09-10 — labels: Meeting — 11 comments
- #45 — Recurring monthly meeting time: 19:00 UTC on 2nd Tues of month — @cwebber — opened 2023-05-17 — closed 2023-05-26 — 6 comments
- #43 — May 2023 meeting — @jar398 — opened 2023-04-25 — closed 2023-05-25 — 20 comments
- #38 — April 2023 meeting — @jar398 — opened 2023-03-26 — closed 2023-04-25 — 4 comments
- #37 — Prepare a set of working drafts — @jar398 — opened 2023-03-24 — closed 2023-05-29 — 5 comments
- #36 — March 2023 meeting — @jar398 — opened 2023-02-27 — closed 2023-04-25 — 23 comments
- #34 — Third Party Handoffs — @tsyesika — opened 2023-02-23 — closed 2023-02-23 — 1 comments
- #32 — February 2023 Meeting — @tsyesika — opened 2023-02-01 — closed 2023-03-27 — 5 comments
- #31 — insufficient github access for participants — @dckc — opened 2023-01-30 — closed 2023-04-02 — 8 comments
- #28 — January 2023 Pre-standardization meeting — @tsyesika — opened 2023-01-04 — closed 2023-02-23 — 21 comments
- #27 — Appointing a new chair — @tsyesika — opened 2022-12-07 — closed 2023-02-23 — 2 comments
- #25 — Capabilities vs. CapTP — @ghost — opened 2022-12-05 — closed 2024-12-20 — 2 comments
- #24 — Proposed captp protocol — @zarutian — opened 2022-12-03 — closed 2025-02-09 — 1 comments
- #23 — First pre-standardization meeting - 2022-12-06 8-9pm UTC — @tsyesika — opened 2022-11-14 — closed 2022-12-07 — labels: Meeting — 10 comments
- #20 — Backpressure? — @zenhack — opened 2022-03-16 — closed 2025-12-13 — 8 comments
- #19 — exploration: Agoric marshal types, protobuf, rholang data types — @dckc — opened 2022-01-17 — closed 2022-12-06 — 3 comments
- #18 — Terminology bikeshed: what to call vats-as-far-as-the-protocol-can-tell? — @zenhack — opened 2021-12-24 — closed 2024-09-10 — 11 comments
- #17 — IDL? — @zenhack — opened 2021-10-04 — closed 2025-08-26 — 3 comments
- #16 — Form of arguments return/values — @zenhack — opened 2021-10-04 — closed 2024-08-13 — 5 comments
- #9 — Agenda for group — @kriskowal — opened 2021-04-24 — closed 2024-07-09 — 6 comments
- #8 — Test suite — @cwebber — opened 2021-04-16 — closed 2023-09-14 — 4 comments
- #7 — Basic writeup of the current captp protocol — @cwebber — opened 2021-04-16 — closed 2024-07-10 — 6 comments
- #6 — Demonstrate Agoric & Spritely interop — @cwebber — opened 2021-04-16 — closed 2026-04-30 — 21 comments
- #5 — What are the core "data" types? — @cwebber — opened 2021-04-16 — closed 2024-07-09 — 101 comments
- #3 — CapTP AST / data representation and serialization — @cwebber — opened 2021-04-16 — closed 2024-07-10 — 24 comments
- #2 — The simple implementation rule: 2 parties implementable in 1 week, 3 parties in 3 weeks — @cwebber — opened 2021-04-16 — closed 2024-11-30 — 5 comments
- #1 — Design parameters ('epic issue') — @kriskowal — opened 2021-04-11 — closed 2024-07-09 — 26 comments

## Generation note

This index was built from `GET /repos/ocapn/ocapn/issues?state=all&per_page=100` paginated to 3 pages (174 items after filtering out pull requests). No write of any kind was made to upstream. To regenerate, page the same endpoint and re-project the fields `number / title / state / user.login / created_at / updated_at / labels / assignees / comments`.
