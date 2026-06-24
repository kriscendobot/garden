Inbox empty. Work complete.

---

## Completion report: `harden-producer-push-path`

**Committed & pushed:** `0f49238b` on `origin/main2` (confirmed reachable — dogfooding the verify-after-push principle). Fast-forward from `f757e17e`.

### Root cause (confirmed empirically)
Reproduced the silent loss with 8 concurrent `post-job.sh` against one shared `$GARDEN_STATE/producer/journal` clone: **only ~2 of 8 landed**. The producer clone is a single working tree/index/HEAD shared by `post-job`, `inbox-send`, `send-msg`, `set-schedule(-once)`, `set-gardeners`, and `journal-entry`. Their sync→write→commit→push sections interleave: one process's `sync_clone` `reset --hard`/`clean` wipes another's just-staged job, so its `git add`/`commit` then aborts under `set -e` **before the retry loop** — a silent directive loss — alongside `.git/index.lock`, `cannot lock ref HEAD`, and `.git/config` collisions and a cold-clone race.

### Fix (both layers in the shared primitive `common.sh`, so every caller inherits it)
1. **Serialization mechanism chosen: `flock`** (the smaller change — no per-invocation clone cost/teardown). The lock is held across the whole critical section (`sync_clone`/`ensure_clone` → `commit_and_push`), on a **sibling** lock file outside the working tree. `clone_lock` is re-entrant within a process and — via an inherited env marker — lets a **nested same-clone child borrow the ancestor's held lock** instead of deadlocking on it.
2. **Verify-after-push:** `commit_and_push` re-fetches and requires the pushed commit be reachable from `origin/journal2` before returning success; a push that "succeeds" without advancing the remote returns failure **loudly** so the caller re-syncs and retries. Single home for the logic — all callers inherit it.

### Two non-obvious bugs found and fixed mid-implementation
- A `2>/dev/null` on the fd-closing `exec` permanently silenced the shell's stderr (swallowing every "posted" log). Removed, with a guard comment.
- The "hold lock across caller code" design deadlocked `maintainer-reply.sh` → `maintainer-archive.sh` (same maintainer clone). Solved with the borrow-via-env-marker re-entrancy (only same-clone parent→child nester in the fleet; the mechanism is general against any future one).

### Concurrency-test result
**8 posted / 8 landed**, 0 errors, all printing success. New `run-test.sh` **SUBTEST 18** asserts: 8-way all-land; an injected push-that-doesn't-advance makes `commit_and_push` fail; the lost post is absent from the remote; the caller retries then gives up loudly (never a false "posted"). Added `GARDEN_POST_ATTEMPTS` override so the give-up test runs fast.

**Verification:** full suite **95 passed / 0 failed** on the actual commit base; `shellcheck`/`bash -n` clean on `common.sh` and `post-job.sh`.

### Relationship to the companion job
`inbox-send.sh` uses the same primitive, so the **dead-mail loss** (`audit-inbox-discipline-and-deadmail`) and this **silent post loss** share this root cause — that job hardens delivery semantics, this one hardens the push. They compose without overlap; SUBTEST 16 (deadmail) stays green under this change.

### Notes / follow-ups
- The shared `/home/kris` tree advanced under me mid-job (concurrent gardener landed the gh-identity block + a `SUBTEST 17 — GH IDENTITY`). I committed via an **isolated worktree off `origin/main2`**, re-applied only my hunks, and **renumbered my subtest to 18** to avoid clobbering that work.
- Pre-existing, unrelated: `mentor.sh`'s `journalctl --user -u 'garden-*'` blocks in this sandbox (confirmed identical on old code); I only stubbed it to run the full suite — no code change. Worth a defensive `timeout` on that call in a future mentor-hardening job.
