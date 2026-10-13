# Gauntlet clean stage: kriscendobot/minion.town PR #184 (`fix/prod-probe-dispatch-backstop`)

The clean stage is done: I added two tests and CI is green at the new head `d8679a4`.

**Coverage pass**
- The PR's Lambda tests (`deploy/aws/ci-runner/lambda/test/index.test.mjs`) passed 21 of 21 before my change.
- Running them with Node's built-in coverage on `lambda/index.mjs` gave 100% branch coverage and 88% line coverage. The uncovered lines are the Secrets Manager and `fetch` input/output wrappers, which tests replace with fakes. That was already true before this PR.
- No dead code was orphaned: `readToken` and the new `readTokenFrom` / `readProbeToken` are all still used.
- `prod-probe-backstop.sh` passes `bash -n` and shellcheck with no output.

**Follow-up commit `d8679a4`** (`test(ci-runner): cover probe backstop ref gating and future-dated runs`) adds two tests on edge cases the PR's tests didn't check, bringing the count to 23 of 23 passing:
- **Ref gating:**
  - A `ref` without `force` is ignored and the dispatch goes to `main`.
  - A `ref` that isn't a string falls back to `main`, even when forced.
  - `force: "true"` as a string does not count as forcing, so a fresh run is left alone with no POST.
  - Refs with a leading or trailing `/` are rejected before any POST.
- **Future-dated run:** a run whose `created_at` is in the future counts as fresh, with `ageSeconds` clamped to 0.

I pushed it with `safe-push-pr-head.sh --mode advance`, moving the head from `935b6d6` to `d8679a4`.

**CI**
- `ci-wait-merge.sh --no-merge` returned rc 0 (1 of 1 checks, 0 failed).
- The bot token can't read the PR's combined check status on this host, so the script used the Actions runs API instead. Commit statuses and checks from outside GitHub Actions weren't visible to it.

**Follow-ups:** none. The PR is still a draft; un-drafting belongs to a later gauntlet stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr184-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (850059 cached reads)
- Output: 5953 tokens
- Cost: $0.7869358
- Wall-clock: 1664s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
