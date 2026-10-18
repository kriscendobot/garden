The round-3 must-fix items were already on PR #198 when I claimed this job, and CI is green on the current head `c0f92c1`. I pushed nothing new.

**What was already there.** A previous claimant of this job pushed four commits after the panel reviewed `65b37eef`:
- `6edca7b` fix(waitlist)
- `83f7631` fix(web)
- `6ef80c1` docs(waitlist)
- `c0f92c1` docs(waitlist)

**What I checked.** I read the round-3 verdict (part 3/3), then compared the head against the items from the seven seats that asked for changes. Each one is handled:
- **decomplector / purist:** the network key is no longer stored. It is gone from `WaitlistEntry`, the DynamoDB item and the tests, and lives only in the rate limiter's memory. `WaitlistEmailError` now sets its `name`, and the router's catch only handles that error class.
- **breaker / wire-watcher:**
  - `home.js` checks a guest link with the server before storing it, and asks the visitor before replacing a different stored credential.
  - A rejected link clears storage only if it matches what was stored.
  - Credential fragments are removed from the address bar even when they don't parse.
  - The IAM grant now requires `ReturnValues` to be `NONE`, and the docs no longer call the store "add-only". They now say what PutItem still allows.
  - The email check also refuses invisible format characters (`\p{Cf}`).
- **integrator:** the design now says this PR merges before #199 and that #199 ports the coupon client into `home.js`. It refers to #199, #200 and #202 instead of garden job names. Open question #2 in `clip-shell-framework.md` is updated, and the leftover `guest.js` mention in `invitation-only-guest-onboarding.md` is fixed.
- **typist:** `one()` is annotated `@returns {string | null}`, and `connect.html:173` uses `&larr;` instead of the `←` character.
- **pruner:** the repeated instructions and comments that restated the code are trimmed across the code and docs, including `DEPLOYMENT.md`.

**CI:** `ci-wait-merge.sh … --no-merge` returned rc 0, with 1 of 1 runs green. The bot token can't read the PR's check rollup, so the script used the Actions runs API instead. That means commit statuses and checks from outside Actions weren't visible to it.

**Left for the maintainer** (should-fix, not must-fix):
- The decomplector wants a decision on whether the rate limiter needs a separate budget per network or could use one global budget.
- Adding a Caddy `request_body { max_size }` limit on `/api/waitlist` was suggested but not done.

The gauntlet driver posts panel round 4 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr198-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s)
- Input: 198 tokens (8108863 cached reads)
- Output: 50374 tokens
- Cost: $5.161252599999999
- Wall-clock: 11749s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
