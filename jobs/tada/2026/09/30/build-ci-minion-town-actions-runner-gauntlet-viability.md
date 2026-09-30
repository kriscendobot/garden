**Verdict: viability=proceed.** PR #145 (kriscendobot/minion.town, "ci: self-hosted ephemeral runner at ci.minion.town") is still needed and nothing has replaced it, so the gauntlet can start.

**PR state:** open, draft, not merged. Head is `352719f4`, base is the frozen `main-c54f507`. It was opened 2026-09-30T19:54Z and has no reviews or comments yet.

**Deciding question:** Are GitHub-hosted runners still blocked for kriscendobot/minion.town, with no other self-hosted runner or CI workaround already on `main`?

**Evidence:**
- **The billing block is still active.** Hosted runs on `design/clip-lifecycle-capabilities` (runs 36703272099 and 36700922175, around 10:00–10:35Z today) and `design/guest-coupons` (36691445004) failed before starting. The check-run says: "The job was not started because recent account payments have failed or your spending limit needs to be increased." Every hosted run on other branches since then has failed; runs before 08:25Z succeeded.
- **Nothing newer has replaced it.** `main` is still at `c54f5070`, which is this PR's base, so there are no newer base commits (the compare shows 0 ahead). The other open PRs (#131–#144) are feature and design work; none touches runner or CI infrastructure.
- **The PR itself works.** Its own CI passed on the self-hosted `ci-minion-town` runners in runs 36771372793 and 36775061970. The deliberately failing selftest went red as intended in 36775062292.
- **Why this matters now:** the #144 gauntlet stopped with CI red while this billing block is in place. Until this runner lands, or billing is fixed, gauntlet CI stages on this repo can't pass.

**Follow-up:** landing this means production CI depends on a new spot-EC2 host (about $35/month) and a Lambda that holds the GitHub credential. The panel should look closely at the security of that credential boundary.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ci-minion-town-actions-runner-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (229397 cached reads)
- Output: 1725 tokens
- Cost: $0.4522114
- Wall-clock: 49s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
