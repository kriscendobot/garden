Pushed cleanly on the first attempt.

## Completion report

**Job:** Guard the triager's ref-resolution block so an empty / unborn-HEAD bare clone skips the tick gracefully (exit 0) instead of `die`-ing with exit 1 and crash-looping the systemd unit.

**What I did:**

- **`scripts/jobs/triager.sh`** — Replaced the unconditional `die "cannot resolve ref '$ref'"` (lines ~128–130) with a branch: when the watched-ref rev-parse fails on both the primary (`refs/remotes/origin/$ref`) and fallback (`$ref`) forms, it now checks `git --git-dir="$BARE" for-each-ref --count=1`. If the clone has **zero refs** (empty / unborn HEAD), it `log`s `"$slug is empty (unborn HEAD, no commits yet) — skipping this tick"` and `exit 0` — matching the "skip this tick" convention already used for the missing-clone branches above. A clone that **has refs** but still can't resolve the watched ref keeps the loud `die`, so a genuine misconfiguration (wrong `GARDEN_WATCH_REF`, deleted branch — the existing agoric-sdk scenario) is not masked.

- **`scripts/jobs/test/triager-test.sh`** — Added two cases:
  - **K**: a bare clone with zero refs (`git init --bare`, no commits) → asserts exit 0, the skip-reason log, handler never invoked, and the activity cursor not advanced.
  - **L**: a bare clone *with* refs but an unresolvable `GARDEN_WATCH_REF=no-such-branch` → asserts it still dies non-zero, names the ref, does **not** take the empty-clone path, and the handler never runs (guards the escalation path against being swallowed).

**Verification:** Full suite passes — **77 passed, 0 failed** (was 68 before). `bash -n` clean.

**Changed:** 1 commit on `main2` (`0840349dd9`), pushed to `origin/main2` on the first CAS attempt.

**Follow-ups:** None. The fix self-heals the moment the fork gets its first commit; no deploy action needed beyond the normal deliberate-deploy path picking up `main2`.
