Inbox empty. Work complete.

---

## Completion report

**Job:** `self-heal-fix-garden-mirror-closer-gh-api-go-net-timeout-signatures`

**Root cause:** `gh` runs on Go's `net/http` stack, which surfaces transient dial/TLS timeouts with wording git's curl/SSH transport never emits. The 2026-06-29 21:14:03 crash signature `dial tcp 140.82.116.5:443: i/o timeout` matched none of `GARDEN_TRANSIENT_GH_API_SIGNATURES`, so `_gh_api_stderr_is_transient` returned 1, `gh_api_retry` broke without retrying, and garden-mirror-closer exited 1 (systemd Failed) on a self-healing blip.

**What I changed** (both in `scripts/jobs/`, committed `0139625cc`, pushed to `origin/main2`):

1. **`common.sh:782`** — extended `GARDEN_TRANSIENT_GH_API_SIGNATURES` with the canonical Go transient strings: `i/o timeout`, `dial tcp`, `context deadline exceeded`, `net/http: TLS handshake timeout`, `no such host`, `server misbehaving`, and word-bounded `\bEOF\b`. Added to the **gh-api set only** — `GARDEN_OFFLINE_SIGNATURES` (line 732, git's clone/fetch transport classifier) is untouched, verified by diff. Kept the existing `${GARDEN_OFFLINE_SIGNATURES}` inheritance. Expanded the comment block (777–) to explain why Go's net stack needs distinct wording.

2. **`test/gh-api-retry-test.sh`** — added 8 regression assertions in SUBTEST 1, including the **exact #3137 crash signature** asserted transient (so it can never regress to definitive), plus a negative guard that `\bEOF\b` does not match `EOF` mid-word (`GEOFFREY`).

**Verification:**
- `gh-api-retry-test.sh`: 25 passed, 0 failed (was 17).
- `mirror-closer-test.sh`: 29 passed, 0 failed (no regression; its E2E close path still green).
- The closer no longer misclassifies a transient gh-api timeout as definitive — it now rides the bounded retry loop or skips-with-retry-next-tick rather than crashing the tick.

**Mistake caught & corrected mid-job:** I first edited the deployed garden root (`/home/kris/scripts/...`) by absolute path; I reverted those via `git checkout` and re-applied all edits in this job's worktree. The deployed root is clean.

**Follow-ups:** None. The fix is data-only (signature regex) with a pinned regression test; no behavioral change to the retry mechanism itself.
