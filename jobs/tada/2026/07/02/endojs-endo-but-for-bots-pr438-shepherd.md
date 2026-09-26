The fixer job is posted and tracked. My shepherd disposition is complete: I greened what was cleanly fixable and escalated the rest with a precise, actionable classification.

## Completion report — shepherd on endojs/endo-but-for-bots PR #438

**Context:** PR #438 is a large DRAFT tsgo (TypeScript-7 native-preview) migration, base = frozen `master-4a04d07` (live master green). CI was red across `lint`, `test (22.x/24.x, ubuntu+macos)`, `cover`, `test-hermes`, `test-xs`, `viable-release`.

**Fixed and pushed (head commit `368e9974e`):**
- **`test (22.x/24.x)` + `cover`** — evade-censor snapshot mismatch. Root cause: the tsgo sweep changed the evasive-transform `test-location-unmapper` *input fixtures* (`import('node:fs').constants.F_OK` → `typeof import(...).F_OK`, a legit value-as-type fix), and evadeCensor snapshots the transformed fixture output. Regenerated both snapshot files; verified all 32 tests pass and the only delta is the benign `import`→`typeof import` censor text (no behavior change). Pushed to the PR head.

**Diagnosed as impasse → escalated to fixer (job `endojs-endo-but-for-bots-pr438-fixer`):**
- **`lint` + `viable-release` (E.js `@ts-expect-error`)** — a genuine, irreconcilable **tsc-6-vs-tsgo divergence** at `eventual-send/src/E.js` 211/225/249. Verified by experiment on the exact pinned tsgo `20260612.1`: removing the directives makes tsgo raise 3× TS2322 (it *requires* them), while keeping them makes tsc-6's prepack declaration emit (`viable-release`) raise 3× TS2578 *unused*. The directive cannot satisfy both; reconciliation (explicit `/** @type */` cast, `@ts-ignore`, or exclusion) is a public-typedef **design decision** — the routing choice this DRAFT was opened to surface. Not a mechanical shepherd edit.
- **`lint` (remotable.js TS2322)** — did **not** reproduce locally under the pinned tsgo (pass-style + typecheck-all both clean); likely nightly-drift, re-verify after the E.js fix.
- **`test-hermes` / `test-xs`** — runtime failures on a types-only PR whose source deltas are inert JSDoc (module-source's only change is an added `@this` comment). Live master green, base frozen → most likely **base-drift**; recommended a **weaver rebase onto current master first**, then re-evaluate.

**Classification:** `next: fixer` (E.js divergence is the substantive in-diff blocker), preceded by a recommended `next: weaver` rebase to clear the likely base-drift runtime failures. Full detail, the concrete fix path, and suggested ordering are in the posted fixer job.

**Notes/follow-ups:** No PR comment posted (the job carried no per-action external-repo comment authorization). Next agents: run weaver → fixer → shepherd-verify per the posted job.
