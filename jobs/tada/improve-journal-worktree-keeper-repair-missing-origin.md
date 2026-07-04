Work complete.

## Completion report

**Job:** Make `journal-worktree-keeper.sh` deterministically repair a dropped `origin` remote on the journal worktree so the fleet self-recovers on the next ~30m tick instead of wedging on the "no origin" fatal path.

**State found:** A companion commit (`d2e178122`) had already added the `jw_ensure_origin` guard and wired it into `keep_journal_worktree` *before* `journal_fetch` (with a matching skip-gate), so the structural fix the job described was in place. But that guard re-added origin **only from `$GARDEN_ROOT`'s origin** — it did not honor the `$JOURNAL_REMOTE` override or the persisted canonical URL the job explicitly called for, and there was **no test coverage** for the missing-origin path at all.

**What I changed:**
1. **`scripts/jobs/journal-worktree-keeper.sh`** — `jw_ensure_origin` now derives the repair URL from `journal_remote` (common.sh), the same canonical resolver every other consumer uses. Its fallback order is `$JOURNAL_REMOTE` → the worktree's own origin → the persisted per-host cache (`$JOURNAL_REMOTE_CACHE`, the companion job's last-good value, which survives a reset/deploy) → `$GARDEN_ROOT`'s origin. The prior root-only source could not recover in the window where the root origin was momentarily gone too but the cache still held the URL. A possible `journal_remote` `die()` is confined to the command substitution (`$(… || true)`, `2>/dev/null`), so an unresolvable remote leaves the repair to the caller's gate rather than killing the keeper. Updated the function's doc-comment accordingly.
2. **`scripts/jobs/test/journal-worktree-keeper-test.sh`** — added two test cases (10 assertions) for the previously-untested missing-origin path: origin removed then re-added from an explicit `$JOURNAL_REMOTE`, and from the persisted cache with no `$JOURNAL_REMOTE` set — each asserting origin restored to the canonical URL, a `REPAIRED:` log line, clean reconcile to `origin/journal2`, and no maintainer page.

**Verification:** Full keeper test suite green — **78 passed, 0 failed** (was 68 before my additions).

**Committed & pushed** to `main2` (rebase-CAS, first attempt). Inbox drained, empty.

**Follow-ups:** None. The origin re-add now uses the canonical resolution order end-to-end; no open gaps.
