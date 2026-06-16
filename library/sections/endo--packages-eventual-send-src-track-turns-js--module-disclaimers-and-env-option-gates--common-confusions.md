---
title: Common confusions
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

- **"Track-turns runs by default."** No — it is `disabled` by default. Set `TRACK_TURNS=enabled` to activate. The decision is *opt-in*: the performance impact of wrapped functions matters, so the default is inert.
- **"The global mutable state is a hardening violation."** It would be, *except* it affects only the causal-console diagnostic surface. The meta-level-privilege framing justifies the exception. A program cannot observe these globals from program semantics; they only show up in console output.
- **"`DEBUG=track-turns` enables track-turns."** No — it enables *verbose console output from* track-turns. `TRACK_TURNS=enabled` is what enables the feature itself. The two gates are independent.
- **"`assert.note` is a global side-effect."** It mutates an *Error object's* notes-list; the Error is the thing being thrown or rejected. The Error is going to flow up the stack anyway; annotating it is a *non-observable* operation in the sense that it doesn't affect *what happens next*; it only affects what the causal-console *displays* when the Error is eventually logged.
- **"The cyclic dependency should be fixed."** The disclaimer notes *this is more easily fixed*, but the workaround works. Fixing the cycle is *tracked externally* in `agoric-sdk#9515`. Until then, the lazy-globalThis-access pattern is correct.
- **"`getEnvironmentOption('TRACK_TURNS', 'disabled', ['enabled'])` is awkward."** The three-argument shape is the standard `@endo/env-options` pattern: option name, default value, allowed non-default values. The allowlist makes invalid values explicit; an unrecognized value (e.g. `TRACK_TURNS=foo`) yields the default rather than silently breaking.
