## Gauntlet fix round 2: kriscendobot/minion.town PR #166

The round-2 must-fix items were already applied at the PR head before I started, so I pushed nothing new. CI on that head passed. I confirmed this through the Actions runs API, not through `ci-wait-merge.sh` returning rc 0, because that script can't read checks on this host.

**Head and base**
- PR head is `f432a511`, "fix(probe): import the gateway floor, use jose, reject repeated cache directives", on `kriscendobot:feat/prod-objectives-probe`.
- The base was re-pinned to `main-50aa690`.
- The latest panel verdict (round 2, gauntlet `-20261008`, posted against `a443478`) had two must-fix items. Neither needed more work.

**Must-fix items, checked against the head**
1. **purist**
   - The JWT is now decoded with jose's `decodeJwt`.
   - `getServerVersion()` / `server:` are gone from the public summary.
   - The scope failure reason now only says whether `mcp/guest` is present ("token scope lacks mcp/guest").
   - `ISOLATION_FLOOR` and `HARD_CACHE_MAX_AGE` now come from the gateway's own `ISOLATION_HEADERS` and `IMMUTABLE_CACHE` declarations. `IMMUTABLE_CACHE` moved to a new import-free `src/endo/gateway/cache-policy.ts`, and the tests no longer copy these values by matching regexes against the `.ts` source.
2. **wire-watcher:** a repeated `Cache-Control` directive now counts as a violation, which follows RFC 9111 § 4.2.1. The test file covers the case `max-age=0, max-age=31536000, immutable`.

**CI on `f432a511`**
- The `test (typecheck + vitest)` workflow passed, and so did all three of its jobs: `test`, `Claude harness (arm64)` and `Claude harness (amd64)`.
- `ci-wait-merge.sh` couldn't see any of this. This host's bot token is refused when it reads PR check status or the commit status API (403), so the script would only have polled until its deadline. I stopped it after about 10 minutes and read the results from the Actions runs API instead, as the host notes recommend.

**Follow-up:** `ci-wait-merge.sh` needs to fall back to the Actions runs API when it gets a 403 on checks. Until it does, every gauntlet stage that runs on `oros-studio-garden-ce242c49` will report "still pending" even when CI has passed.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-20261008-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 66 tokens (2108718 cached reads)
- Output: 16109 tokens
- Cost: $1.7661715999999998
- Wall-clock: 929s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
