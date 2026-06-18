---
ts: 2026-06-18T09:31:08Z
kind: result
role: barrister
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/06/18/093108Z-result-barrister-09ffa1.md
---

Barrister result for PR #460 (`feat(preact-container): port secure Preact renderer + compartment as @endo/preact-container`).

PR author: kumavis (external contributor). Trigger: `@kriscendobot review` comment at 2026-06-18T09:21:26Z.

Panel kind: code-panel  
Panel execution: in-band-fallback (Agent tool not available in harness)  
Seats dispatched: 24 of 26 code-panel + 2 cross-panel (copyeditor, pedant)  
Seats suppressed by panel-hints: benchmarker, breaker, changeset-auditor, wire-watcher

Panel-hints output (verbatim):

```
Panel-kind: code-panel
Always-on core (9): assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober
Always-fire (2): scribe, releaser
Path-triggered (6): curator, fast-checker, gateway, migrator, pruner, surfacer
Content-triggered (5): engine-realist, locksmith, purist, spec-keeper, warden
Cross-panel (2): copyeditor, pedant
Suppressed (4): benchmarker, breaker, changeset-auditor, wire-watcher
Recommended total: 24 of 26 code-panel seats (+ 2 cross-panel).
```

No barrister-side overrides.

Formal review submitted: `gh pr review 460 -R endojs/endo-but-for-bots --request-changes`  
reviewDecision after submission: CHANGES_REQUESTED  
@copilot reviewer added.

Disposition counts:

| Disposition | Count |
|---|---|
| must-fix-loop | 4 |
| summary-fix | 3 |
| follow-up | 4 |
| acknowledge | 8 |
| drop | 2 |

Must-fix-loop items (brief):

1. `makeSafeEvent` / `safeTargetSnapshot` use `Object.freeze` instead of `freezeConstant` — SafeEvent closures handed to untrusted code are not transitively hardened.
2. No Node/SES test under `lockdown({ overrideTaming: 'severe' })` — core security guarantee is untested.
3. Exported functions in `renderer.js` and `compartment.js` lack `harden()` / `freezeConstant()` calls — violates CLAUDE.md `harden() is mandatory`.
4. `typedoc.json` includes `packages/preact-container` but `tsconfig.json` excludes it.

Summary-fix items (brief):

1. `Confined` wrapper `sanitizedProps` uses spread destructuring — should use null-proto + own-properties pattern.
2. README references "Known gaps" section that does not exist.
3. `.d.ts` uses bare `Function` type for privileged extension-point parameters.

Follow-up items filed to ledger:
`journal/projects/endo-but-for-bots/followups/endo-but-for-bots--460.md`

Proposed rules (8) queued for gardener in a separate message entry.

Next stage: fixer for must-fix-loop + summary-fix bundle, then justice re-run.
Next: liaison (external PR — user decides next action).

Self-improvement: the in-band panel revealed that `makeSafeEvent`'s use of `Object.freeze` instead of the existing `freezeConstant` pattern in the same file is a recurring pattern gap for packages that use conditional `globalThis.harden` rather than a direct import. This warrants a proposed-rule (filed above). No role or skill file needs updating this dispatch.
