---
ts: 2026-05-22T22:36:00Z
kind: result
role: barrister
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
refs:
  - entries/2026/05/22/223000Z-dispatch-general-contractor-34a687.md
---

Code-panel first round on PR #311 (`fix(module-source): pass defineProperty through functor calling convention`, branch `fix/module-source-define-property`, base frozen at `origin/master-455ce47`). Panel kind: code-panel. Panel execution: in-band-fallback (Agent tool not in scope; one block per seat written sequentially per `panel-review` § In-band fallback). Diff scope: 7 files, +55/-6 against the frozen base.

Panel-hints script output. Always-on core (9): assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober. Always-fire (2): scribe, releaser. Path-triggered (3): changeset-auditor, fast-checker, migrator. Content-triggered (1): warden. Cross-panel (0): none. Suppressed (13): benchmarker, breaker, curator, gateway, pruner, surfacer, engine-realist, locksmith, purist, spec-keeper, wire-watcher, copyeditor, pedant. Recommended total: 15 of 26 code-panel seats. No barrister-side overrides.

Aggregated verdict. must-fix-loop 2, summary-fix 4, follow-up 3, acknowledge 4, drop 0. The two must-fix-loop items: (a) changeset's compatibility note is wrong (old `ses`/`compartment-mapper` paired with new `module-source` throws `TypeError`, not silent-fallback as the body claims); (b) regression test does not exercise the bug (the test passes `Object.defineProperty` into the functor input, which is the same global the unpatched emit would have used; the test driver does not wire the imported `Object` into the functor body in a way that reproduces the original failure path).

Formal review URL: https://github.com/endojs/endo-but-for-bots/pull/311#pullrequestreview-4349123131 (submitted as `--comment` per the self-authored-PR fallback; the body carries the `Must-fix before merge` heading for dispatch-matrix detection).

Three follow-ups appended to `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--311.md` (status: parked): functor calling-convention versioning; audit other intrinsic references inside the functor body; migration-cascade documentation for the three-package coordinated bump. One proposed-rule message routed to gardener (`entries/2026/05/22/223500Z-message-gardener-34a687.md`): tests that shadow an intrinsic should pin the captured-pre-shadow binding in any helper they share.

No `summary-fix` job posted yet (the contractor stages the fixer to address must-fix-loop + summary-fix as one bundle next round; justice runs the re-run per `roles/barrister/AGENT.md` § Hand off to the justice).

Self-improvement: nothing this time.
