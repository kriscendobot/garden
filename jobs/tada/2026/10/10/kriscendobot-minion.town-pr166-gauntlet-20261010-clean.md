**Clean stage for kriscendobot/minion.town#166 is done: CI is green at the head and nothing needed changing, so I pushed nothing.**

- **PR state:** draft, open, head `1f84e580` on `kriscendobot:feat/prod-objectives-probe`.
- **Coverage:** I ran `node --test --experimental-test-coverage deploy/probe/prod-objectives.test.mjs` in an isolated checkout, and all 16 tests pass.
  - The pure header, cache, JWT and status functions in `deploy/probe/prod-objectives.mjs` are all tested.
  - The file is at 70.9% line / 90.6% branch coverage. The uncovered lines are the check bodies that call production over the network, plus `runProbe` and `report`. Those run in `prod-probe.yml` on a schedule, not offline, so I didn't add tests for them.
  - `src/endo/gateway/cache-policy.ts` is at 100%.
- **Dead code:** none. Moving `IMMUTABLE_CACHE` out of `content-server.ts` into `cache-policy.ts` deleted the old copy and left no stray definition. Every internal helper in the probe script is used, and the new test step is wired into `test.yml`.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0 with 3 of 3 checks passing (test, Claude harness amd64, Claude harness arm64).

No follow-ups.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-20261010-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (277175 cached reads)
- Output: 1882 tokens
- Cost: $0.444427
- Wall-clock: 30s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
