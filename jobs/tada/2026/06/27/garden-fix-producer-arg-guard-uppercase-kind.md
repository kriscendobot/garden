Done. Inbox empty, worktree cleaned up.

## Completion report

**Job:** garden-fix-producer-arg-guard-uppercase-kind

**Root cause confirmed:** `scripts/jobs/journal-entry.sh`'s kind guard used `[A-Za-z]`-led / `[A-Za-z0-9_-]`-body charsets, which admit uppercase. `producer-arg-guard-test.sh` step 3 asserts an uppercase-led kind (`Progress`) is rejected, and its happy-path sub-assertion then tripped because the first posted entry was the wrongly-accepted `kind: Progress` instead of the intended `kind: progress`.

**Decision:** Took option 1 (tighten the guard) — the recommended path. Every real kind in the vocabulary (progress, claim, result, message, dispatch, error, tick, worktree) is a lowercase letter-led token, and uppercase kinds appear nowhere in practice.

**Change (1 file, `scripts/jobs/journal-entry.sh`):**
- Lead-char guard `[A-Za-z]*` → `[a-z]*`
- Charset guard `*[!A-Za-z0-9_-]*` → `*[!a-z0-9_-]*`
- Updated the two die messages and the preceding comment to say "lowercase-letter-led" / "only lowercase letters".

**Verification:**
- `producer-arg-guard-test.sh`: now **13/13 PASS** (was failing 2 assertions).
- `journal-entry-argv-test.sh`: stays **19/19 PASS** (its digit-led/space/dash-led/valid-`progress` cases are unaffected; it never tested uppercase).

**Discipline:** Built in an isolated detached worktree off `origin/main2`, staged with an explicit pathspec (`scripts/jobs/journal-entry.sh`), committed under the `endolinbot` bot identity, pushed `HEAD:main2` (`310dfcece..97110365b`), and removed the worktree.

**Follow-ups:** None. The fix is self-contained; no other producer or test references the kind charset.
