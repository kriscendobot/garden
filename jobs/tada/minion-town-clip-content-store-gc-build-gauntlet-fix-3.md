Fix round 3 complete. CI is green.

## Completion report

**PR:** kriscendobot/minion.town#93 (clip content-store GC, Part B) — gauntlet FIX round 3.

Applied the round-3 panel's must-fix items and pushed as review-feedback follow-up commit `957036a` on `feat/clip-content-store-gc`.

**Code fixes:**
1. **Refuse to sweep past an unresolved live root** (must-fix 1) — `runGc` now throws *before any deletion* when `remove` is set and there are unresolved live roots with no powers plane (the design's central Part-B invariant). Audit mode still reports them.
2. **`inventoryBlobs` ENOENT tolerance** (must-fix 2) — both the per-blob `lstat` and the manifest-inspection `readFile` skip a vanished entry, so a concurrent publish (tmp-then-rename) racing `readdir` no longer aborts even a read-only audit.
3. **`--store-dir` rejects a flag-shaped value** (must-fix 3) — `--store-dir --delete` no longer silently audits a nonexistent path.
4. **`primaryWorkerName` fallback pinned by tests** (must-fix 4) — added a non-`Error` rejection test and a non-boolean-truthy `has()` test, both asserting fallback to `MAIN`.
5. **`--drop-unresolved` excision tightened + race-tolerant** (must-fix 5) — only `resolved === undefined` is confirmed-dead; ambiguous non-empty resolutions route through the fail-closed throw, and the excision rename tolerates `ENOENT`.
- Cheap should-fixes: `locksmith` comment wording (names the `"front"` facet), `typist` ASCII arrow, DEPLOYMENT.md runbook generalization (dropped baked fixture blob id + per-build status; fixed a continuation-line indent).

**Non-code must-fix items:**
- **#7** (missing round-1 fix-push summary) — posted a top-level summary comment covering both round 1 and round 3 (head SHA, changed vs. deferred, verification status).
- **#6** (duplicate strand #92/#93/#83) — a maintainer decision; surfaced to the maintainer via the message bus. It remains a blocking panel finding no code change can clear.

**Verification:** `npm run typecheck` clean; full `npm test` green (368 passed, 5 skipped); added tests all pass. CI on the pushed commit: **GREEN** (rc 0).

**Deferred should-fixes** (not in this push): #8 extract triplicated vhost-record parser; #9 widen `readVhostRecordStrict` retry to raw read errors; #10 persisted worker-name for `removeDirectory`; #11 bound `evaluateRegister` under `graceMs`; #12 size-cap the settled `contentRoot` read.

**Follow-up:** maintainer must arbitrate the #92/#93/#83 duplicate strand before merge.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-clip-content-store-gc-build-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 102 tokens (4388961 cached reads)
- Output: 27272 tokens
- Cost: $3.9427905
- Wall-clock: 482s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
