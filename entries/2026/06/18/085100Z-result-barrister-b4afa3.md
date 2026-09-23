---
ts: 2026-06-18T08:51:00Z
kind: result
role: barrister
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/06/18/085030Z-message-barrister-b4afa3.md
---

Barrister pass on PR #468 (feat(immutable-arraybuffer): freezable TypedArray emulation per #449 design).

Originating dispatch: barrister--b4afa3.
PR: endojs/endo-but-for-bots#468.
Branch: feat/freezable-typedarray-emulation (head a04fbe7af after cleaner d3f754 landed).
Panel kind: code-panel.
Panel execution: in-band-fallback (Agent tool not available at dispatch level).

Panel composition (25 of 26 + 2 cross-panel):
- Always-on (9): assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober
- Always-fire (2): scribe, releaser
- Path-triggered (6): changeset-auditor, curator, fast-checker, migrator, pruner, surfacer
- Content-triggered (6): engine-realist, locksmith, purist, spec-keeper, warden, wire-watcher
- Cross-panel (2): copyeditor, pedant
- Suppressed (1): breaker (no M.interface/makeExo in diff)

Verdict: MUST-FIX-LOOP (2 must-fix-loop items confirmed by runtime experiment)

Disposition counts:
- must-fix-loop: 2
- summary-fix: 2
- follow-up: 5
- acknowledge: ~12
- drop: 1 (packager Object.entries false alarm, confirmed non-issue)
- proposed-rule: 8

Must-fix-loop items (brief for fixer):

1. Symbol.iterator divergence. After the shim installs a `values` wrapper on `%TypedArrayPrototype%`, `tp[Symbol.iterator]` still points to the original genuine `values`. `for...of` and spread fail on emulated freezable wrappers with "this is not a typed array." Fix: install `[Symbol.iterator]` in `freezableTypedArrayLibProperties` (or explicitly update `tp[Symbol.iterator]` in `src/shim.js` after install). Add a `[...view]` regression test.

2. `subarray` returns mutable buffer. `view.subarray(0, 2).buffer.immutable === false`. The `subarray` delegate amplifies to the hidden genuine TypedArray and returns its native `subarray`, which has `buffer === genuineBackingBuffer` (mutable). Fix: either (a) wrap the returned view in a new pseudo-wrapper so its `.buffer` redirects to the immutable wrapper, or (b) document the limitation explicitly in README Caveats and add a test that asserts the current mutable-buffer shape with a comment explaining the known gap.

Summary-fix items (bundle for one fixer dispatch, no panel re-run needed):

1. `test/_lib-setup.md` second paragraph: remove stale reference to `index.js` as still-available (it is deleted by this PR).
2. `src/lib.js` comment block around line 345: replace `hiddenBuffers`/`reverseHiddenBuffers` alias names with actual variable names `buffers`/`reverseBuffers`.

Follow-up ledger: written to journal/projects/endo-but-for-bots/followups/endo-but-for-bots--468.md (5 items, status: parked).

Proposed-rule message: sent to gardener at entries/2026/06/18/085030Z-message-barrister-b4afa3.md (8 proposed rules).

Formal review submitted: gh pr review 468 -R endojs/endo-but-for-bots --comment --body-file (self-authored PR; --request-changes blocked; submitted as --comment with full must-fix body).

@copilot reviewer added: gh pr edit 468 -R endojs/endo-but-for-bots --add-reviewer @copilot.

Next stage: fixer dispatch with must-fix-loop items (1 and 2) and summary-fix bundle (1 and 2) as the brief. After fixer push, next round is justice (not barrister). The orchestrator should dispatch justice with the prior verdict inline.

Self-improvement: the Symbol.iterator divergence finding was discovered by runtime experiment during the assessor pass. No role or skill file covers this specific shim installation pitfall. A proposed-rule message was routed to the gardener for encoding. The subarray mutable-buffer finding is a systematic gap in the panel-review skill's per-seat guidance: view-returning delegate methods need a separate rule from scalar-returning ones.
