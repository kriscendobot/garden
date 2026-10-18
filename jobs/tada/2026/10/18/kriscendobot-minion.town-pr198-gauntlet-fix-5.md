Fix round 5 for kriscendobot/minion.town PR #198 is pushed and CI is green. A previous worker on this job did the actual fixes before it was requeued; I only confirmed what it pushed and waited for CI.

**What the previous worker pushed.** It added three follow-up commits at 07:38Z (`3e809eee`, `5fbc27b0`, `ab339862`; PR head is now `ab33986`) and posted a summary comment on the PR. Against the panel-5 review (5561428462), they cover:
- **Invitation acceptance** (assessor, breaker, purist, engine-realist, saboteur and other seats): every step that can fail now runs before the invitation is marked accepted. A failure returns the invitation to pending but keeps the guest and connection, so a retry reuses them and one invitation creates at most one guest. A regression test covers two `connectLocal` failures, then an `inspect` failure, then success, and checks there is one creation and one connection.
- **typist:** `submitWaitlist` now returns only string fields, and `CreatedGuestWebState` documents both responses that create a guest.
- **prover:** the choice between the DynamoDB and in-memory waitlist writer moved into `buildWaitlistWriter`, and the DynamoDB path is now tested.
- **integrator:** `designs/invitation-only-guest-onboarding.md` now matches the single landing page at `/`.
- **Smaller items:**
  - Any non-blank honeypot value now counts as a bot.
  - Every IPv4-mapped address spelling gets the same rate-limit key, with a property test.
  - The CLI no longer hardcodes the `us-west-1` region.
  - The writer captures `add` when it is built, and the memory store is frozen.
  - The demo mounts the waitlist router before `express.json()`.

**Not done, with reasons in the PR comment:**
- **decomplector** asked to remove the waitlist. This was declined because the waitlist is the scope the maintainer asked for; whether to keep it is their call.
- **releaser** asked for a changeset. The repo has no changeset tooling, and the deploy step is in the PR body's deploy notes.

The next panel or the maintainer may raise either of these again.

**CI:** `ci-wait-merge.sh kriscendobot/minion.town 198 --no-merge` returned rc 0 for `ab33986`, with 1 of 1 runs passing and none failed. The bot token can't read the PR's check summary, so the script used the Actions runs API, which doesn't show commit statuses or non-Actions checks.

The PR is still a draft. The driver posts panel-6 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr198-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 112 tokens (4726720 cached reads)
- Output: 27605 tokens
- Cost: $2.7323400000000007
- Wall-clock: 4411s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
