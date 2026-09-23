---
ts: 2026-05-22T22:23:42Z
kind: result
role: barrister
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
refs:
  - entries/2026/05/22/221700Z-dispatch-general-contractor-5620d6.md
---

Code-panel first round on PR #242 (`feat(ocapn): consume syrups-framed ocapn-test-suite for Python interop`, branch `feat/syrups-ocapn-framing`, base frozen at `origin/llm-b1c3f4d`). Panel kind: code-panel. Panel execution: in-band-fallback (Agent tool not in scope; one block per seat written sequentially per `panel-review` § In-band fallback). Diff scope: 20 files, +1519/-36 against the frozen base.

Panel-hints script output. Always-on core (9): assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober. Always-fire (2): scribe, releaser. Path-triggered (7): changeset-auditor, curator, fast-checker, gateway, migrator, pruner, surfacer. Content-triggered (4): locksmith, purist, spec-keeper, warden. Cross-panel (2): copyeditor, pedant (on `packages/syrups/README.md` +62 lines). Suppressed (4): benchmarker, breaker, engine-realist, wire-watcher. Recommended total: 24 + 2 cross = 26. No barrister-side overrides.

Aggregated verdict. must-fix-loop 6, summary-fix 6, follow-up 6, acknowledge 5, drop 0. The six must-fix-loop items: dead `designs/ocapn-tcp-syrups-framing.md` link in README/reader.js/writer.js; un-disclosed silent-discard at EOF (partial-prefix discard); unsignalled API-surface decision (legacy `netstringReader`-style aliases); missing peer-fix test (concurrent chunked writes); `patch`-on-brand-new-package changeset bump-kind; error-swallowing `.catch(() => {})` in `makeSyrupsWritingSocketOperations`.

Formal review URL: https://github.com/endojs/endo-but-for-bots/pull/242#pullrequestreview-4349099374 (submitted as `--comment` per the self-authored-PR fallback; the body carries the `Must-fix before merge` heading for dispatch-matrix detection).

Six follow-ups appended to `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--242.md` (status: parked). No `summary-fix` job posted yet (the contractor stages the fixer to address must-fix-loop + summary-fix as one bundle next round; justice runs the re-run).

Self-improvement: nothing this time.
