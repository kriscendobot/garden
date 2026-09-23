---
ts: 2026-06-17T09:00:00Z
kind: result
role: barrister
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs: []
---

PR #471 — `refactor(chat): migrate the Chat UI to confined Preact (@endo/preact-container)`.
External author: kumavis.

Panel-hints output (verbatim):

```
Panel-kind: code-panel
Always-on core (9): assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober
Always-fire (2): scribe, releaser
Path-triggered (9): benchmarker, breaker, changeset-auditor, curator, fast-checker, gateway, migrator, pruner, surfacer
  benchmarker  packages/benchmark/README.md
  breaker  CLAUDE.md (M.interface / makeExo / ## Invariants)
  changeset-auditor  .changeset/add-endo-tar.md
  curator  packages/9p-server/src/index.js
  fast-checker  browser-test/tests/chat-smoke.spec.js
  gateway  .github/workflows/browser-test.yml
  migrator  84 packages touched
  pruner  .claude/skills/endo/skill.md (+37 lines)
  surfacer  packages/git (4 surface files touched)
Content-triggered (6): engine-realist, locksmith, purist, spec-keeper, warden, wire-watcher
Cross-panel (2): copyeditor, pedant
Recommended total: 28 of 26 code-panel seats (+ 2 cross-panel)
```

Barrister overrides: none. All 28 seats run in-band.

Panel execution: in-band-fallback (Agent tool not available in dispatch).
Panel kind: code-panel.
External-author calibration applied: em-dash-style and no-latin-shorthand findings dropped.
PR state at dispatch: OPEN, isDraft=false (standalone maintainer-requested review; not standard pipeline DRAFT).

Formal review submitted: `gh pr review 471 -R endojs/endo-but-for-bots --request-changes`.
reviewDecision confirmed: CHANGES_REQUESTED.

Disposition counts: 1 must-fix-loop | 3 summary-fix | 4 follow-up | 4 acknowledge | 0 drop.

Must-fix items (loop-blocking):
1. `packages/chat/command-executor.js` — 19 new `console.log` calls for trace/progress diagnostics. CLAUDE.md § Diagnostic discipline: libraries must be silent by default; only `console.error` is appropriate for actual errors.

Summary-fix items (one fixer dispatch, no re-panel):
1. `yarn.lock` churn should be in its own commit separate from implementation, per CLAUDE.md § Pre-PR checklist.
2. `.tmp/` endo-cli test state files appear in the diff; should be gitignored.
3. `_registerSecureReentryType` / `_registerTrustedExitType` names with leading underscore may conflict with `no-underscore-dangle` ESLint rule per CLAUDE.md § Lint-rule gotchas.

Follow-up items (ledger): see `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--471.md`.

Next stage: `next: liaison` (external PR; user decides). The maintainer (kumavis) is the author; standard fixer dispatch is not applicable. The must-fix items are for the author to address.

Proposed-rule messages written to gardener: see `090100Z-message-barrister-b6181c.md` (same timestamp prefix, different suffix).

Self-improvement: the external-author calibration (dropping garden prose conventions from external PRs) was applied cleanly; this is the second application after the #467 solicitor dispatch that established the rule. The rule is working well. No structural lesson warrants a role or skill change today.
