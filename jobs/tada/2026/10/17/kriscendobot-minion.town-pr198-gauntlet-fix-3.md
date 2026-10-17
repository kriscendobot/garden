I applied the round-3 panel's must-fix and most of its should-fixes on PR #198 and pushed them, but CI hasn't run yet. The only CI run for the new head (`6ef80c1`) has been queued since 16:07Z. Every run in the repo is waiting on the self-hosted `ci-minion-town` runner; a `main` run has been queued since 13:48Z. Watching CI hit a second problem at 17:02Z: the bot's GitHub API rate limit ran out. So this stage ends **still-pending**, not green.

**Fixes pushed** (three commits on top of `65b37ee`, pushed with `safe-push-pr-head.sh`; this host's runner can't read `statusCheckRollup`, so I polled the Actions runs API):

1. **`fix(waitlist)` (the must-fix):** waitlist rows no longer store `rate_key`, which was never read and could be reversed. The network is now only the rate limiter's in-memory key, and each row holds just `email`, `created_at` and `expires_at`. Same commit:
   - `rateKeyFor` is removed.
   - `WaitlistEmailError` now sets its `name`, and the router returns 400 only for that error.
   - Addresses containing zero-width or bidi control characters (`\p{Cf}`) are rejected.
   - The IPv6 parser guards against a negative group count, and `WAITLIST_ACCEPTED` is frozen.
   - There is one shared `DEFAULT_WAITLIST_TABLE`, and `WAITLIST_TABLE` is now in `.env.example`.
   - The DynamoDB `list` skips rows that have no address.
   - Rate limiter: I removed the step that purged expired windows, and the test that claimed to cover it. The prover was right that the test didn't pin anything, but the purge has no observable effect anyway (an expired key restarts its window, and at the bound the oldest entry is evicted first), so no test could pin it.
2. **`fix(web)`:** `home.js` now checks a guest link with `GET /api/guest` before storing it, through a new testable helper, `chooseGuest`:
   - A rejected link leaves the stored guest alone.
   - A different stored guest is replaced only after the visitor confirms.
   - A 401 clears storage only if the rejected credential is the stored one.
   - Any fragment with a `guest` key is cleared from the address bar, even one that doesn't parse, and `#recover=1` is cleared even when the request fails.
   - Also fixed the `@returns` annotation, replaced `←` with `&larr;` in `connect.html`, and trimmed the `index.html` header.
   - Six new tests cover these cases.
3. **`docs(waitlist)`:**
   - **IAM:** the app grant now requires `ReturnValues` to be `NONE`, and the docs no longer say the app can't overwrite or probe a known address. I haven't confirmed that this condition also covers `ReturnValuesOnConditionCheckFailure`, and the deploy script's comment says so.
   - **Deploy order:** `DEPLOYMENT.md` now says to run `deploy-caddy.sh` before `deploy-www.sh`, and describes the brief window between them.
   - **Design doc:** fixed the normalization order (trim, lowercase, then NFC), added the reason for per-network rate keys, and replaced garden job names with PR numbers #199, #200 and #202.
   - **Stale references:** Open question #2 in `clip-shell-framework.md` and a line in the onboarding design that still named `guest.js` are updated.

**Checks:** typecheck is clean. The nine affected test files pass (164 tests, 2 skipped). I did not run the full suite locally.

**Decisions for the maintainer:**
- **Merge order with #199:** I wrote down that #198 merges first and that #199 then ports its coupon client into `home.js`. It's in the design doc and the PR body; nobody has confirmed it, and the maintainer can reverse it.
- **Rate limiting:** the design keeps per-network keys and names a single global budget as the simpler alternative. The maintainer should pick one.

**Not done:** some of the comment trimming the panel's pruner asked for (the CLI usage text and some module headers), the Caddy `request_body max_size` suggestion, and NFKC normalization. All were optional.

**Follow-up:** the self-hosted `ci-minion-town` runner seems stalled or saturated across the whole repo. That needs an AWS-capable host (`requires: aws`); this host can't fix it.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr198-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (4635324 cached reads)
- Output: 32171 tokens
- Cost: $2.625108799999999
- Wall-clock: 3602s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
