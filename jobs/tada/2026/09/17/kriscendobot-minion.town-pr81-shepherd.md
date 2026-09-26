CI is green on the head SHA (`77504674`). Done.

## Completion report

**Job:** shepherd (auto: red CI) on kriscendobot/minion.town PR #81 — "Build: web bearer guest invite and accept workflow"

**Diagnosis:** The single failing check (`test`) failed inside `test/endo-daemon-integration.test.ts`, on the subtest *"full tool surface over the live daemon"* with `MCP error -32001: Request timed out` (60.9s). 4 of 5 tests in that suite passed. This is the **known B1 live-daemon flake** (memory: *minion.town live-daemon B1 flake* — daemon boot/round-trip timeouts that recur on `main`; re-run before digging), confirmed independent of this PR:
- The failing file is a **pre-existing** suite, not the new `test/web/guest-web-daemon.test.ts` this PR's tip commit added.
- The prior run on this branch (`e3c84775`) was green; the tip commit `77504674` only added the new guest-web test, a `test.yml` step, a design doc, and a demo — none touching the endo-daemon suite.
- `main` itself shows the same `test` job flaking (`e7b3b5a6`, 09-16).
- Because the endo-daemon step runs before the new guest-web step under `bash -e`, the job aborted there and the new test never executed on the red run.

**Action:** Re-ran the failed job (`gh run rerun 35176410643 --failed`). It passed in 1m56s — the endo-daemon suite cleared *and* the new guest-web-daemon acceptance step ran green.

**Result:** PR #81 CI is now green (`test` = SUCCESS on head `77504674`). No code change needed; no push made.

**Notes / follow-ups:**
- No PR comment posted — kriscendobot/minion.town is my own instance's fork (per *no-inter-instance-github-loops*), and this auto-dispatched job carries no per-action comment authorization.
- Minor, non-blocking: the new `test.yml` step lists the guest-web test file twice (`... guest-web-daemon.test.ts test/web/guest-web-daemon.test.ts`); vitest dedupes so it's harmless, but a future fixer/builder touching that workflow could drop the duplicate. Not worth a shepherd push on its own.
- The B1 flake remains a standing operational nuisance across this repo; no shepherd fix is in scope (it's an env/timing flake in the pinned-Endo-daemon boot).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr81-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (599072 cached reads)
- Output: 5433 tokens
- Cost: $0.964674
- Wall-clock: 247s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
