# Gauntlet FIX round 7: kriscendobot/minion.town PR #190

I applied the round-7 must-fix and pushed it to the PR head (`0dfbf03` → `fdf2503`). CI for the new head (`test (typecheck + vitest)`) finished green.

**Must-fix (integrator): the saved order depends on the unsettled clip-id model.** Fixed in commit `26b1e81`:
- `designs/clip-shell-framework.md` § 2 now says the saved order is keyed by clip id. The listing's `hash`, the canonical label and `ClipRecord.id` are the same value.
- Open question #4 now names what goes wrong under #88 (fresh id on upgrade): an upgraded clip drops out of the saved order and moves to the end of the gutter. Only the arrangement is lost.
- It also says that if #88 lands, the order store must be re-keyed by a stable clip key in the same change, and that #85 (in-place upgrade) needs no change.
- The PR body has a paragraph saying the same.

**Should-fixes also done:**
- **Order cap:** `saveClipOrder` now sends at most 1000 hashes (`MAX_CLIP_ORDER_LENGTH`), so an owner with more clips can still save (commit `fdf2503`). A new test checks the cap and that the shell's copy of the limit matches the server's.
- **PR body:** it now says the admission change makes account-store failures answer 503 on the existing `/account/guest-formula-id` and `/account/guest-locator` routes too.
- **Comment cleanup:** removed the listing-order paragraph that appeared twice, cut the quota clause from `saveClipOrder`, and deleted JSDoc that only repeated function signatures. `×`/`≈` became ASCII.
- **Summary comment:** posted on the PR (issuecomment-6210769647).

**Checks:**
- The PR's test files passed locally (66 tests) and `tsc --noEmit` was clean.
- Prettier flags formatting in 3 of the 4 touched files, but the repo has no lint script, so I didn't reformat.
- `ci-wait-merge.sh` was stopped when the 10-minute background limit ran out, before it gave an exit code. `gh pr checks` fails with this PAT (it can't read check status), so I confirmed the green result from the Actions runs API for the new head instead.

**Still open:**
- The commits should be regrouped before un-draft.
- `makeFsClipOrderStore.write` doesn't fsync and leaves `.tmp-*` files behind on failure.
- `MalformedClipOrderError` drops the parser's message.
- `OwnerClipOrder.save` doesn't run its own `isClipOrder` check.
- Tests are missing for the `createApp` wiring and for the request body-size limit.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr190-gauntlet-fix-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1279597 cached reads)
- Output: 9466 tokens
- Cost: $0.9019513999999998
- Wall-clock: 1340s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
