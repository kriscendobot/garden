# Gauntlet FIX round 3, kriscendobot/minion.town PR #198: fixes pushed, CI still pending

All of the round-3 panel's must-fix and should-fix items are now on the PR head. CI has not run yet: the job was still queued when the one-hour deadline ran out.

## What I did
- **Read the round-3 verdict.** It is the review "round 3 verdict: must-fix (part 3/3)" at head `65b37eef`. Seven seats asked for changes: decomplector, purist, breaker, wire-watcher, integrator, typist and pruner.
- **Most of the work was already pushed.** An earlier claimant of this job had pushed three follow-up commits. I checked each one against the verdict:
  - `6edca7b`: `rate_key` is no longer stored on any row (the decomplector's must-fix and the purist's finding). `WaitlistEmailError` now sets its `name`, and the router answers 400 only for that error. The email check now rejects invisible format characters (`\p{Cf}`). There is now one shared default table name, `WAITLIST_TABLE` is in `.env.example`, and the DynamoDB `list` skips rows with no address. The rate-limiter test that didn't actually test its claim was removed.
  - `83f7631`: a guest link is now checked by the server before it is stored. It asks before replacing a different stored credential, and only clears storage on a 401/403 when the rejected credential is the stored one (breaker and wire-watcher). Any fragment containing a guest credential is now removed from the address bar, and the `recover=1` branch clears it on failure too. `connect.html` uses `&larr;` instead of the `←` glyph (typist). The `index.html` header was cut to a pointer (pruner). Tests were added in `home-page.test.ts`.
  - `6ef80c1`: the IAM grant is now PutItem with `ReturnValues` limited to `NONE`, and the docs no longer claim the app can't overwrite or probe a known address (breaker). The design doc's normalization order is fixed. The design now cites #199, #200 and #202 instead of garden job names and states that #199 ports its coupon client into `home.js` (integrator). The stale Open question #2 in `clip-shell-framework.md` and the leftover `guest.js` reference in the onboarding design are updated. The pruner's duplicated instructions were trimmed.
- **What was left, which I fixed** in `c0f92c1`, "docs(waitlist): state the deploy order once, rewrap normalizeEmail's doc":
  - `DEPLOYMENT.md` gave the provision-the-table-first order in two places (pruner #7). The landing paragraph now points to § Closed-beta waitlist and keeps only the Caddy-first step.
  - I rewrapped one over-long line in the `normalizeEmail` JSDoc.
  - The typist's `parseFragment`/`one()` return-type point was already answered: `one` is annotated `@returns {string | null}`.
- **Pushed** with `safe-push-pr-head.sh`, which advanced the head from `6ef80c1` to `c0f92c1` without rewriting history. I made no local test run; this commit only changes docs and a comment.

## CI
The Actions run for `c0f92c1` (`39068612723`) was created at 20:53Z and was still **queued** at 21:53Z, so the final `ci-wait-merge.sh --no-merge` returned **rc 4**.

The self-hosted `ci-minion-town` runner pool appears stalled or saturated:
- About ten runs across branches have been queued since 17:07Z.
- None has started since about 19:46Z.
- No runs in this repo were in progress when I checked.

## Follow-up
- Someone should look at the self-hosted `ci-minion-town` runners. The `minion-town-ci-runner-switch` skill may apply. Every minion.town PR gauntlet is blocked until they pick up jobs.
- Once the panel re-runs, the decomplector's should-fix needs a maintainer decision: keep a rate limit per network, or collapse to one global budget. The design now gives the reasoning for keeping it per network.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr198-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 176 tokens (7539106 cached reads)
- Output: 47390 tokens
- Cost: $4.526061199999999
- Wall-clock: 11653s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
