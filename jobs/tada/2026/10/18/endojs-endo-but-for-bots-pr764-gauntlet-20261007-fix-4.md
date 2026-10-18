# Fix round 4 for endojs/endo-but-for-bots#764: done, CI green

I made the panel-4 fixes, pushed them as `b74750e2c` to `mirror/endo-2780-cache-globals` (a follow-up commit on top of `5525a25d6`), and CI passed: `ci-wait-merge.sh` returned rc 0 with 15 of 15 checks green and none failed.

## Fixes from the round-4 verdict (review 5564152291; there was no pre-pass block)

- **Changeset missing `Function`** (archivist and changeset-auditor): `.changeset/cache-compartment-mapper-intrinsics.md` now lists `Function` among the globals the code no longer depends on.
- **`Set` test never ran the hooks** (breaker): the test is renamed to "import hooks ignore replaced Map and Set" and now calls both the async import hook and the synchronous import-now hook while `Map` and `Set` are poisoned. Each call is for a compartment the hook hasn't seen and a missing external module, which reaches the `new Set()` that only runs on first use. The parser is marked synchronous so the import-now path actually runs. I checked that the test catches the regression: with `Set` removed from the captured globals in `src/import-hook.js`, it fails with "ambient Set used after module initialization".
- **Failed read, then a queued read** (corner-prober): a new test starts a read of a missing file, then a real read, while `Promise` is poisoned. The first read fails with ENOENT and the queued second read still succeeds, so the read lock is released after a failure.

Checks run locally: `cached-intrinsics.test.js` passes 9 of 9 under both AVA configs, and eslint and prettier are clean on the changed files.

## Not done

- **History cleanup** (packager and integrator, should-fix): they asked to squash the `fixup!` commits and collapse the CI commit that was added, reverted and reapplied. This stage only adds commits on top, so I didn't rewrite history. A retcon or cleanup step before merge should do it.
- **Property-based test for URL conversion** (fast-checker, follow-up): it would need `fast-check` added as a dev dependency, so I left it out.
- **Top-level summary comment** (scribe, summary-fix): not posted, since that falls to the completion stage.
- **Coverage** (coverage-auditor): it couldn't check new-line coverage because no c8 report was available. That's a missing report on the reviewer's side, not a problem in the code.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr764-gauntlet-20261007-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1116256 cached reads)
- Output: 7121 tokens
- Cost: $0.8771752
- Wall-clock: 733s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
