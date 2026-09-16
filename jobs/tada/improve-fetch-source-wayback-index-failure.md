Done. Work committed and pushed to `main2`; all tests green.

## Completion report

**Job:** `improve-fetch-source-wayback-index-failure` — make `scripts/jobs/fetch-source.sh` stop falling through to the bare `2id_` Wayback redirect when both index lookups fail, and instead emit a distinct retryable index-unreachable result.

**What I did**
- **`scripts/jobs/fetch-source.sh`**: The archive fallback now tracks, per index, whether each lookup was *unreachable* (a curl error — 429/503/timeout) versus an *authoritative empty answer* (a 200 with an empty snapshot set). When no capture timestamp is resolved **and both** the availability and CDX lookups were unreachable, it no longer hits the `2id_` redirect. It writes no bytes, prints a distinct diagnostic manifest, and exits **3**:
  - `source_fetched_via=index-unreachable`, `source_index_unreachable=true`, `source_retryable=true`, plus per-index `source_availability_curl_rc` / `source_cdx_curl_rc`.
  - The `2id_` degradation is preserved for the case where at least one index gave an authoritative "nothing captured" answer (unchanged behavior).
  - Updated the header docs (WHAT IT DOES step 3, manifest field list, EXIT CODES with the new code 3) and the 3b comment.
- **`scripts/jobs/test/fetch-source-test.sh`**: Added CASE 25 (both indexes unreachable → exit 3, no redirect contacted, diagnostics preserved, no hash, no leftover file) and CASE 26 (one authoritative-empty + one unreachable → still uses the `2id_` redirect, exit 0). Suite: **102 passed, 0 failed**.
- **`roles/scholar/AGENT.md`**: Noted the retryable `index-unreachable` / exit-3 semantics so scholars treat it as *retry later*, not a dead source, and don't hand-retry a known-dead lookup.

**Verification**
- `fetch-source-test.sh`: 102/102 pass.
- `check-source-children-test.sh` (the downstream consumer): 22/22 pass — it treats any non-zero exit as "unreachable", so exit 3 is safe for boolean callers.
- shellcheck clean (only the pre-existing SC1091 info for the `common.sh` source directive).

**Exit-code contract note:** exit 3 is new but non-breaking — the only programmatic consumer (`check-source-children.sh`) checks zero/non-zero only. Direct scholar callers now get a machine-readable retryable signal distinct from exit 1 (genuine no-bytes).

No follow-ups required.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-fetch-source-wayback-index-failure.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1962702 cached reads)
- Output: 18818 tokens
- Cost: $2.286278
- Wall-clock: 253s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
