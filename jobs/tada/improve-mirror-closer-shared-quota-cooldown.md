The commit is on `origin/main2`. Work complete.

## Completion report

**Job:** `improve-mirror-closer-shared-quota-cooldown` — make `mirror-closer.sh` participate in the shared host-wide gh-api cooldown latch instead of running a blind private circuit breaker.

**What changed** (`scripts/jobs/mirror-closer.sh`):
1. **Reads the shared latch before doing any work.** Added `api_cooldown_active && exit 0` (with a log line) right after the existing mirror-specific quota check and *before* the journal clone and per-mapping loop — mirroring `ci-watcher.sh:131`. Now a rate limit tripped by any sibling watcher skips the whole tick before mirror-closer spends its own doomed `gh` call.
2. **Arms the shared latch on its own quota hit.** `start_mirror_quota_cooldown` now also calls `start_api_cooldown "mirror-closer:primary-quota"`, so a primary-quota exhaustion discovered *here* immediately protects every other gh-api watcher on the host. The service keeps its own longer (hourly) mirror marker; the shared latch is the shorter cross-watcher herd guard.
3. Updated the header doc block to describe both directions of the wiring.

**Tests** (`scripts/jobs/test/mirror-closer-test.sh`):
- Isolated `GARDEN_API_COOLDOWN_DIR` into the throwaway test tree at top level so no test invocation can trip the **real** host's fleet-wide latch (the pre-existing quota tests would otherwise have written to it via the new `start_api_cooldown` call).
- Neutralized the shared latch in the existing H1/H1b/H1c mirror-quota assertions with `GARDEN_API_COOLDOWN_SECS=0` (keeps those focused on the mirror marker, and avoids a real-clock cross-tick interaction in the H1c expiry step).
- Added **H1d** covering both new directions: (a) a primary-quota hit arms the shared marker tagged `mirror-closer:primary-quota`; (b) an already-active shared cooldown skips the tick with **zero** upstream state calls and the expected diagnostic.
- Hermetic suite: **59 passed, 0 failed.**

**Note / process correction:** I initially applied the edits to the deployed garden root by absolute path instead of my worktree. I caught it, relocated the edits into the worktree, and restored the deployed-root files to pristine `HEAD` content (verified clean) — no git command was ever run in the deployed root, and its working tree is unmodified.

**Follow-ups:** None. The real-gh E2E (Part 2) was not re-run — it exercises only the close path, which this change does not touch, and running it churns a live GitHub repo and consumes quota; the quota/cooldown paths are fully covered hermetically.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-mirror-closer-shared-quota-cooldown.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (3268502 cached reads)
- Output: 27149 tokens
- Cost: $3.235679
- Wall-clock: 411s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
