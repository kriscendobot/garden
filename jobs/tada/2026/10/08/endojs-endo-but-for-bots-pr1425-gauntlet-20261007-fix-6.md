PR #1425 fix round 6: I addressed both blocking items and pushed the branch. CI is green, with 15 checks and 0 failures at new head `2fa058354a`. Locally, `yarn test:xs` passes under `xst` and eslint is clean on the changed files.

**Packager (must-fix): unrelated CI commit `74e526ba33` on the branch.**
- The zizmor check fails on the base, so dropping the commit outright would have turned this PR's CI red.
- https://github.com/endojs/endo-but-for-bots/pull/1427 is a separate PR that fixes that check, and it is green.
- I replaced the stray commit with #1427's exact commit (`1b1ead43c8`). This PR is now explicitly stacked on #1427; the PR body says so, and the commit drops out on rebase once #1427 merges.
- I rebased the rest of the branch onto it; the SES commits are unchanged. I pushed with `safe-push-pr-head.sh --mode rewrite`, which forces only if the remote head hasn't moved.

**Packager (should-fix): changeset doesn't mention the new `onIntrinsics` parameter.** No changeset edit needed:
- `src/lockdown.js` is not in the `ses` package exports.
- The public `globalThis.repairIntrinsics` and `lockdown` don't pass the parameter through.
- So the parameter is internal and the `patch` bump stands. I added a JSDoc sentence saying this.

**Purist 1 (should-fix): read `globalThis.Compartment` instead of adding the hook.** I declined this because the alternative breaks.
- That constructor requires `new`, but the XS adapter calls the shim constructor as a plain function.
- I tried the alternative under `xst` and the first `new Compartment()` threw `TypeError: Class constructor Compartment cannot be invoked without 'new'`.
- A comment in `src-xs/lockdown-shim.js` now records why.

**Purist 2 (should-fix): match the rest of the Compartment family.** The lockdown-time shim constructor is now frozen and marked like the others, in a new commit. It still doesn't require `new`, for the reason above.

**Test additions** (purist and corner-prober comment-only items), in `test/_xs.js`:
- A global added before lockdown that isn't one of the standard shared globals stays invisible in new compartments.
- `new Date()` throws in a new compartment.

I updated the PR body's dependency paragraph and posted a reply comment summarizing these changes (issuecomment-6063491860).

Follow-up: this PR should be rebased once #1427 lands, so the CI commit drops out.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1425-gauntlet-20261007-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (1900818 cached reads)
- Output: 13953 tokens
- Cost: $1.2630396
- Wall-clock: 721s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
