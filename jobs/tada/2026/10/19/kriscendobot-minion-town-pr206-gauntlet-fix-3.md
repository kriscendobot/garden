# Gauntlet fix round 3: kriscendobot/minion.town PR #206

I applied the panel-3 fixes, pushed them to the PR head, and CI is green on the new head `139ed3a` (`ci-wait-merge` rc=0).

**Source of findings.** The job had no pre-pass block, so I worked from the latest panel verdict, the comment review "Must-fix before merge" (review 5565912332). The only must-fix was from the integrator: the PR description no longer described the code. The pruner also requested changes, as summary-fixes. I also took the should-fix items from the other seats.

**Commits pushed** to `heal-cfafabe-deploy` with `safe-push-pr-head.sh --mode advance`, moving the head from 8a188d6 to 139ed3a:
- **`12716ea` fix(deploy):**
  - `deploy-www.sh` now checks each assembled file against a SHA-256 digest computed before sending, before it renames the file into the live site. A chunk that is replayed or lost now fails the deploy instead of going live (wire-watcher).
  - I cut the script comments that described the retired scheme and the planned follow-on, and replaced them with a pointer to `DEPLOYMENT.md` (pruner).
  - I added a comment explaining why the cleanup pass deletes dotfiles (stylist).
  - `DEPLOYMENT.md` now mentions the digest check.
- **`139ed3a` test(deploy):**
  - The overlapping-deploy test now checks that the two runs use different staging directories, so it no longer depends on timing (prover).
  - A new test replays a middle chunk and expects the deploy to fail and the live file to stay unchanged. With the digest check removed, this test fails, as it should.
  - The payload-size check now copies how `ssm_invoke` really encodes commands (assessor).
  - The repo root is found with URL path math (purist).
  - The suite skips when the GNU `base64 -w0` and `sha256sum` tools are missing (assessor, transplanter).
  - Single-letter names are spelled out (stylist).

**PR page:**
- I rewrote the title and description to match the current code. The Verification section now lists the staging test. I kept the heal and garden-job markers.
- I posted a summary comment naming the new head, what changed, what I declined, and how it was verified (scribe): https://github.com/kriscendobot/minion.town/pull/206#issuecomment-6258095221

**Checks run locally:** `bash -n` and shellcheck pass (only the old SC1091 notice), `npm run typecheck` passes, and vitest passes 108 tests across `deploy-www-staging`, `shell-clip` and `deploy-render-reconcile`.

**Not done:**
- The integrator and packager asked for the commits to be regrouped into two. This stage only adds follow-up commits, so I left that for a squash merge or a retcon.
- The cleanup pattern still skips dotfiles starting with `..` (comment-only; the filename check already blocks new ones).
- No one owns the follow-on single-switch deploy yet; the PR body names it as unowned.

**Next:** the driver re-posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr206-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1422576 cached reads)
- Output: 12013 tokens
- Cost: $1.0986792
- Wall-clock: 998s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
