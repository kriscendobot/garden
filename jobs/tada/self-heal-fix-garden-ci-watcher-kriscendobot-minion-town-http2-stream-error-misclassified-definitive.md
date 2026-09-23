Done.

## Completion report

**Job:** Fix the garden-ci-watcher HTTP/2 stream-reset misclassification (definitive → transient).

**What I did**
- Extended `GARDEN_TRANSIENT_GH_API_SIGNATURES` (`scripts/jobs/common.sh`, the **gh-api set only**, never `GARDEN_OFFLINE_SIGNATURES`) with the Go `net/http2` stream-reset class: `stream error: stream ID [0-9]+`, `http2: (server sent GOAWAY|client connection (lost|force closed))`, and `INTERNAL_ERROR`.
- Extended the block comment above the assignment with this **third occurrence** (date 2026-08-14 08:04:32, unit garden-ci-watcher@kriscendobot-minion.town, the exact `stream error: stream ID 1; CANCEL; received from peer` stderr and the `ci-watcher.sh` FATAL), matching the existing #3137 and agoric-sdk#11031 entries, so the next reader sees the pattern.
- Added regression cases to `scripts/jobs/test/gh-api-retry-test.sh`: a SUBTEST-1 classifier assertion on the exact minion.town stderr (plus GOAWAY / client-connection-lost / INTERNAL_ERROR variants) and a SUBTEST-2 end-to-end case proving `gh_api_retry` retries the stream reset and recovers.

**Verification**
- Confirmed both degrade gates now classify the exact stderr transient: `_gh_api_stderr_is_transient` and `is_transient_gh_source_error`.
- Confirmed the new Go-only wording did **not** leak into `GARDEN_OFFLINE_SIGNATURES`.
- Full test suite: **46 passed, 0 failed**; `bash -n` clean.

**Merge note:** the branch had advanced with a concurrent `HTTP 401|Bad credentials` transient-token-rotation fix touching the same signature line. I resolved the rebase conflict by keeping both — the merged signature carries the 401 terms and the http2 terms, and the merged comment carries both rationale paragraphs. The concurrent 401 test change (401 now asserted transient) auto-merged cleanly alongside my additions.

**Pushed** to `main2` as `0e94728324`. No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-ci-watcher-kriscendobot-minion-town-http2-stream-error-misclassified-definitive.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (898829 cached reads)
- Output: 9443 tokens
- Cost: $1.2434095
- Wall-clock: 165s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
