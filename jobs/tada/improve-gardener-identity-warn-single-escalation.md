Done. Work committed and pushed to `main2` (7ac0d1da5), tests green post-rebase.

## Completion report

**Problem.** The unrecorded-GARDEN-divergence `WARN` in `scripts/jobs/gardener.sh` fired from every one of the ~100 gardeners on every spawn — ~100 identical `GARDEN=… diverges … NO recorded deliberate override` lines per wake that dominated `journalctl -p warning` and buried unrelated warnings. It never self-resolved, because the scaler's `reconcile_identity` inherits the same drifted env (its /proc-vs-resolved check sees no inconsistency when a `.garden` file makes every worker resolve the *same* drifted value).

**What I did.**
- **`scripts/jobs/gardener.sh`** — demoted the per-spawn divergence branch from a `WARN`+escalation to a single low-volume `identity:` info line (kept so one gardener's own log still shows the drift). The escalation is no longer raised on the per-spawn path.
- **`scripts/jobs/identity-drift-guard.sh`** — this is the once-per-tick, host-level gardener-scaler preflight a sibling job (commit 9a882e3bc) had already added to catch exactly this drift class. I extended it to raise **one actionable escalation per host per divergence: a `kind: error` maintainer-inbox report** (the surface the liaison's maintainer-watch Monitor and the bulletin both read), posted via `inbox-send.sh maintainer`, **plus** the existing greppable journal `kind:error` entry. Both are **deduped by the existing `$GARDEN_STATE/identity-drift-reported` marker**, so it fires on tick 1 of a regression and stays quiet until the drift changes or clears. The maintainer report gates the marker (posted first) so a failed push retries next tick rather than going silently unreported; the journal entry is best-effort so a journal-push race can't re-spam the maintainer inbox.
- **Tests** — updated `gardener-identity-test.sh` SUBTEST 2 (asserts *no* per-spawn WARN, a single info divergence line, marker still records the drifted GARDEN); added `identity-drift-guard-test.sh` (10 subtests: one maintainer report + one journal entry on drift, the `kind: error` marker, the drift-signature dedup marker, dedup on a second identical tick, and no-emission on both the recorded-override and healthy-identity paths). Both suites pass (9/9 and 10/10) before and after rebase.

**Net effect.** 100×/tick per-spawn WARN noise becomes a single, deduped, actionable maintainer-inbox escalation of a genuine host-identity config leak.

**Design note / deviation.** The job spec named `reconcile_identity` (install-units.sh) as the home for the once-per-tick detection. I placed it in the already-existing `identity-drift-guard.sh` instead, which is the correct home: `reconcile_identity` iterates per-worker units and only catches a /proc-vs-resolved inconsistency, which the consistent `.garden`-file drift does not produce (the guard's own header documents this). The guard runs as the scaler preflight immediately before `reconcile-identity` every tick, so it is the once-per-tick path in practice.

**Follow-ups.** None required.
