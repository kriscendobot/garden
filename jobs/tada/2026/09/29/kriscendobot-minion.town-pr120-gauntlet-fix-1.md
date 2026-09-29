Fix round 1 for kriscendobot/minion.town#120 is complete, and CI is green on the current head `fd52dca`.

**What happened:** An earlier claimant of this job had already written and pushed the fixes before this run started. It is commit `fd52dca`, "fix(claude): close create races, recurse lost-record teardown, make handles passable". I didn't repeat that work. I checked the commit against the panel-1 review's seven must-fix items, confirmed it passes locally, and waited for CI.

**Must-fix items and how `fd52dca` handles each:**
1. **Ledger:** The PR body now has the structured Phase and evidence ledger. It covers phases 1–6 and the acceptance-evidence bar, with disposition `non-deliverable-probe`, and the PR stays draft.
2. **`create`/`dismiss` race:** After provisioning, `create` checks that its reservation is still held (new `QuotaLedger.holdsChild`) and that the key is not being torn down. If either check fails, it removes the child and resolves `unavailable`.
3. **Provisioning-fault rollback:** The directory child is removed before the slot is released. If the removal itself fails, the slot stays held. `teardownChild` now releases the quota key last.
4. **Lost-record teardown:** A new `teardownUnrecordedChild` recurses through the child's descendants. Both `teardownNamespace` and `dismiss` use it, so grandchildren are no longer left behind after a restart.
5. **`Far`/`harden`:** Facets, agents and account handles are marked `Far`, with `Far` passed in from `http.ts`, following `site-registry-exo.ts`. Every result is hardened.
6. **Name validation:** A child name must be a single `[A-Za-z0-9._-]{1,128}` segment and cannot be `.` or `..`, so `::`, `/` and `#` can no longer make keys collide.
7. **Style:** `ctx`, `rec` and `d` are spelled out in full.

The commit also covers the should-fix items: `Caller.scope` renamed to `delegationId`, ASCII arrows and ellipses, the in-flight `infer` window during revoke documented, and tests for `maxChildren` 0/-0. New tests cover the race, the rollback, the recursive dismiss, name validation and the `Far`/`harden` tags. The panel had already marked the archivist's "`quotaFor` undefined" item as wrong, so nothing was done for it.

**Checks:**
- **Local:** `npm run typecheck` is clean. The three affected test files (`claude-wiring`, `claude-delegation`, `claude-inbox-watch`) pass, 40/40.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0. All three checks passed on `fd52dca`: test, Claude harness (amd64) and Claude harness (arm64).

**Next step:** Panel-2, which the driver posts; I didn't re-run the panel.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr120-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 94 tokens (4802647 cached reads)
- Output: 34604 tokens
- Cost: $3.1571294000000005
- Wall-clock: 602s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
