All deliverables are complete. Final report:

---

## Completion report: evidence-based lint-strategy decision (PR #594)

**Recommendation delivered: keep #594's serial buckets (`ESLINT_BUCKET_SIZE`=10); do not shard.** Backed by real GitHub Actions CI evidence.

### What I did
1. **Pulled real CI step/job timings** (`gh api .../actions/runs/<id>/jobs`) from existing master and #594 runs, and found the decisive fact: the `lint` job (4m33s–4m41s) is **not on the CI critical path** — the macOS `test` jobs are (390s/457s), setting overall run wall-clock at 6m34s/7m42s. Lint finishes 2–3 min before CI completes, so any eslint-step change is invisible end to end. Confirmed on two independent runs.
2. **Decomposed the lint job**: `build API docs` (~127s) is a *longer* step than the whole `yarn lint` step (103–119s). Bucketing adds +16s to the lint step (+15%) but only +8s to the job (+3%).
3. **Quantified the tsc-duplication concern** with a local single-thread sweep (labeled local): whole `eslint .` 66s; buckets 18/14/10/6 = 58/60/61/67s; per-package (53 procs) 129s. Marginal cost ~1.2–1.4s/process; duplication only bites at per-package fan-out (~2×). Buckets of 6–18 are at parity with whole-repo. #594 rebuilds the service ~6 times, not 53 — it already avoids the concern.
4. **Measured sharding with real CI** — built a standalone experiment workflow (`scripts/eslint-shard.sh` + matrix) that ran whole / serial-10 / K=4 / K=8 on identical ubuntu-latest runners in one push (run 28598791481, all green). Isolated eslint: whole 85s; serial-10 102s (+20%); **K=4 slowest-shard 75s / compute 244s**; **K=8 slowest-shard 63s / compute 379s**. A ~30s per-shard setup floor makes K=8 beat K=4 by only 12s for +55% compute, and even 63s is buried under the ~6m30s test critical path → **zero end-to-end saving, K× the runner fan-out**.

### Deliverables
- **Decision comment posted** on PR #594: https://github.com/endojs/endo-but-for-bots/pull/594#issuecomment-4868811076 (candidate table, tsc answer, recommendation).
- **Journal `result` entry**: `entries/2026/07/02/173922Z-result-gardener-a8ec96.md`.
- **Deliverable 3 not triggered** — the recommended winner *equals* #594's current serial-bucket implementation, so no alternative implementation was staged.
- **#594 left untouched**: OPEN, draft=true, MERGEABLE (not merged, not un-drafted).

### Cleanup
Experiment branch `exp/lint-shard-experiment` deleted from the bot repo; experiment worktree removed. Coverage verified identical to `eslint .` (0 errors, 5 warnings, all 53 packages incl. `where`/`zip` — local run + all shard jobs green).

### Follow-ups
- **Upstream ferry** of the master change to `endojs/endo` is left for the boatman under kriskowal credentials — **cannot originate from this host (endolinbot)**; not attempted here.
- Sent a self-improvement `message` to `liaison`: the job cited two nonexistent skills (`ci-runtime-comparison`, `benchmark-comparative-report`) worth authoring from this run's methodology.

Self-improvement: routed the missing-skills library gap to the liaison via a journal message; nothing else structural this time.
