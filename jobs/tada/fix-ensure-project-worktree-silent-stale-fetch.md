Inbox is empty. Job complete.

---

**Completion report**

**What the job asked:** `scripts/jobs/ensure-project-worktree.sh` fetched the requested branch with `... 2>/dev/null || true`, swallowing every failure — so a transient network/auth blip silently delivered a worktree at a *stale* local ref (observed 2026-07-06: endo-but-for-bots@llm handed over 8 weeks stale at `68246ad9` while `origin/llm` was `11322892`).

**What I changed:**
- `scripts/jobs/ensure-project-worktree.sh` — after the branch fetch, the helper now looks up the authoritative remote tip with `git ls-remote origin refs/heads/$branch` (itself retried once past a blip). When the branch exists upstream and the local `refs/heads/$branch` doesn't match that tip, it emits a prominent `<4> WARN` naming both SHAs, retries the fetch once, and if still divergent **dies** (`<3> FATAL`, exit 1) rather than handing a gardener a stale tree. The legitimate no-op case — a detached ref/sha that exists on neither side — is preserved (guard is skipped when the remote doesn't advertise the branch).
- `scripts/jobs/test/project-worktree-isolation-test.sh` — added a hermetic regression (section 6): it advances the upstream tip but deletes that commit's objects, so `ls-remote` still advertises the new SHA while a `fetch` of it fails (the exact transient shape), then asserts the helper refuses instead of delivering the stale local ref.

**Verification:** `bash -n` clean; shellcheck clean (only the pre-existing SC1091 info on the sourced `common.sh`). The isolation test passes 14/14 (was 12, +2 new). A manual reproduction confirmed the die path fires at the staleness guard (WARN → retry → FATAL naming both SHAs), not incidentally at `worktree add`.

**Push:** committed with explicit pathspecs and pushed `HEAD:main2` via a rebase CAS loop — landed first attempt (`8aab4e459..5df0a675d`).

**Follow-ups:** none. Degraded-but-acceptable edge (retained by design): if the `ls-remote` lookup *itself* fails transiently on both tries, the guard can't know the remote has the branch and falls through to the prior no-op behavior — strictly no worse than before, and the far more common single-sided fetch failure is now caught.
