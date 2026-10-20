## Gauntlet UNDRAFT: kriscendobot/minion.town PR #198 (no-op)

PR #198 was already out of draft at the head the panel passed, so I didn't run `gh pr ready`.

**Metadata gate:** `gh pr view` returned `state=OPEN`, `isDraft=false` and `headRefOid=f4c29e6c52032d099a8949b16d5f2f4a254d343a`, which matches the panel's head exactly. A second fetch just before writing this report gave the same result.

**Advisory appellate pass:** I skimmed the server diff myself instead of running a separate `claude -p` review. I read `src/waitlist/waitlist.ts`, the changes to `src/http.ts`, and the changes to `src/web/guest-web-router.ts`. Nothing blocks the un-draft. Two notes for the maintainer:
- **Rate-limit key can be spoofed off the Caddy path.** `clientAddress()` keys the limiter on the last `X-Forwarded-For` entry. Under Caddy that entry can't be forged. But if the app is reachable directly (`HOST` defaults to `0.0.0.0` outside the AWS systemd unit), a client can set that header and get around the per-network rate limit. The code comment documents this, and the only cost is extra signups, which the store's dedupe bounds.
- **Async error path depends on the Express version.** The async waitlist handler rethrows any error that isn't a `WaitlistEmailError`. That error reaches Express's error handler only on Express 5 or with an async wrapper. In practice `normalizeEmail` throws only `WaitlistEmailError`, so the risk is low. I didn't check which Express version the repo uses.

No garden or project repo changes, and no follow-up jobs.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr198-screen-f4c29e6c-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (159323 cached reads)
- Output: 1445 tokens
- Cost: $0.40314059999999996
- Wall-clock: 22s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
