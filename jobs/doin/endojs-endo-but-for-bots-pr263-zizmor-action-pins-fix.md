---
role: fixer
---

Fix the failing `zizmor` check on endojs/endo-but-for-bots PR #263 ("feat(ses): permit URL and URLSearchParams as universal intrinsics", branch `feat/hardened-url-shim`, base `master`): sync the branch's `.github/workflows/*` action pins/version comments to match `master` (zizmor is green on other current PRs, so the mismatch is branch-local, not repo-wide as an earlier shepherd assumed), pushing until the check rollup is fully green so this final M2 shim PR is merge-ready.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 6
  worker_kind: cleric
  claimed_at: 2026-07-16T17:02:20Z
