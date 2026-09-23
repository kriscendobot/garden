---
title: "`@endo/pass-style/src/makeTagged.js` — the constructor counterpart to the TaggedHelper validator"
source-slug: endo--packages-pass-style-src-makeTagged-js
section-slug: the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/makeTagged.js
source-repo: endojs/endo
source-path: packages/pass-style/src/makeTagged.js
source-author: Endo project (collective)
total-lines: 31
ingest-cycle: 270
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-makeTagged-js--the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map
---

A 31-line file that exports `makeTagged(tag, payload)`, the **constructor** for tagged records. **Closes the loop with cycle 268's `TaggedHelper`** — cycle 268 ingested the validator that checks the structure; cycle 270 ingests the constructor that builds the structure. The two stand side by side as a constructor-validator pair.

§First-explicit-observation in library: **§the-constructor-and-validator-form-a-pair-where-the-validator-checks-what-the-constructor-builds — §`makeTagged`-builds-the-three-named-own-properties (PASS_STYLE + Symbol.toStringTag + payload) + §`TaggedHelper`-checks-the-three-named-own-properties + §the-pair-IS-the-tagged-record-protocol's-canonical-interface**.

§Two-cycles-with-constructor-validator-loops-closed (268 TaggedHelper validator + 270 makeTagged constructor); §sibling-pattern to cycle 267's spec-instance loop (CLAUDE.md spec + README instance) — §the-loop-closure-IS-an-emerging-meta-pattern.
