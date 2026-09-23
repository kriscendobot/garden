---
title: The cyclic-dependency disclaimer that forces assert/X/Fail to be reached via globalThis instead of imported; the meta-level-privilege framing for the module's deliberate global mutable state (the *only* exception to this module's no-observably-mutable-state norm); the two env-option gates (`TRACK_TURNS=enabled` for the feature; `DEBUG=track-turns` for verbose console logging)
source: packages/eventual-send/src/track-turns.js
source_repo: endojs/endo
source_branch: master
source_commit: 86d983a0fbd1c16089953eecabaec28e85defed5
source_date: 2025-05-12
source_authors: [Mark S. Miller]
source_lines: "1-31 (imports + cyclic-dependency disclaimer + global mutable state warning + env-option gates)"
topics: [eventual-send, errors, hardened-javascript]
status: current
notes: |
  The track-turns module is the *causal-console* instrument for the
  eventual-send pipeline: when an asynchronous-sent message is sent in
  turn `T:E` and then a later receiving turn throws or rejects, the
  diagnostic on the thrown/rejected error is annotated with the
  sending turn's address. The module is *normally inert* — it only
  activates when explicitly enabled via the `TRACK_TURNS=enabled`
  environment option. The opening comment block is unusual in
  declaring this module's *deliberate* global mutable state (`let
  hiddenPriorError`, `let hiddenCurrentTurn`, `let
  hiddenCurrentEvent`) with the *meta-level-privilege* framing:
  *normally we regard the ability to see console log output as a
  meta-level privilege analogous to the ability to debug; aside from
  that, this module should not have any observably mutable state*.
kind: index
section_count: 6
---

Sections:

- [Abstract](endo--packages-eventual-send-src-track-turns-js--module-disclaimers-and-env-option-gates--abstract.md)
- [Body](endo--packages-eventual-send-src-track-turns-js--module-disclaimers-and-env-option-gates--body.md)
- [Connection to the wider library](endo--packages-eventual-send-src-track-turns-js--module-disclaimers-and-env-option-gates--connection-to-the-wider-library.md)
- [Translation block (comment idiom → contemporary practice)](endo--packages-eventual-send-src-track-turns-js--module-disclaimers-and-env-option-gates--translation-block-comment-idiom-contemporary-practice.md)
- [See also](endo--packages-eventual-send-src-track-turns-js--module-disclaimers-and-env-option-gates--see-also.md)
- [Common confusions](endo--packages-eventual-send-src-track-turns-js--module-disclaimers-and-env-option-gates--common-confusions.md)
