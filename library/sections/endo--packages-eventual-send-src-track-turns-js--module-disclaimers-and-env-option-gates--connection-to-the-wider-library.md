---
title: Connection to the wider library
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
parent: endo--packages-eventual-send-src-track-turns-js--module-disclaimers-and-env-option-gates
---

This section is the **canonical worked example of *deliberate-controlled-mutable-state-as-meta-level-privilege*** at the @endo/eventual-send level. Three threads:

1. **The cyclic-dependency-and-not-in-scope-before-lockdown disclaimer pattern.** Any module that needs to use SES-tamed errors but must load *during* lockdown carries the same hazard. The track-turns workaround (lazy `globalThis.assert` access + commented-out static imports + external-issue pointer) is the canonical mitigation.

2. **The meta-level-privilege framing for deliberate mutable state.** A module that affects only diagnostic surfaces can carry mutable state without violating capability discipline. The library can cite this section whenever a module needs to *justify* mutable state under the hardened JavaScript norm.

3. **The two-gate pattern (feature + verbosity).** Feature-enable is one gate; verbose-output is a separate orthogonal gate. Reusable for any module with optional debugging surfaces.
