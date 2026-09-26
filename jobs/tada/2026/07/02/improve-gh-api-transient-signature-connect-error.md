Done.

## Completion report

**Job:** `improve-gh-api-transient-signature-connect-error`

**What I did:** Added gh's transport-failure top-line wording to the transient classifiers in `scripts/jobs/common.sh` so a network blip is retried rather than failing definitive.

**What changed:** Appended `error connecting to` and `check your internet connection` to the `GARDEN_OFFLINE_SIGNATURES` alternation (line ~732), plus a comment block documenting why these gh top-line phrasings are covered (they appear when the underlying dial-tcp/no-such-host cause line is absent). Placing them in `GARDEN_OFFLINE_SIGNATURES` (not just the gh-api set) means they flow into both `_gh_api_stderr_is_transient` (fixing the `garden-mirror-closer` FATAL / DEFINITIVE misclassification) and the git-transport offline path, and also quiets the ci-watcher "rollup unreadable (rc=1) — skipping" churn on the same wording.

**Verification:** Sourced the file and ran `_fetch_stderr_is_offline` and `_gh_api_stderr_is_transient` against the reported strings — `error connecting to api.github.com` and the `check your internet connection` hint both now classify offline-OK and gh-transient-OK; the pre-existing `no such host` (gh-transient-only) is unchanged.

**Delivery:** Committed with explicit pathspec in the isolated worktree off origin/main2; pushed via rebase CAS loop (`4e6e274f3..cc6a6b282` → main2).

**Follow-ups:** None.
