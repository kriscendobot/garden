## Gauntlet fix round 2: kriscendobot/minion.town#120

I applied the four code must-fix items from the round-2 panel and pushed them. CI is **green** on head `b0ae3f4`. The fifth item, the phase/evidence gate, can't be cleared by code, so the PR stays **draft**.

**Must-fix items**
1. **Phase/evidence gate:** left open. The PR stays draft until design steps 1 and 3–6 land against a live deploy.
2. **`delegate()` label-key aliasing** (`118d64f`): a label containing `::` could make one root session receive another session's live sub-factory. The key is now built as `JSON.stringify([rootFormulaId, label])`, which can't collide that way. The "already exists" path also checks that the existing grant belongs to the same root.
3. **Concurrent `dismiss`/`revoke`** (`118d64f`): two identical calls at the same time both tore the child down, calling `removeChild` twice and returning `unavailable` to the second caller. Each call now claims its target before its first `await`, so a duplicate returns the documented `not-found`. A revoke also skips any child that a `dismiss` is already tearing down. The four new race/alias tests fail against the previous `agents.ts` and pass now.
4. **Abbreviated names** (`d0d99cd`): `t` is now `timestamp` and `n` is now `count`.
5. **Argument guards on handles** (`8417dd3`, `b0ae3f4`):
   - I added the `@endo/exo` and `@endo/patterns` dependencies (lockfile change is just those two entries).
   - Production now builds all five handles through a new `guardedFar` in `src/endo/claude/guards.ts`, which rejects malformed arguments before the method body runs. A handle type with no guard defined throws instead of going out unguarded.
   - The never-reject contract comment in `types.ts` now says it covers well-formed calls only; malformed ones reject at the boundary.
   - A new test, `test/claude-guards.test.ts`, runs under real `@endo/init` lockdown. That also covers the should-fix about no test exercising lockdown. I added a separate test that a 128-character child name is accepted.

**Verification:** locally, typecheck and build pass and the full suite passes (512 tests, 7 skipped). On CI, the "live-daemon B1" step failed twice on its "B2 … self-healing" restart test before a third run passed. That failure isn't from this change: I reproduced it locally at the **previous** head `fd52dca` (1 of 8 runs) against the pinned Endo daemon. I noted this on the PR and added the fast-failing variant to the existing flake memory note.

**Follow-ups**
- Should-fix items I didn't address:
  - Rename `callerFormulaId`, and mark the synthetic `#delegation/` namespace id so it can't be mistaken for a real formula id.
  - Reorder the sub-cap and pool checks in `quota.ts`, or correct its comment.
  - Note the `create` and `accountStatusFor` contract changes in the PR body.
- The first commit (`d0d99cd`) is missing the Co-Authored-By line.
- The panel-3 re-run is for the driver to post.
- I posted a summary comment on the PR: https://github.com/kriscendobot/minion.town/pull/120#issuecomment-5881941846

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr120-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 100 tokens (5443458 cached reads)
- Output: 33995 tokens
- Cost: $2.904895600000001
- Wall-clock: 1049s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
