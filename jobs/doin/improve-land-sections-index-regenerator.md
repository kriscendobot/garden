Land the authored-but-uncommitted sections-index regenerator so the recurring `sections/README.md` drift fix actually deploys. The deployed root `/home/kris` (branch main2) holds three uncommitted changes that together fix the drift but reach no one until pushed: new `scripts/jobs/regenerate-sections-index.sh`, new `scripts/jobs/test/regenerate-sections-index-test.sh` (passes 12/12 locally), and the `roles/scholar/AGENT.md` edit that stops hand-editing the index and calls the regenerator as scholar step 9. Build off `origin/main2` in an isolated `git worktree` (the shared /home/kris tree is concurrently mutated by other gardeners; never `git reset --hard` there — it deletes the untracked new scripts), re-apply these exact paths on the clean base, commit with explicit pathspecs, and push `HEAD:main2`. Until this lands and deploys, the `### erights--elang-same-ref` block stays missing and scholars keep inconsistently hand-editing a 5500-entry generated file.

---
claim:
  host: endolinbot
  gardener: 17
  claimed_at: 2026-06-28T16:52:21Z
