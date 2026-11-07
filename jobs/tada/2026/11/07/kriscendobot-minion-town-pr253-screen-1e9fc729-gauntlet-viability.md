**Viability report: kriscendobot/minion.town PR #253** ("feat(web): advance a waitlist sign-up to a thank-you page at /soon")

The PR is still needed and nothing has replaced it, so the gauntlet may begin. I spent no clean, panel, fix, CI-wait or un-draft budget.

**Deciding question:** Does `main` still lack a post-sign-up page at `/soon`, so that the waitlist still only shows a note under the form, with no other PR or commit having delivered one?

**Answer:** Yes.

**Evidence:**
- **PR state:** open, not merged, not a draft, mergeable. Head is `1e9fc729`, base is `main` at `5e890519`.
- **`main` has no such page:** in `deploy/aws/www/home.js` on `main`, a successful `submitWaitlist` still writes its result to `waitlist-status` under the form. There is no `soon` route or card.
- **Nothing newer touched this code:**
  - The last commit to `deploy/aws/www` on `main` was `7a0bcc90` (2026-11-05). That predates this PR's commits (2026-11-07) and the PR is built on it.
  - The only newer commits on `main` are design docs for agent directory authorization (#250), which don't touch the waitlist.
- **No competing PR:** a search for waitlist/soon PRs finds only #198. It merged earlier and is the landing page this PR builds on.
  - #252 and #254 are open fixes to the same `home.js`, but they cover guest recovery, not the waitlist.
  - #254 is probably the sibling recovery-outcome job the PR body mentions. It may conflict textually, but it doesn't replace this PR.
- **The motivating premise holds:** the closed-beta waitlist is still the landing flow on `main` (per `designs/closed-beta-waitlist.md`).
- **Reviews:** one assessor review, comment-only. Its only finding is that `#soon-status` is unused markup; it found nothing that must be fixed.
- **Earlier gauntlet:** the halted gauntlet comment on the PR (`kriscendobot-minion.town-pr253-gauntlet`) failed on transient reaper requeue exhaustion, not on the merits.

**Still to do:** the production deploy and check listed in the PR body (`deploy-caddy.sh`, then `deploy-www.sh`, then a `curl` and browser check) still need to happen after merge.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr253-screen-1e9fc729-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (191891 cached reads)
- Output: 1669 tokens
- Cost: $0.4691982
- Wall-clock: 34s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
