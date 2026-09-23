Inbox is empty. Work complete.

---

## Completion report

**Job:** `self-heal-fix-garden-cleric-corrupt-journal-clone-reclone`

**Context found:** The bulk of this self-heal was already landed in prior commits (`98e7f6229e`/`e80d69e7b6`/`38778e3919`): `GARDEN_CORRUPT_CLONE_SIGNATURES`, the `_fetch_stderr_is_corrupt` classifier, and the full two-stage heal in `sync_clone` (cheap targeted ref repair via `update-ref -d` + `remote prune`, then a loop-guarded full `rm -rf` + `ensure_clone` reclone, `ensure_clone` run in a subshell to preserve the flock). The remaining gap was the **signature set**.

**What I changed** (`scripts/jobs/common.sh`):
- Added `failed to run repack`, `gc\.log`, and `does not point to a valid object` to `GARDEN_CORRUPT_CLONE_SIGNATURES`, and broadened `unable to read (tree|sha1|object)` → generic `unable to read`.
- The observed cleric-item-7 crash-loop had a second shape — a stale `.git/gc.log` blocking repack, surfacing as `fatal: failed to run repack` with **no `bad object` line**. That stderr slipped past the classifier, so `sync_clone` fell through to `die()` and systemd crash-looped forever. It now classifies corrupt and reclones. The offline classifier still runs first, so a transport `Could not read from remote` is claimed as offline before this set sees it.
- Expanded the explanatory comment to record the second incident shape.

**Test coverage** (`scripts/jobs/test/run-test.sh`): added classifier fixtures for `failed to run repack`, `gc.log present`, and a bare `does not point to a valid object` (no accompanying `broken ref`).

**Verification:**
- Classifier subtest run in isolation: **37/37 PASS** (all new fixtures classify corrupt; offline cases stay clean).
- Reclone path exercised end-to-end against a real bare remote: (A) null-sha ref → targeted repair, no reclone; (B) persistent bad-object → full reclone; **(C, the new scenario)** a `failed to run repack`/`gc.log`-only stderr with no `bad object` line → **reclone fires, signature `gc.log`, exit 0** instead of the crash loop.
- `bash -n` clean on both files. (Note: the full `run-test.sh` harness aborts at SUBTEST 4/gardener-scaler in a job worktree — confirmed pre-existing on unmodified HEAD, an infra dependency absent here, not from this change. The affected subtests, 23/24, were run in isolation.)

**Committed & pushed:** `746440995b` on `main2` (fast-forward from `38778e3919`, HEAD == origin/main2).

**Follow-ups:** None required. The optional immediate unblock for the live work-item-7 clone (`rm -rf .garden-state/clerics/7/journal` on the affected host) is an operator action on the deployed root, outside this worktree; with the guard now deployed, the next restart will reclone automatically once this lands via the deliberate deploy.
