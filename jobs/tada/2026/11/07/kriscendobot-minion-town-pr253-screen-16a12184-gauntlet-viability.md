**PR #253 viability: proceed.** The PR is open, not superseded, and the reason it was opened still holds, so the gauntlet may begin. I spent no clean, panel, fix, CI-wait or un-draft budget.

**Deciding question:** Does `main` still lack a post-sign-up thank-you page at `/soon`, with no other PR that adds one or replaces the in-form note?
Yes.

**Evidence:**
- **PR state:** open and not merged, already marked ready (not a draft), GitHub reports it `MERGEABLE`, and its head is `16a12184`.
- **`main` has no `/soon`:**
  - `main` is at `5e890519`. None of its last 30 commits (since 2026-11-03) touch the waitlist or `/soon`; they are agents, providers and design work.
  - `deploy/aws/caddy/conf.d/minion-town.caddy` on `main` has no `soon` route.
  - `designs/closed-beta-waitlist.md` on `main` has no "After joining" or `/soon` section; this PR adds it.
- **No competing PR:**
  - #198, the waitlist splash that this PR builds on, is merged.
  - The other open web PRs are guest recovery and capability URLs; none implements `/soon`.
  - #254 ("fix(web): explain failed guest recovery") is probably the sibling job the PR says also edits `home.js`. I didn't open it to confirm; if it is, a merge conflict is possible there, but it doesn't displace this change.
- **Earlier gauntlet runs:**
  - The first gauntlet halted when its viability stage failed three times for transient reasons, not on the merits.
  - The previous screening gauntlet (`…screen-1e9fc729`) reached its review budget after one round with CI green; its must-fix list was "unknown" (unavailable).
- **Still open after merge:** production deploy and verification haven't been done, because the build host had no AWS credentials. That is follow-up work after merge, not a sign the PR was overtaken.

Nothing changed in the garden repo; this stage only reads.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr253-screen-16a12184-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (253890 cached reads)
- Output: 1729 tokens
- Cost: $0.483998
- Wall-clock: 42s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
