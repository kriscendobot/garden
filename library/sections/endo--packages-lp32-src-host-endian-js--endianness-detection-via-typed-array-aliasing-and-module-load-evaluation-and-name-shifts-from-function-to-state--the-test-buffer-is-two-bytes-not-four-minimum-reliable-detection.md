---
title: §The test buffer is two bytes not four — minimum reliable detection
source-slug: endo--packages-lp32-src-host-endian-js
source-url: https://github.com/endojs/endo/blob/master/packages/lp32/src/host-endian.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/lp32/src/host-endian.js
total-lines: 9
ingest-cycle: 243
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-lp32-src-host-endian-js--endianness-detection-via-typed-array-aliasing-and-module-load-evaluation-and-name-shifts-from-function-to-state
---

§The-test-buffer-uses-two-bytes-not-four. §Two-bytes-is-sufficient-because-Uint16-reads-two-bytes; §using-four-bytes-would-be-equally-correct-but-not-more-discriminating. §When-detecting-byte-order, §use-the-smallest-unit-that-distinguishes-the-orderings. §Sibling-to-cycle-237's-the-`despite`-clauses-construct-the-tie-scenario-to-verify-the-tie-breaker-fires — both patterns construct the §minimum-evidence-the-test-needs.

§The-bytes-[1, 0]-are-not-arbitrary: §the-1-is-the-distinguishing-bit + §the-0-is-the-don't-care-padding. §The-test-distinguishes-1-from-256-because-256-is-1-shifted-by-8. §When-the-test-relies-on-a-single-distinguishing-bit, §put-the-bit-in-the-byte-that-the-target-endianness-treats-as-the-LSB.
