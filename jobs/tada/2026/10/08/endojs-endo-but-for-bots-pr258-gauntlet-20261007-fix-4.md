I applied the panel-4 must-fix to endojs/endo-but-for-bots PR #258, pushed it, and CI came back green on all 16 checks.

**What changed:** one review-feedback commit, `1e2312f8d7`, on top of `91f69ecd6a` in `.github/workflows/ocapn-guile-interop.yml`. It removes 63 lines and adds 44.

- **Must-fix (decomplector):** the workflow no longer checks the store cache's integrity itself, because `actions/cache` already does that.
  - The staging tarball is now written uncompressed (`store.tar`), so `actions/cache`'s own compression and integrity checks cover it.
  - Removed `zstd -t`, the `discard()` helper, `gh cache delete` and its `GH_TOKEN`/`GH_REPO`/`CACHE_KEY` env.
  - Removed the job-level `actions: write` permission; the job token is back to `contents: read` only.
  - A missing or empty archive is still treated as a cache miss.
- **Should-fix (decomplector):** the cache key is now built from `GUIX_VERSION` and `GUIX_GUILE_PACKAGES` instead of `hashFiles(<workflow file>)`, and the `hashFiles != ''` guard is gone. Unrelated edits to the workflow file no longer throw the cache away.
- **Cheap should-fixes from other seats:**
  - wire-watcher / ergonomist: the root extract now only writes `gnu/store` and `var/guix/db`.
  - saboteur: the snapshot `tar` is capped by `timeout 900s`.
  - The "content-addressed" comment is corrected, since Guix store paths are input-addressed.
  - Comments now say the size cap is measured uncompressed. The previous snapshot was about 243 MB compressed, far below the 4 GB cap.
- **Lint:** `actionlint` reports the same 5 shellcheck notes before and after the change, all in steps this commit doesn't touch.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0 (16 checks, none failed). The OCapN Guile interop run on the new head (37778769038) succeeded. I couldn't check whether that run hit or missed the cache, or whether the save worked, because the GitHub API rate limit ran out.

**Follow-ups and accepted trade-offs:**
- With the self-healing gone, nothing deletes a bad cache entry. If an entry restores but always fails to extract (for example from running out of disk), every run with that key will fail until the Guix version or package set changes. The decomplector argued that case can't happen. The saboteur and wire-watcher seats still flagged eviction on `tar` failure as a should-fix, so panel-5 may raise it again.
- The workflow still never runs the failure path. The coverage seat's request for a run that exercises it is not addressed.
- The PR body could add a sentence on why `guix archive --export/--import` was rejected (decomplector, comment-only). I didn't edit the PR body.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr258-gauntlet-20261007-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1331050 cached reads)
- Output: 10225 tokens
- Cost: $1.031462
- Wall-clock: 615s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
