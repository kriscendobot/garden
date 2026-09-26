CI is GREEN (rc 0). The job is complete. Writing the report.

---

## Completion report

**Job:** Gauntlet FIX round 4 — kriscendobot/minion.town PR #93 (`feat/clip-content-store-gc`).

Applied all **six must-fix items** from the round-4 jury panel verdict (@ `957036a`), plus three cheap should-fix notes, pushed as one review-feedback follow-up commit (`957036a..fd6821a`), and watched CI to **GREEN** (rc 0).

**Must-fix applied:**
1. **`GATEWAY_GC_GRACE_MS=""` zeroing the grace period** — added `nonNegativeNumberEnv` in `config.ts`: blank/whitespace is treated as unset (defaults to 1h), non-numeric/negative fails loud instead of silently becoming `0`/`NaN`. Closes the `""`+`GATEWAY_GC_DELETE=1` "delete-immediately" hazard. New `loadGatewayConfig` coverage for empty/non-numeric/valid/negative.
2. **`readManifestStrict` unbounded read** — now stats first and refuses any manifest past `MANIFEST_INSPECTION_MAX_BYTES` (8 MiB), matching `inventoryBlobs`, so a guest-controlled live-resolved `front` can't OOM the `MemoryMax=256M` unit. Added a >8 MiB case.
3. **`unpublish` cleanup log** — warning now describes the takedown by its actual `removed` outcome instead of asserting "succeeded" on the failure path.
4. **CLI `finally { close() }`** — wrapped so a connection-close rejection no longer masks the real `runGc` error.
5. **Untested race-fixes** — regression tests for `inventoryBlobs` ENOENT tolerance (both lstat and manifest-read paths, via spies) and `internBlob`'s ENOENT-tolerant dedup-touch fallthrough (real unlink between interns). Both redden on revert.
6. **Over-broad capability grants** — `unpublish` now takes a `GuestDirectoryRemover` (`Pick<…,"removeDirectory">`) slice; content-gc consumes a new `front`-only `FrontDirectorySource` so `read(id, "back")` is a *compile* error there — powers facet statically unreachable.

**Should-fix also resolved:** grace-boundary tie test (tie → within-grace/kept), `removeDirectory` param-name drift, and the `DEPLOYMENT.md` "tracking issue" reference (now a concrete deploy-PR verification record).

**Notes:** I reverted the typist "drop `graceMs?`" note to keep `graceMs` optional — making it required cascaded into 5 unrelated test fixtures; the must-fix (empty-string handling) stands on its own. The remaining minor should-fix notes (`--drop-unresolved` no-op signal) were left as-is.

**Verification:** `npm run typecheck` clean; full `npm test` = 377 passed / 5 skipped; CI on the pushed head is GREEN.

Stopping here per the stage contract — not re-running the panel; the driver re-posts panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-clip-content-store-gc-build-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 134 tokens (5923278 cached reads)
- Output: 38823 tokens
- Cost: $5.12776
- Wall-clock: 660s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
