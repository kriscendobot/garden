---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
In `scripts/jobs/comment-latency-watch.sh`, `write_stats()` (around lines 340-354) computes `values` (line 346) and `last_ack` (line 350) by globbing `"$sample_dir"/*` directly into `awk`. When `$sample_dir` exists but is empty (no sample files — a repo with a live comment source but no recent latency samples, or every sample aged out by the pruning loop just above), the unmatched glob is passed to `awk` literally, `awk` fails to open the nonexistent path and exits 2, and `set -o pipefail` + `set -e` (line 3) propagate that 2 straight out of the script with no stderr visible (it's redirected to `/dev/null`). Reproduced live: the service crashed at exactly this line for `kriscendobot/garden`, rc=2, zero error text in the captured log — matching the self-heal capture. Fix both glob usages so an empty `$sample_dir` is handled without invoking `awk` on a non-matching glob — e.g. loop over `"$sample_dir"/*` guarded by `[ -f "$sample" ]` (mirroring the existing guard at line 340) and feed real files into `awk`/`sort`, or enable `nullglob` locally for this function. Add a regression test (`scripts/jobs/test/comment-latency-watch-test.sh`, extended today in `987bb13b9b`) covering an `ACTIVE_SLUGS` repo whose sample directory exists but is empty.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-24T00:34:43Z
