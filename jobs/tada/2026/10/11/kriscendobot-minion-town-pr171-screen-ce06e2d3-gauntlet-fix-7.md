**Fix round 7 for kriscendobot/minion.town PR #171: all must-fix items are applied and CI is green.**

Round 7 requested changes from two reviewers (the integrator and pruner panel seats). I addressed both.

**Integrator must-fixes:**
- **Commit message:** I reworded the commit to `feat(probe): validate the pinned Claude harness in production`, which matches the PR title. The restack paragraph and the overbroad subject are gone. The new SHA is `8844fa1`.
- **PR description:** The Status section and ledger Phase 4 now say "#166 merged; this PR sits on `main-4bd13c8`; merge waits on phases 1 and 3". I removed the weave history and the old SHAs.
- **Should-fix, also done:** `DEPLOYMENT.md` provisioning step 1 now asks you to check the existing `prod-probe` environment instead of creating it.

**Pruner findings, in follow-up commit `b65b1f4`** (`docs(probe): state the probe trust model once, in DEPLOYMENT.md`):
- The trust explanation was repeated in four places. The header in `deploy-cd-iam.mjs`, the comment in `cd-iam-documents.mjs` and the note in `prod-probe.yml` now point to `DEPLOYMENT.md` § AWS/SSM instead.
- I removed the two comments duplicated in `deploy-cd-iam.mjs`, the comments that only restated the code, and the new `// ── N. … ───` banners.
- I trimmed the over-long file headers in `claude-harness-observe.cjs`, `claude-harness.mjs` and `claude-harness-layout.cjs`.
- In `DEPLOYMENT.md`, the "Why the probe pulls through SSM" paragraph is now one short paragraph, and the repeated "no live run yet" note is gone.
- In the PR body, I cut the "Review rounds 3-6" sentence, the "Why a runtime SSM read" paragraph and the "successor is" paragraph. The body went from 502 to 354 words.

**Verification:**
- `node --check` passes on every changed JavaScript file.
- Both offline suites pass, 37 tests in all: `node --test deploy/aws/scripts/cd-iam-documents.test.mjs deploy/probe/prod-objectives.test.mjs`.
- I pushed with `safe-push-pr-head.sh --mode rewrite`, which force-pushed because the reword changed the existing commit. The head moved from `6dd0819` to `b65b1f4`.
- `ci-wait-merge.sh` returned rc 0: 3 checks ran (Claude harness amd64 and arm64, test) and none failed.

**Not addressed:** two should-fix items from comment-only reviewers. One is deleting old versions of the SSM document so they can't still be run. The other is that the probe's harness check can race a deploy and its retry does nothing. Both are left for the next panel or the arc supervisor.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr171-screen-ce06e2d3-gauntlet-fix-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1337434 cached reads)
- Output: 10016 tokens
- Cost: $1.0238708
- Wall-clock: 891s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
