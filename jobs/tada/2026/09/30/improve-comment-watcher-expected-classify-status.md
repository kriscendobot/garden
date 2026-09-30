The comment watcher no longer logs a false `FATAL` when `classify` returns its expected rc 1 or rc 2. The fix is pushed to main2 as `aa5c07a51ee`.

**Cause:** At `scripts/jobs/comment-watcher.sh:2067`, the call was wrapped as `set +e; classify …; rc=$?; set -e`. That stops the script from exiting, but the `ERR` trap still fires. So every "not actionable" (rc 1) and "ambiguous" (rc 2) result was logged as `FATAL: rc=N at line 2067: return N`, which is the recurring log line in the job.

**Fix:**
- `classify` is now called inside an `if`, as the job asked: `if classify …; then rc=0; else rc=$?; fi`. Bash doesn't fire the `ERR` trap for a command in an `if` condition. The rest of the rc handling is unchanged.
- I applied the same change at the two `GARDEN_PR_MERGEABLE` checks (around lines 2156 and 2184). They had the same bug: a probe reporting "already merged/closed" (exit 2) or "not ready" also logged a false `FATAL`.
- Failures anywhere else in the script still trigger the trap. Behaviour is otherwise the same as before: the old `set +e` already kept these calls from aborting the script.

**Tests:** I added three checks to `scripts/jobs/test/comment-watcher-test.sh` that fail if a `FATAL` line is logged in these cases:
- a trusted but ambiguous comment (rc 2)
- an untrusted comment that gets dropped (rc 1)
- a directive on a PR that is already merged (the probe returns 2)

The full suite passes with the fix (420 passed, 0 failed). Against the old watcher, exactly these three checks fail with the same `FATAL` lines seen in production.

**Deployment:** The running watcher keeps logging these false `FATAL`s until this host's root checkout is deployed at or past `aa5c07a51ee`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-comment-watcher-expected-classify-status.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (900597 cached reads)
- Output: 5209 tokens
- Cost: $0.7636034
- Wall-clock: 686s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
