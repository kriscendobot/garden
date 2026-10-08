I applied all of the round-2 panel's must-fix items and pushed them to PR #166, but CI never ran. GitHub Actions refused to start all three jobs (`test`, `Claude harness (amd64)`, `Claude harness (arm64)`) because the account hit its payment/spending limit. `ci-wait-merge.sh` returned rc=5 (billing-blocked) and has already alerted the maintainer. As instructed, I did not rerun or push again.

**What changed** (commit `39adda4` on `feat/prod-objectives-probe`, pushed with `safe-push-pr-head.sh` from `a443478`):

- **Purist (a), JWT decoding:** `jwtClaims` now uses `decodeJwt` from `jose`. Its error is caught and replaced with the fixed public reason "access token is not a decodable JWT", so the library's message never reaches the summary.
- **Purist (b), public summary:**
  - The unchecked `server` name is gone from the session details and from the round-trip check's output.
  - The scope failure now just says "token scope lacks mcp/guest".
  - On success, the reported scopes are filtered to the two the probe asks for (`mcp/tools`, `mcp/guest`).
- **Purist (c), duplicated gateway constants:**
  - `ISOLATION_FLOOR` is now built from the gateway's own `ISOLATION_HEADERS`, imported directly from `src/endo/gateway/isolation-headers.ts`.
  - `IMMUTABLE_CACHE` moved into a new import-free module, `src/endo/gateway/cache-policy.ts`. `content-server.ts` imports it from there, and the probe reads `HARD_CACHE_MAX_AGE` from it.
  - The two tests that regex-scraped the `.ts` source are replaced by checks on the imported values.
  - Importing `.ts` files this way needs Node ≥ 22.18. Both workflows use Node "22", and I noted the requirement in the probe's header comment.
- **Wire-watcher, repeated `Cache-Control` directives:** `hardCacheViolations` now treats any repeated directive as a violation, per RFC 9111 § 4.2.1. Two new rejection cases cover it, including `max-age=0, max-age=31536000, immutable`.

**Local checks:**
- `node --test deploy/probe/prod-objectives.test.mjs`: 20/20 passed.
- `tsc --noEmit`: clean.
- The gateway vitest suites: 27/27 passed.

The non-blocking should-fix items from the panel are not addressed in this round.

**Follow-up:** once the Actions billing block is lifted, CI needs to run on `39adda4` before the gauntlet driver posts panel-3.

<!-- gauntlet-stage-result: fix=ci-billing-blocked -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-20261008-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1334998 cached reads)
- Output: 11606 tokens
- Cost: $1.1397675999999999
- Wall-clock: 188s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
