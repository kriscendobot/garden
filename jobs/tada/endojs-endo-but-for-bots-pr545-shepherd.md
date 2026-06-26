CI is green and the work is complete. Worktree torn down.

## Completion report

**Job:** shepherd directive on endojs/endo-but-for-bots PR #545 (`feat(stream): add flatMapReader`). Drive CI to green.

**Diagnosis.** Six checks were red (`cover`, `lint`, and all four `test` matrix legs); `mergeStateStatus` was `UNSTABLE`. Two independent root causes, both in `packages/stream/test/flat-map.test.js`:

1. **Test failures (`test` ×4, `cover`)** — `ReferenceError: harden is not defined` in the two `makeRecordingReader` tests. The package runs three ava configs; only `lockdown` and `unsafe` call `lockdown()` (via the `ses-ava:endo` condition → `prepare-endo.js`). The `endo` config (`ava-endo-shims-only.config.mjs`) requires `ses` + the eventual-send shim but never calls `lockdown()`, so the ambient `harden` global the test relied on was absent there. This is the documented SES-init gotcha (shepherd field note 2026-06-18), surfacing here through the shared shims-only config rather than an in-file two-line pattern.
2. **Lint failure (`lint`)** — pre-existing prettier complaint: a non-uniform nested array literal `[[10, 20], [30]]` tripped prettier's matrix heuristic.

**Fix (two atomic commits, pushed to `stream-flat-map-reader`, head now `44dc6b5`):**
- `fix(stream): import harden in flat-map test` — `import harden from '@endo/harden'` (the repo-standard pattern used by exo/far/marshal; `@endo/stream` already depends on it). Deliberately **not** `@endo/init/debug.js`, which would double-`lockdown()` and throw under the `lockdown`/`unsafe` configs.
- `chore(stream): reformat flat-map test per prettier`.

**Verification.** Installed the workspace and ran `flat-map.test.js` under all three ava configs (`lockdown`, `unsafe`, `endo`) — 7/7 pass each. eslint + prettier clean locally. After push, the full CI rollup went green (run 28226044942); `mergeStateStatus` is now `CLEAN`. No safety guardrails touched (no skips, no disables, no scope creep). Posted the required green-run summary comment (issuecomment-4807768810) under the repo's standing authorization.

**Outcome:** `next: none` — CI green, no escalation. PR #545 is unblocked for review/merge.

**Follow-up.** The shepherd field note (2026-06-18) prescribes `import '@endo/init/debug.js'` for `harden is not defined`, but that fix double-locks-down and throws when a package runs the sibling `lockdown`/`unsafe` ava configs alongside `endo`/shims-only. The correct fix in that multi-config case is `import harden from '@endo/harden'`. Worth refining the note. (Routing this to the liaison since role-file edits are theirs to land.)

**Self-improvement:** Refine `roles/shepherd/AGENT.md` field note 2026-06-18 — distinguish the in-file two-line SES pattern (fix with `@endo/init/debug.js`) from a missing `harden` under a multi-config package's shims-only ava config (fix with `import harden from '@endo/harden'`, since `@endo/init` would double-lockdown under the package's `lockdown`/`unsafe` configs).
