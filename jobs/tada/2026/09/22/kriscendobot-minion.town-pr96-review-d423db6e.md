All work complete. Summary report follows.

---

## Completion report: PR #96 review (kriscendobot/minion.town, review 5272974950 by kriskowal)

**Directive:** a CHANGES_REQUESTED review with body "@kriscendobot rsvp" and four inline comments — each a maintainer decision on one entry of the design's `## Open questions` section in `designs/claude-agent-credential-reauth.md`.

**Prior state I found:** a prior claimant of this job had already made commit `042c1b2` (today, after the review), rewriting the design 865→330 lines from "operator-mediated reauth w/ ReauthTicket + mailboxes" to "simple root-user notification," and had posted a single reply to comment 4 only. That commit already resolved **Q1** (simple root-user case, operator/ticket/mailbox deferred) and **Q2** (`usage-exhausted` made a first-class `infer()` sentinel). I verified each against the maintainer's text rather than assuming.

**What I did to finish the remaining asks (commit `ea66e45`, pushed to the PR head):**
- **Q3 ("An advisory would be helpful")** — added a "Pre-expiry advisory" subsection to § 3: a non-blocking renewal nudge via the same root notifier when a subscription credential carries a known expiry, with no reauth event, at-most-once-per-window, best-effort with the post-expiry escalation as backstop; API keys excluded (no scheduled expiry).
- **Q4 ("fall through to manual, don't block, but track the deps and post a gated job")** — stated the non-blocking manual-`setup-token` fallthrough explicitly in § "Follow-up," and **posted the gated follow-up board job** `evaluate-reauth-escalation-default-after-oauth-relay` (parked in `journal/jobs/plan/`, `--deferred`, `--by designer`), naming the browser-OAuth-relay dependency set to track and the evaluation to perform once it lands.

**Loop-closing on the PR:**
- Posted inline replies to all four comments (`4067831958`, `4067832093`, `4067832183`, `4067832261`), each naming the resolving artifact.
- Posted a top-level RSVP summary comment ([issuecomment-5770081162](https://github.com/kriscendobot/minion.town/pull/96#issuecomment-5770081162)).

Committed only the design pathspec (excluded warm-cache `package-lock.json` churn). Design remains a draft spec, no live change.

**Follow-ups:** the parked job `evaluate-reauth-escalation-default-after-oauth-relay` owns the deferred browser-OAuth-relay evaluation; promote it only once the relay makes progress.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr96-review-d423db6e.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 56 tokens (1709270 cached reads)
- Output: 21725 tokens
- Cost: $2.078472 (1 engagement(s) unpriced)
- Wall-clock: 1731s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
