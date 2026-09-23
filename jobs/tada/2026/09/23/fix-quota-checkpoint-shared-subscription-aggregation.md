All work complete. Here's my report.

---

## Completion report: fix-quota-checkpoint-shared-subscription-aggregation

**What was wrong:** `append-quota-checkpoint.sh` read exactly one host's live contribution (`budget/live/<sub>/$GARDEN`, else the first file found). For the *shared* `codex-endolin` subscription (drawn down by both `endolin-garden` and `endolin-garden2`), a checkpoint on garden2 paired the maintainer's 64% with garden2's 3,044,024 tokens alone, deriving `implied_weekly_cap_tokens` of 4,756,288 instead of ~33.6M. The 2026-09-22 61% row had the same flaw.

**Code changes (main2, commit `48ee7a2be59`):**
1. **`append-quota-checkpoint.sh`** — new `aggregate_live()` sums `spend` across every `budget/live/<sub>/*` host sharing the *freshest* sample's `window_start_epoch`. A host on a different/stale window is **excluded and noted**, never summed. It records an auditable **`meter_hosts`** array (`{host, spend, window_start_epoch, sampled_at, included, excluded_reason?}`), pairs against the **oldest included sample** (conservative `meter_sampled_at`), and **lowers confidence one notch** (`downgrade_confidence()`) when host samples span >900s. A single-host subscription and `--host-file` (tests) behave byte-for-byte as before (no `meter_hosts`).
2. **`fit-quota-calibration.sh`** — an index-aware pre-filter drops any row whose `checked_at` is named by *another* row's `supersedes`, so a correction that reuses the original's `checked_at` replaces it rather than both polluting the fit.
3. **Tests** — added three cases (all 11 pass): two-hosts-plus-one-mismatched-window aggregation (asserts summed spend 1500 and implied cap 5000, host-c excluded), single-host byte-compatibility, and supersession (a superseding row with reused `checked_at` drops the outlier so it never governs).

**Data correction (journal2, commit `98eb354a`)** — log kept append-only; appended two superseding rows to `budget/manual-checkpoints/codex-endolin.jsonl` and documented the `meter_hosts`/`supersedes` schema in that dir's README. Aggregate spend recovered from `budget-live(...)` history (2026-09-22 pre-truncation data recovered from a scholar-staging journal clone):
- **64% @ 2026-09-23T16:17:18Z**: aggregate 21,510,425 → **implied weekly cap 33,610,039** (was 4,756,288), confidence medium.
- **61% @ 2026-09-22T20:33:59Z**: aggregate 20,323,298 (leader 17,778,930 + garden2's best-available preceding sample 2,544,368, ~4h20m stale) → **implied cap 33,316,882** (was 29,145,787), confidence low. The two corrected caps cross-check at ~33.3–33.6M.

**Corrected implied weekly cap for codex-endolin: ~33.6M** (33,610,039 at the freshest 64% reading).

**fit-quota-calibration changes needed:** yes — it did not previously honor supersession, so without the new filter both bad rows would still enter the fit; the supersede-drop was added.

**Follow-ups:** garden2 metered infrequently the evening of 2026-09-22 (sparse `budget/live` samples), so the row-2 garden2 contribution is a stale nearest-preceding sample rather than a coincident one; this is noted in the row and reflected in its `low` confidence. No code follow-up required.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-quota-checkpoint-shared-subscription-aggregation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 118 tokens (6331202 cached reads)
- Output: 66900 tokens
- Cost: $6.267160999999997
- Wall-clock: 1037s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
