Gauntlet fix round 7 on kriscendobot/minion.town#186: I pushed `81beda5` to `build/root-canary-principal` and CI is green (`ci-wait-merge.sh` rc 0). All of the panel's must-fix items are closed except the assessor's `watchInbox` mail round-trip, which I declined.

**Must-fix items closed**
- **breaker:** the Cognito token endpoint is now a fixed value, so a canary child can no longer redirect the client secret and refresh token through `ROOT_CANARY_TOKEN_URL`. A regression test sets that variable to an attacker URL and checks the helper still reaches Cognito.
- **saboteur:** I removed the `MINION_ROOT_CANARY_MCP_URL` override, so the root bearer only ever goes to `https://minion.town/mcp`.
- **assessor, negative-client check:** the live canary now requires a new helper, `MINION_ROOT_CANARY_UNALLOWED_BEARER_CMD`, which prints a token from a client outside `OAUTH_ALLOWED_CLIENT_IDS`. The run fails unless `/mcp` rejects that token with 401. No such helper exists yet, so the canary will refuse to start until one is provisioned.
- **spec-keeper / corner-prober, dates:** run-name timestamps that aren't real dates are rejected, so `20260230` no longer becomes March 2. Tests cover February 30, February 29 in a non-leap year, April 31 and hour 24.
- **corner-prober, token lifetime:** a refreshed token now needs numeric `iat` and `exp` with `exp >= iat`, still at most 15 minutes apart.
- **prover:** a new test checks that a call the admission gate rejects is not audited.
- **stylist:** `args` is renamed to `toolArguments`, and the test file has the `spell-out-exempt` marker.
- **archivist / integrator:** the design's status now says the scripts are implemented but nothing is provisioned or armed. `root-canary-deploy-client.sh` refuses to run unless `ROOT_CANARY_SPIKE_PASSED=yes`, so client setup can't happen before the verification spike. DEPLOYMENT.md now puts the spike first.
- **pruner:** removed the malformed comment in `root-canary-exec.sh`.
- **transplanter:** already fixed by `4f46574`, which was pushed after the panel's snapshot.

**Should-fix items also closed:** errors from malformed tool output now name the tool, the doc comments describe the `report` callback, and there are fast-check round-trip properties for run names and audit records.

**Declined: the assessor's `watchInbox` mail round-trip.** The canary can't do this today. No MCP tool lets the non-root `minion-mcp-test-cc` guest address a root child. The shipped inbox responder also writes its result into the child's own storage rather than replying to the root's inbox. Closing it needs a server or design change, so the next panel will likely raise it again. DEPLOYMENT.md now states the gap.

**Summary comments:** I posted the round-7 summary on the PR. It also gives the scribe's retrospective note on `63265e4` and `57aafde`, the two earlier fix pushes that never got summaries.

**Verification:** the five affected test files pass and `npm run typecheck` is clean. The full vitest run had one failing test in `test/git-remote/capability.test.ts`, and two `tools/claude-harness` test files failed to load. This round doesn't touch those areas.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr186-gauntlet-fix-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 100 tokens (5219351 cached reads)
- Output: 29923 tokens
- Cost: $2.669138200000001
- Wall-clock: 2687s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
