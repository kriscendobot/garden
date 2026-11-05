Fix round 2 for PR #249 is pushed and CI is green: all 7 checks passed (`ci-wait-merge` returned 0). I fixed all 9 of the latest panel's must-fix findings in one follow-up commit, `2560b10a`, on `kriscendobot/minion.town` branch `fix/api-key-agent-panel3`.

**Server (`src/auth/inference-provider-endpoint.ts`)**
- **breaker:** Each agent move during a key replacement now gets its key from the replacement's own idempotency key, not from the caller-chosen `operationId`. Changing `operationId` can no longer re-run a move that already happened. `operationId` is still validated so older callers keep working.
- **corner-prober:** An earlier operation's provider counts as a source to move from only if that operation replaced this same provider. An unrelated operation that reuses the key can no longer move another provider's grants.
- **wire-watcher:** A move that names only a grant is refused with `agent-creation-in-progress` while any agent is still being created on the source provider. The "being created" check now only looks at agents on the source providers.

**UI (`deploy/aws/www/provider-ui.js`)**
- **breaker:** Only a lost connection, an unreadable response, or the three service/daemon "unavailable" errors (`account-service`, `daemon`, `provider-service`) now count as "we can't tell if it worked". Before, any error ending in `-unavailable` did. A fixed refusal such as `subagent-creation-unavailable` now ends that attempt, so the user can drop the endowment and try again.
- **saboteur:** The wake toggle is disabled while a change is in flight, so two clicks can't go out at once and finish in the wrong order. A reply only updates the screen if the same agent is still open.

**Tests**
- **prover:**
  - I deleted the raw-JSON sentinel-cap test, which the base code already passed.
  - I rewrote the CapTP replacement test in `test/inference-provider-service.test.ts` to check the exact move keys, so it now fails without this change.
- **fast-checker:** I added a fast-check property test that injects random `extra*` fields into nested agent and reattach-option records and checks that none appear in the responses.
- New tests also cover:
  - refusing a grant-only move while an agent is being created;
  - ignoring unrelated earlier operations, whether committed or in progress;
  - the same move key being reused when only `operationId` changes;
  - the wake toggle staying locked during a change (browser test).

**Changeset**
- **migrator:** The release type is now `minor` instead of `patch`. The note marks two newly refused inputs as **Breaking**: whole-unit caps above the safe-integer limit, and endowments other than `[]` or `["subagent-creation"]`.
- **changeset-auditor:** Each sentence is now on its own line.

**Local checks:** typecheck passed. The full suite had 1868 passing and 1 failing: `git-remote/capability`, which is a known local-only failure in the git-wrapper test and unrelated to this change. The browser test files are skipped locally, so CI was the only place the new wake-toggle test ran.

Running prettier on the files I touched also reformatted some unrelated lines that weren't prettier-clean before, so the diff is noisier than the fixes alone.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr249-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (2453130 cached reads)
- Output: 15848 tokens
- Cost: $1.4672020000000001
- Wall-clock: 584s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
