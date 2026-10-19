**Undraft stage for kriscendobot/minion.town PR #198** ("feat(web): one landing at /, closed-beta splash and waitlist"): PR #198 is out of draft and marked ready for review, on the exact head the panel passed.

**What I did**
1. **Advisory appellate pass:** ran `claude -p` (sonnet) over the PR diff. The diff is 3,274 lines and the review only saw the first 60 KB of it, so the waitlist endpoint's server code was cut off. This pass is advisory only and did not block the un-draft. Points the panel may have missed:
   - **Rate limiting:** check how the per-network rate-limit key is derived behind Caddy. If the trusted-proxy setting is wrong, every visitor shares `127.0.0.1`, so one abuser locks everyone out; if `X-Forwarded-For` is trusted blindly, the limit can be bypassed. An in-memory limiter also resets on every restart.
   - **Unverified sign-ups:** anyone can add someone else's email. An unconditional DynamoDB `PutItem` can also reset an existing row's `expires_at`, so the app should use `attribute_not_exists`.
   - **CSV formula injection:** `waitlist list --csv` writes attacker-controlled strings that can run as formulas when an admin opens the file in Excel.
   - **Honeypot field:** it is named `website`, so browser or password-manager autofill could silently drop real sign-ups while the page still says "You are on the list."
   - **Cross-site POST:** the endpoint should accept only `application/json`.
   - **Redirect to OAuth:** gated `/account/*` calls from the now-public shell may 302 to the OAuth host, which `connect-src 'self'` blocks.
   - **Hard-to-undo redirects:** browsers cache `308` redirects for `/index.html` with no expiry, which makes a rollback hard.
   - **CSP hash:** the hash breaks on any whitespace or CRLF change to the inline script.
   - **IAM scope:** the inline waitlist policy sits on the shared `garden-ec2-ssm` role, so every fleet instance can write to the table.
   - **Signed-in users:** someone signed in through OAuth but without a guest credential in the browser now lands on the splash page.
2. **Gate:** fresh metadata showed state OPEN, head `5ea626915dd62e50e5e79f36f76b26e9dc460dab` (the passing panel's head) and isDraft true.
3. **Un-draft:** ran `gh pr ready`.
4. **Re-verify:** isDraft is false and the head still equals `5ea626915dd62e50e5e79f36f76b26e9dc460dab`.

**Changes:** no garden commits; the only change is the PR's draft status.

**Follow-ups (optional):** the rate-limit key behind Caddy, the conditional put and the CSV export escaping are worth a look in a fix job or human review. The rate limiter wasn't in the reviewed excerpt, so that one still needs checking.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr198-gauntlet-20261019-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (175111 cached reads)
- Output: 2120 tokens
- Cost: $0.42807819999999996
- Wall-clock: 73s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
