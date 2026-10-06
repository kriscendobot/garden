Clean stage for kriscendobot/minion.town#165 ("feat(claude): pin per-guest inbox responders") is done: I added one test file, pushed it, and CI is green on the new head.

**Coverage pass:**
- **Gap found:** I checked the PR's new modules under `src/endo/claude/`. The only one with no test was `inbox-responder-endpoint.ts`, the loopback `POST /_internal/claude/infer` router. Only `src/http.ts` used it.
- **Test added:** `test/claude-inbox-responder-endpoint.test.ts`, 5 vitest cases. They cover:
  - the bearer token and prompt being passed through, returning 200
  - a missing, non-Bearer or empty Bearer authorization header returning 400
  - a non-string prompt returning 400
  - an unrecognized token returning 403
  - an inference error returning 503
- **Local checks:** all 5 tests pass locally and `tsc --noEmit` reported no errors. I formatted the file with prettier.

**Dead code:** the lines the PR deleted (the old `makeClaudeAgent`/`provideChild` child-record path and the `model` option) don't leave any helpers unused. There was nothing to remove.

**Push and CI:**
- I pushed commit `775d9bd` with `safe-push-pr-head.sh --mode advance` (head `7180746` → `775d9bd`).
- `ci-wait-merge.sh --no-merge` returned rc 0. All 3 checks passed: test, and Claude harness on amd64 and arm64.

The PR is still a draft, as expected at this stage. No follow-ups.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr165-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (595334 cached reads)
- Output: 4779 tokens
- Cost: $0.5816467999999999
- Wall-clock: 313s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
