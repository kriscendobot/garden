Done. Job complete.

## Completion report

**Problem.** `worker_ensure_worktree()` in `scripts/jobs/handlers/worker-common.sh` ran the per-job worktree creation as `git -C "$GARDEN_ROOT" worktree add --detach "$worktree" "$ref" >/dev/null 2>&1`, discarding **both** streams. Any failure — most plausibly `index.lock`/"already registered" contention from the gardener pool's concurrent same-host worktree adds — surfaced to `gardener.sh` as a bare rc=1 with no diagnostic text (the "empty/transient-signature output" bucket), the almost-certain source of the ~730 unattributable "transient handler outage" retries seen 08-15..08-19, dozens escalating into unactionable elapsed-constancy overrun-suspect errors.

**Fix** (`scripts/jobs/handlers/worker-common.sh`):
- Keep only **stdout** on `/dev/null` (`2>&1 >/dev/null` capture, mirroring `ensure-project-worktree.sh`'s stdout-only discard) and hold the real stderr in a var.
- **Retry with backoff** (up to 4 attempts, `0.5s * n`) when the captured stderr matches a lock-contention signature (`index.lock`, `already (registered|exists|locked)`, `is already checked out`, `cannot lock ref`), deregistering any half-created worktree between tries — so a same-host race self-heals.
- Any **non-lock error is terminal**: it falls through to the next ref, and if all refs fail the real git stderr is **re-emitted** in the `die()` message instead of a bare rc=1.

**Test added** (`scripts/jobs/test/worker-ensure-worktree-test.sh`): self-contained suite driving the SUT directly against a throwaway garden root with a fake `git` shim (on an exec-allowed base, since `/tmp` is noexec here). Proves: clean add, lock-contention retry-then-succeed (asserts ≥3 real attempts), terminal-error stderr re-emission, and resume passthrough. 6/6 pass; `gardener-worktree-test.sh` still 44/44; shellcheck clean on both files.

**Committed & pushed** to `main2` as `2ae77946cc`.

**Follow-ups:** none required. The standalone suite follows the same self-contained convention as its siblings (`gardener-worktree-test.sh`, `project-worktree-isolation-test.sh`); there is no central aggregator to register it in.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-worker-ensure-worktree-swallowed-stderr.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 69 tokens (2597838 cached reads)
- Output: 22179 tokens
- Cost: $2.635906999999999 (2 engagement(s) unpriced)
- Wall-clock: 366s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
