Inbox empty. Work is complete.

---

## Completion report

**Job:** `improve-fetch-source-wayback-cdx-fallback` — add a deterministic CDX fallback to `scripts/jobs/fetch-source.sh` for when the Wayback availability API rate-limits.

**What I did**

Added a bounded CDX-index timestamp fallback to the Internet-Archive stage (step 3) of `fetch-source.sh`. Previously, when the availability API failed (rate-limit HTTP 429 → `curl -f` failure), the script fell straight through to the bare `web/2id_/<url>` redirect form with *no recorded capture timestamp*. Now, when availability yields no timestamp for any reason (rate-limited, unreachable, or an empty snapshot set), the script queries the CDX index and, on success, fetches that capture's `id_` original bytes with a concrete recorded timestamp.

**What changed**

- `scripts/jobs/fetch-source.sh`:
  - New step **3a′**: a CDX query `http://<CDX_HOST>/cdx/search/cdx?url=…&output=json&fl=timestamp&filter=statuscode:200&limit=-1`. Bounded on both axes — `filter=statuscode:200` skips error/redirect captures, `fl=timestamp` returns only the 14-digit stamp, `limit=-1` returns the single most-recent matching row → one line, deterministic pick (same URL → same newest 200-capture). jq reads the one data row after the CDX header row; a header-only response yields empty and degrades to the existing bare-redirect form.
  - New manifest field `source_wayback_timestamp_source=availability|cdx` for provenance (emitted only when a timestamp was resolved).
  - New config `FETCH_SOURCE_CDX_HOST` (default `web.archive.org`; the CDX endpoint lives on a different host than the availability API's `archive.org`).
  - curl/jq errors surfaced to the log, never swallowed (consistent with the existing "missing-tool" discipline). `set -u` safety: `wayback_ts_source` declared at top level.
  - Header docblock (WHAT IT DOES step 3, output manifest, CONFIG) updated.
- `scripts/jobs/test/fetch-source-test.sh`: added a `/cdx/search/cdx` stub endpoint (ordered before the generic `web.archive.org` archive-fetch case, since CDX shares that host), `STUB_CDX_RC`/`STUB_CDX_JSON` drivers, a `source_wayback_timestamp_source=availability` assertion on the existing availability case, and three new cases — **20** (availability rate-limited → CDX timestamp → `id_` fetch, `source=cdx`), **21** (empty availability snapshot → CDX, proving the trigger isn't rate-limit-only), **22** (both indexes empty → graceful bare `2id_` redirect, no timestamp/source emitted).

**Verification (real execution)**

- `bash scripts/jobs/test/fetch-source-test.sh` → **80 passed, 0 failed** (was 62; +18 assertions across the augmented case 2 and new cases 20–22).
- `shellcheck -x scripts/jobs/fetch-source.sh` → clean (only the pre-existing benign SC1091 "can't follow common.sh" info).
- Committed and pushed to `main2` (`1a26d38f80`, fast-forward from `a6f29c315f`).

**Follow-ups:** none required. The fallback is purely additive — existing availability-hit and total-failure paths are unchanged. Note: the CDX request interpolates the URL raw (no percent-encoding), matching the existing availability-API query's behavior; if a future change adds URL-encoding it should cover both call sites together.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-fetch-source-wayback-cdx-fallback.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1841043 cached reads)
- Output: 18063 tokens
- Cost: $2.1597685000000006
- Wall-clock: 243s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
