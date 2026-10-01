Fixed and pushed to `main2` as `c7f1ddbfce1`. `scripts/jobs/test/triager-test.sh` no longer captures the fleet git wrapper as its "real git", so its fake git shim can't recurse forever.

**What changed**
- **`triager-test.sh` (case F shim):** `REAL_GIT="$(command -v git)"` became `REAL_GIT="$(hash -r; type -aP git | grep -v '/scripts/jobs/bin/git$' | head -n 1)"`.
- **`journal-contention-watch-test.sh`:** I fixed this one too, though the job didn't name it, because it had the same problem. Its two `count-objects` shims ran `exec "$(command -v git)"`, which can reach the wrapper and recurse the same way. Both now use the same filtered `REAL_GIT`.
- **`fetch-timeout-test.sh` and `worker-ensure-worktree-test.sh`:** these are the sibling suites fixed in `2916e65ffb9`. They also needed `hash -r` added.

**Why `hash -r` was needed**
Copying the sibling tests' pattern exactly broke `triager-test`. Once bash has already run `git` in a shell, `type -aP git` returns only that one remembered path, which here is the wrapper. The filter then removed it, `REAL_GIT` came out empty, and the suite died under `set -euo pipefail`. I reproduced this in a plain shell: `type -aP git` listed 4 paths before running `git` and 1 after. Running `hash -r` first inside the substitution restores the full list. The two sibling suites only worked because they set `REAL_GIT` before running any git, so I added `hash -r` there as well.

**Test results** (run with the wrapper on PATH)
- `journal-contention-watch-test`, `fetch-timeout-test` and `worker-ensure-worktree-test` all pass.
- `triager-test`: the first run had 160 passed and 2 failed, a re-run had 162 passed and 0 failed. Both failures were in the handler-timeout section, which uses a 1-second tick deadline. The deadline was hit before the handler started, which looks like a timing flake under load. The section doesn't involve the shim I changed.

**Follow-ups**
- `run-test.sh:341,356` still pass `GARDEN_INBOX_RETRY_REAL_GIT="$(command -v git)"`. I didn't check whether that can recurse.
- The handler-timeout 1-second deadline in `triager-test.sh` failed under load once in two runs; it may need a less tight budget.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-triager-test-git-shim-resolution.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1007932 cached reads)
- Output: 5963 tokens
- Cost: $0.7578944000000001
- Wall-clock: 242s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
