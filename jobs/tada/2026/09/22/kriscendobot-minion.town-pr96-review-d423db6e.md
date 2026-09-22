This review's work was already completed by a peer designer job; I verified every ask against a named artifact rather than inferring from the preflight hint.

## Completion report — kriscendobot/minion.town PR #96 review 5272974950

**Directive:** kriskowal's CHANGES_REQUESTED review (body: `@kriscendobot rsvp`) on the design PR adding `designs/claude-agent-credential-reauth.md`. Substance is 4 inline comments on that file.

**Preflight:** exit 2 (peer replies present on every thread) — a HINT only. I corroborated each ask against a real artifact before completing as a no-op, per the directive.

**Per-ask corroboration:**

1. **"Start with the simple case… root user can receive link out of band"** (cid 4067403969) — RESOLVED by commit `042c1b2959` (`design(reauth): start with root-user notification (#96)`). Design at HEAD retitled "root-user reauthentication"; new § 1 "Scope: the simple root-user case" explicitly does *not* introduce the delegated operator, per-guest operator binding, `ReauthTicket`, Endo-mail delivery, or external-email projection — all moved to § "Follow-up, deliberately deferred."

2. **"Usage exhaustion… enable automation to react, or escalate to the user"** (cid 4067412358) — RESOLVED by `042c1b2959`. `usage-exhausted` is a first-class admission-time sibling of `needs-auth` in the `infer()` classifier (§ 2, lines 78–86); escalates to the root user via the notifier with `resetAt` for a resettable window and a named billing action for an API-key cap (§ 3, § 6 lines 321–323).

3. **"An advisory would be helpful"** (cid 4067414630) — RESOLVED by commit `ea66e45c5d`. New § 3 "Pre-expiry advisory" (line 196): a single non-blocking renewal nudge via the same root notifier; API-key credentials correctly get none (lines 217–218).

4. **"Fall through to manual reauth… do not block… track dependencies, post a gated job"** (cid 4067419982) — RESOLVED by `ea66e45c5d` + a board artifact. § "Follow-up, deliberately deferred" states the design does not block on the OAuth relay, falls through to manual `setup-token` reauth, and parks losslessly. The gated follow-up exists on the board: `journal/jobs/plan/evaluate-reauth-escalation-default-after-oauth-relay.md` (`gate: deferred`), citing this review's open-question 4 and tracking the browser-OAuth-relay dependency.

**Changes made this run:** none required — the deliverable was already complete and verified. No new commits, no PR edits, no board changes.

**Follow-ups:** none. The deferred escalation-default work is owned by the parked board job above; it promotes only after the browser OAuth relay makes progress.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr96-review-d423db6e.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 11 on 2 host(s) (3 unmetered)
- Input: 154 tokens (3858024 cached reads)
- Output: 61908 tokens
- Cost: $7.6551029999999995 (3 engagement(s) unpriced)
- Wall-clock: 2833s
- Model(s): claude-opus-4-8 ×8

<!-- garden-usage-end -->
