# Gauntlet fix round 1: kriscendobot/minion.town PR #166

I applied the panel's round-1 must-fix items and the cheap should-fix items, and pushed them to the PR head. CI is green on the new head `cca9e8ea2` (`test`, Claude harness amd64 and arm64). A live run against production with the credential and `--strict` passed all 6 checks.

**Must-fix items applied:**
- **stylist:** renamed `req`/`res` to `request`/`response`, `ms` to `durationMilliseconds` (the docs match), and `args` to `toolArguments`.
- **spec-keeper:** `parseCsp` now keeps the first of a repeated directive, as CSP3 § 2.2.1 requires, so the probe reads the same policy a browser enforces. Keyword case is also ignored, and both have tests.
- **integrator and archivist:** the comment now cites `designs/ocap-site-clip-isolation.md` § 2.2 instead of the missing, retired "weblet" file. I also corrected the `jwtClaims` doc comment.
- **corner-prober and breaker:** a new `--strict` flag makes a skipped check exit non-zero. The scheduled run passes it, so an objective that wasn't checked turns the run red. The tracking issue now lists skipped checks as well as failed ones.
- **pruner:** the PR body is shorter. The six-check list and the test count are gone, and the "see the PR thread" sentence now says the secrets were set on 2026-10-07 (`gh secret list` confirms it).

**Should-fix items applied:**
- **Privacy:** failure reasons in the public summary no longer include response, tool or status text. They give status codes, error codes and lengths only.
- **Full isolation floor (purist):** the probe now checks every CSP directive and every header in the gateway's `ISOLATION_HEADERS`. Before, it checked only part of it. A unit test reads `src/endo/gateway/isolation-headers.ts` and fails if the probe's copy and the gateway's declaration differ. I first confirmed that production serves the full floor.
- **Session retry:** a failed check now drops the cached MCP session, so the retry opens a fresh one.
- **MCP version header:** the probe sends the negotiated `MCP-Protocol-Version` on every later request and checks the version is one it supports.
- **Paths:** file paths are built with `new URL` instead of `node:path`.
- **Canary source:** the canary clip's bytes are now committed as `deploy/probe/canary/index.html`. A test checks them against the SHA-256 recorded in `canary.json`.
- **Token parsing:** a token payload that isn't JSON now fails cleanly, and a `scope` claim given as an array is read correctly.
- **Docs:** DEPLOYMENT.md now says the summary artifact is temporary and never committed, and describes strict mode and the canary source.

**Checks:**
- Unit tests: 15 of 15 pass.
- `actionlint` is clean.
- Prettier flags 3 files, but it isn't a CI gate and the original commit already failed it.

**Not addressed (comment-only):** CSP sent as several comma-separated policies, parameters on the COOP/COEP headers, a per-run name for the round-trip check, a 304 test with a non-matching ETag, and renaming the `CC` environment variables.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1868366 cached reads)
- Output: 19858 tokens
- Cost: $1.5241932000000005
- Wall-clock: 490s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
