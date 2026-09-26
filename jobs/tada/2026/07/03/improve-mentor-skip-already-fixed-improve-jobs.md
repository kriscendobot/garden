Done.

## Completion report

**What I did:** Added a deterministic, no-LLM already-fixed-pending-deploy pre-filter to `scripts/jobs/handlers/mentor-claude.sh`, gating the posting loop's `post-job.sh "$base"` call.

**What changed:**
- New `already_fixed_pending_deploy()` helper in the handler. For each emitted JOB block it:
  1. Extracts the file tokens the body names via `grep -oE '[A-Za-z0-9._/-]+\.(sh|md|py|js|ts|service|timer)'` (deduped).
  2. Lazily runs `git -C "$GARDEN_ROOT" fetch -q origin main2` once per invocation (cached via `_m2_fetched`).
  3. For each named path that exists in `origin/main2`, runs `git -C "$GARDEN_ROOT" diff --quiet origin/main2 -- "$path"`. If any implicated path already differs — the fix is committed upstream, pending deploy, the same freshness signal `garden-upgrade-monitor` uses — it logs `improve job for <path> already fixed in origin/main2 (pending deploy); not reposting` and returns skip.
- The posting loop now posts only when the filter returns non-skip.

**Notes/decisions:**
- The diff compares the deployed root's working tree (the deployed version) against `origin/main2`, so it fires exactly when a fix is upstream but not yet deployed — the root cause of the observed churn (14 duplicate `improve-clone-keeper-*` jobs; the clone-keeper self-heal and xs2rust-endor-press preflight WARNs are both already resolved upstream).
- Non-existent tokens (e.g. `garden-clone-keeper.service` unit names that aren't tracked paths) are skipped via a `cat-file -e` existence guard, so they don't cause false skips or errors.
- Verified with `bash -n` and a spot-check of the extraction regex. Committed and pushed to `main2`.

**Follow-ups:** None required. The filter's real-world effect depends on the deployed root running the new handler, which lands on the next deliberate deploy.
