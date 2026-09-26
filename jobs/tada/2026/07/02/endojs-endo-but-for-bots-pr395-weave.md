The weave is complete and verified on the remote. Writing the completion report.

## Completion report: weave (rebase) endojs/endo-but-for-bots PR #395

**Problem:** PR #395 (phase 7, formula-backed AppsNameHub) was `mergeable_state: dirty` — its head branch `design/gateway-package-phase-7` (515f7cf, last pushed 2026-06-03) still carried the *old-SHA* phase-6 commits below its two phase-7-unique commits, while its base `design/gateway-package-phase-6` had since been rebased forward onto newer master (getting new SHAs plus two new docs commits at the tip). GitHub therefore created no merge ref and no `pull_request` workflow could dispatch, blocking any shepherd.

**What I did:**
- Isolated project checkout via `ensure-project-worktree.sh`; fetched both stacked branches.
- Determined P7's only unique work above the shared phase-6 content was exactly two commits: `24c405889` (feat AppsNameHub) and `515f7cfbd` (Uint8Array + types.d.ts on apps-formula). Everything below (`119d21f45` and down) was phase-6 work that the current P6 head already carries at rebased SHAs.
- `git rebase --onto origin/design/gateway-package-phase-6 119d21f45` — replayed the two phase-7 commits onto the current P6 head `fb8ec34`. **No conflicts arose** (the divergence was purely the stale-base duplication, not overlapping edits). Scanned the resulting files for conflict markers — clean.
- Verified the net diff atop P6 is purely the phase-7 apps-formula work (7 files: `src/apps-formula.js`, `test/apps-formula.test.js`, `src/types.d.ts`, `index.js`, `README.md`, `gateway.test.js`, changeset — +1247/−29).
- Force-pushed with `--force-with-lease=design/gateway-package-phase-7:515f7cfbd` — lease held (`515f7cfbd...6cbc91bd1`, forced update).

**What changed:** `design/gateway-package-phase-7` head `515f7cf → 6cbc91bd1`, now sitting cleanly on the current phase-6 head `fb8ec34`.

**Result:** PR #395 flipped from `DIRTY`/`mergeable:false` to **`MERGEABLE`** / `mergeStateStatus: UNSTABLE` — the conflict is cleared and CI can now dispatch. Remained an OPEN draft as before.

**Follow-ups:**
- CI will now dispatch on the new head. The leader-only `garden-ci-watcher@*` auto-posts a shepherd job if the run goes red, so I deliberately did **not** hand-post a premature shepherd (it would have no CI results to act on yet).
- #395's base #394 (phase-6) is itself in-flight (`unstable`, peer shepherd `endojs-endo-but-for-bots-pr394-shepherd` running); if #394's head advances further, #395 may need another light rebase, but it is conflict-free against the current phase-6 head as of this push.
