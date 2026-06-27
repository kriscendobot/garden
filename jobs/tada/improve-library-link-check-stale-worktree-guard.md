No inbox messages. Work is complete and pushed.

---

**Completion report — `improve-library-link-check-stale-worktree-guard`**

**What I did:** Hardened `scripts/jobs/library-link-check.sh` so the whole-library validating scopes (`--all`, `--nav`) cannot emit phantom must-resolve FAILs when pointed at a stale live worktree — the exact failure the scholar hit on 2026-06-27 (12 phantom FAILs because `$GARDEN_ROOT/journal/library` lacked commit `9840fa1db`).

**What changed:** Inserted a staleness guard immediately after `GIT_ROOT` is computed (right after line 131). When the scope is `--all` or `--nav` *and* the library lives in a git repo *and* a local `origin/journal2` ref exists, it runs a no-network `git merge-base --is-ancestor origin/journal2 HEAD` check. If HEAD is behind the tip, it prints a loud multi-line setup-error (naming the behind/tip short SHAs and pointing to `library-link-scan.sh` as the correct tip-syncing wrapper) and exits 2 (setup error) instead of running a validating scan. `--changed`/`--source-slug`/`--files` are untouched. The compare is against the already-fetched local ref only, so the script's "NO writes and NO network calls" invariant is preserved.

**Verification:** Built a 5-case git fixture and confirmed: (1) `--all` on a behind worktree → exit 2 with the setup error; (2) `--nav` behind → exit 2; (3) `--changed` behind → exit 0 (guard correctly skipped); (4) `--all` after fast-forwarding to tip → exit 0 (normal scan); (5) `--all` with no `origin/journal2` ref present → exit 0 (guard gracefully skipped). Also `bash -n` clean.

**Delivery:** Built in an isolated worktree off `origin/main2` (per the shared-tree norm), committed `93f2a6235`, pushed `af201c3e8..93f2a6235 HEAD -> main2`, worktree removed. No inbox messages during the job.

**Follow-ups:** None required. One judgment call worth noting: the error message names `$GIT_ROOT` (the git toplevel) rather than the `--library` subdir, since staleness is a property of the checkout's HEAD; this is intentional and clearer for the operator.
