Fix stage complete. CI is green.

## Completion report

**Stage:** FIX round 3 of the `minion-town-formula-graph-content-gc-gauntlet` on kriscendobot/minion.town PR #83 (clip content-store GC). Applied the round-3 panel's must-fix items once, pushed as a review-feedback follow-up commit (`6c8318a`), and watched CI to green.

**Must-fix items applied (17 request-changes seats consolidated):**

- **Prototype-key mark-set hole** (spec-keeper, warden, wire-watcher): `parseManifest`/`buildManifest` now build `paths` on `Object.create(null)`, so a `__proto__` manifest key can't land as the object's prototype — served-but-unmarked content that an armed sweep would delete.
- **Absent-`vhosts/` full-CAS wipe** (breaker, corner-prober, purist, prover): `runContentGc` fails closed when the root set is empty over a non-empty store *and* `vhosts/` is absent; an empty-but-present `vhosts/` (all clips unpublished) stays collectable.
- **Grace-window coercion** (saboteur, corner-prober, fast-checker, assessor): the CLI parser trims, treats whitespace-only as absent, and rejects hex/exponent/signed/`0`/non-numeric values (never a silent `Number()` disarm); it also rejects unrecognized arguments (typos, the space-separated `--min-age-ms 5000` form).
- **CAS temp-sibling race + best-effort refresh** (assessor, spec-keeper, breaker, purist, migrator): the intern temp name is now unique per writer (pid + `randomUUID`); the mtime-refresh fallback is best-effort so a dedup hit can't become a new publish failure.
- **Stylist renames**: `minAgeMs`→`minimumAgeMs`, `DEFAULT_MINIMUM_AGE_MS`, `requestPath`, `human`→`formatBytes`.
- **Unit hardening** (breaker, surfacer): `SupplementaryGroups=endo-weblet-store`; `ReadWritePaths` attenuated to `blobs/` so a mark-set bug can't unlink into the `vhosts/` root set.
- **Docs** (surfacer, benchmarker, integrator, scribe, migrator): documented `--json`; corrected grace-window rules; removed the `manifestMiss` contradiction; stated the timing-margin basis (conservative bound, not a measured p99); added the #85/#88 reconciliation; recorded the tmp-orphan / re-intern-on-vanish / upgrade-re-projection follow-ups; refreshed the stale PR description.

**Tests:** +8 cases (19→27) covering the `__proto__` mark, absent/unreadable/empty `vhosts/`, the mutation-site re-stat skip (injected clock — pins prover's non-load-bearing finding), and the CLI grace-window/unknown-arg rejections. Full suite: 326 passed / 5 skipped; `tsc` clean.

**CI:** GREEN (`ci-wait-merge` rc 0).

**Deliberately deferred (should-fix/comment, recorded in design § 7, not blocking):** aborted `.tmp-*` sweep, publish-side re-intern-on-vanish, and the upgrade root-set re-projection precondition — each named as a follow-up rather than built, per scope.

The PR remains draft (integrator flagged not to un-draft ahead of #88); the driver re-posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-formula-graph-content-gc-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 130 tokens (8198067 cached reads)
- Output: 56988 tokens
- Cost: $7.148827500000001
- Wall-clock: 878s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
