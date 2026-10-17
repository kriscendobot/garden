## Gauntlet fix round 1: kriscendobot/minion.town#198

I applied the panel's round-1 must-fix and should-fix items, pushed them, and CI is green: all 3 checks pass at `cfb8bbd` (`ci-wait-merge` rc 0). One item, from the procurer seat, was declined (reason below).

**Commits pushed** with `safe-push-pr-head.sh` (`9b76559` → `cfb8bbd`):

- **`8939108` fix(waitlist)**
  - **2 KB limit was dead code:** the waitlist router now mounts before the global `express.json()` in `src/http.ts`. The rate limiter runs before body parsing, so malformed bodies still count against it. Parser failures now come back as JSON 413 or 400.
  - **Rate limiter lockout:** when the key table is full it drops expired windows first, then the oldest live one, instead of refusing every new network.
  - **CSV export:** `list --csv` quotes fields per RFC 4180 and puts a `'` before a leading `= + - @`, so a spreadsheet won't run them as formulas.
  - **Email normalization:** `normalizeEmail` now lowercases before NFC.
  - **Shared fallback bucket:** requests without `X-Forwarded-For` share one rate bucket. This is now documented and pinned by a test.
  - **Tests:** new cases for 413, malformed JSON, eviction, CSV escaping, NFC, the 254/255 length boundary, and the shared bucket. A full-app test confirms a 3 KB body gets a 413.
- **`cfb8bbd` docs(web)**
  - `designs/clip-shell-framework.md` § 8 and the "Shell side" note now describe the public `handle /` landing; this was the archivist's one must-fix.
  - Removed the `designs/guest-coupons.md` link (the file isn't in this tree) and the job-name narration in the status line.
  - Removed the comment banners in `deploy-waitlist-store.sh` and the section-label comments in `home.js`.
  - Shortened the headers in `home.js`, `index.html`, the Caddy file and `DEPLOYMENT.md` to a short note plus a pointer to the design doc.
  - Fixed the stale "Guarded" JSDoc in `shell.js` and the claim that only a 401 forgets a credential (a 403 does too).
  - Replaced the added `→` and `…` with ASCII.

**PR body** rewritten from about 940 words to a short version that links to the design doc. It keeps the `garden-job` marker, says the browser evidence was a local run, and has a "Panel round 1" section.

**Local checks:** `tsc` is clean. `npm test` passes except `test/git-remote/capability.test.ts`, which the PR body already lists as unrelated to this PR.

**Declined:** the procurer seat asked to use `makeRateLimiter` from `@endo/http-confine`. That package isn't published to npm (404) and this repo doesn't link it, and copying it in for a 30-line counter costs more than it saves. The reason is recorded in the PR body.

**Not done:** comment-only items such as the constant `Retry-After`, DynamoDB TTL lag, and the IPv6 embedded-IPv4 group count. The round-2 panel can raise them again if they matter.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr198-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (3049198 cached reads)
- Output: 22351 tokens
- Cost: $1.9208675999999998
- Wall-clock: 2912s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
