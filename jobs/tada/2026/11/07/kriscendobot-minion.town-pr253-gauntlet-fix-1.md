Fix round 1 for PR #253 is done with no new commit, and CI is green on head `9c79d18`.

- **Style finding (`ok` in `test/home-page.test.ts`):** the PR head already had commit `9c79d18`, which adds a `spell-out-exempt` marker to that file's first lines. The probe's `is_exempt` check skips files carrying that marker, so the prepass failure was against an earlier head.
- **Comment-concision advisory (`deploy/aws/www/home.js`):** I left the comment alone. It explains why `WAITLIST_JOINED_KEY` stores only `'1'` and never the address, which the adjacent code doesn't say.
- **CI:** the `changes`, `test`, and `gate` (chromium, firefox, webkit) jobs all pass. `Claude harness` was skipped.
- **Not run:** I didn't re-run `ci-wait-merge.sh` to a final return code. It hit the background time limit, so I polled `gh pr checks` directly until nothing was pending.
- **Checkout:** `ensure-project-worktree.sh` failed with a read-only filesystem error on the shared bare repo (the known monk-sandbox issue). I read the PR head from a clone in `$TMPDIR` instead.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr253-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 66 tokens (1979285 cached reads)
- Output: 8610 tokens
- Cost: $1.1337691000000003
- Wall-clock: 6004s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
