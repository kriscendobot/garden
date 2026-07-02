Empty inbox. The work is complete and pushed to `origin/main2`.

## Completion report

**Job:** Add a deterministic host-identity drift detector so a regression of the `endolinbot2`-class `GARDEN` drift surfaces loudly on tick 1 instead of silently mislabeling the whole gardener pool and disabling the leader gate.

**What I did:**
- **Added `scripts/jobs/identity-drift-guard.sh`** — a deterministic, no-LLM guard. When resolved `$GARDEN` ≠ `hostname -s` AND there is no matching recorded parallel-pool override (`GARDEN_IDENTITY_OVERRIDE` env or `$GARDEN_STATE/identity-override` file, the same contract `gardener.sh` honors at spawn), it posts **one loud `kind:error` journal entry** via `journal-entry.sh`. The entry names the drifted `GARDEN`, the real hostname, the likely source (`$GARDEN_ROOT/.garden`), the fix, and — on the leader path — surfaces that `is-main-host` reports **follower** (comparing the `leader` marker against the drifted identity), i.e. leader-only singletons are being skipped on the true leader host.
- **Deduped per drift state** via a `$GARDEN_STATE/identity-drift-reported` marker: fires on tick 1 of a regression, stays quiet on identical ticks, clears when the drift resolves so a *re-drift* fires again. Avoids spamming the append-only journal every tick.
- **Wired it into `gardener-scaler.sh` as a host-level preflight** that runs every tick, independent of the `hosts/<host>` size signal (so it fires even when that signal is structurally missing) and independent of `reconcile-identity` (which cannot catch a uniform `.garden`-file override — all workers resolve the same drifted value consistently, producing no `/proc`-vs-resolved inconsistency).
- **Added `tests/checks/test_identity_drift_guard.sh`** (14 assertions, all pass): clean identity → no emit; unrecorded drift → emits with leader/follower body; dedup across ticks; both override forms silence it; clear-then-re-drift re-emits; scaler wiring present.

**Verification:** New suite passes (14/14). Full `tests/checks/run.sh` shows the same 2 pre-existing failures (`test_maintainer_inbox_information_hiding`, `test_run_all`) on the clean base — both unrelated sandbox issues (inbox-allowlist scrub; a `claude` stub not invoked in this environment); the inventory-drift check passes. Shellcheck: only benign `SC1091`/`SC2034` matching every other script's `common.sh`/`GARDEN_TAG` convention.

**Follow-ups (out of a gardener's autonomous scope, per the job body):** the *live* `.garden=endolinbot2` regression on the deployed root is an operational fix being surfaced to the maintainer separately; this job delivered the detector, not that fix. A noted upstream follow-up (from `common.sh`) remains open: making `reconcile-identity` read the `gardener.sh` child's environ rather than the wrapper's — orthogonal to this guard.

Committed and pushed to `main2` (`origin/main2` @ `9a882e3bc`).
