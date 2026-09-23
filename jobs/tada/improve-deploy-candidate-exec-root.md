Pushed to main2.

## Completion report

**Job:** `scripts/jobs/deploy-garden.sh` — remember an exec-capable candidate-gate temporary root and skip a previously rejected noexec TMPDIR on later ticks, while retaining fallback and re-probing if the cached root fails.

**Problem.** `prepare_candidate_gate_root` probed `TMPDIR` (`/tmp`) first on *every* deploy tick. On a host where `/tmp` is mounted noexec, that base was rejected each tick with a `WARN` before falling back to the exec-capable `$GARDEN_SCRATCH/tmpexec` — routine per-tick warning noise despite a perfectly usable fallback.

**Change (`scripts/jobs/deploy-garden.sh`):**
- Added `GARDEN_DEPLOY_GATE_BASE_CACHE` (default `$GARDEN_DEPLOY_STATE/candidate-gate-base`) — host-standing, uncommitted state alongside `deployed-sha`.
- Extracted the per-base probe into `try_candidate_gate_base <base>` (shared by both paths) and added `remember_candidate_gate_base` (writes only on change).
- `prepare_candidate_gate_root` now first tries the remembered base alone; on success it returns without ever touching (or re-warning about) the noexec `/tmp`. If the remembered base fails its probe, it logs a `no longer usable; re-probing` WARN and runs the full ordered re-probe of every base — so the fallback path is fully retained and the gate never wedges on a stale cache. On any full-probe success the winning base is cached.

**Tests (`scripts/jobs/test/deploy-garden-test.sh`):** added 8 assertions to the noexec section — the fallback base is remembered; a second tick reuses it and the noexec TMPDIR is *not* re-probed (no warning); a stale cache triggers a full re-probe that recovers the scratch fallback and refreshes the cache. Full suite: **126 passed, 0 failed.** No new shellcheck findings (only pre-existing info-level notes).

Behavior is unchanged on the first tick and on exec-capable-`/tmp` hosts (the cache simply records `/tmp` and the fast path selects it). No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-deploy-candidate-exec-root.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1209109 cached reads)
- Output: 14434 tokens
- Cost: $1.6421035
- Wall-clock: 231s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
