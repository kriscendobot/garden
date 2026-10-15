Fix round 3 for kriscendobot/minion.town PR #190 is pushed and CI is green. The PR head moved from `45bc4b8` to `2290d9d`, and all three checks pass: `test`, `Claude harness (amd64)` and `Claude harness (arm64)`.

**Panel round-3 must-fix items fixed (two follow-up commits):**

1. **`4689f69` fix(gateway): a bad saved-order file no longer breaks clip listing.** Raised by the assessor, saboteur, breaker, engine-realist, purist and corner-prober.
   - In `src/endo/gateway/clip-order.ts`, `listing` now catches a failed order-file read, logs a warning, and lists clips in the default order at revision 0. `/account/clips` and MCP `listSites` no longer fail because of a bad order file.
   - A file that can't be parsed (empty, `null`, invalid JSON, wrong owner or wrong shape) now throws a new `MalformedClipOrderError` that names the file. Previously it threw an error that didn't say which file.
   - A save now treats a corrupt order file as "no saved order", so a save at revision 0 replaces it and the owner is no longer locked out. Other read errors still fail the save.
   - Removed the citation to `designs/clip-gateway.md`, which doesn't exist (archivist).
   - New tests: the error names the file; listing falls back to the default order when the read fails; a revision-0 save replaces a corrupt file.

2. **`2290d9d` fix(shell): fixes to the conflict-recovery path in `deploy/aws/www/shell.js`.**
   - **A stale tab can no longer overwrite a newer order** (archivist, breaker, saboteur, corner-prober, engine-realist). `createOrderSaver` takes a new `discardQueued` callback. The gutter uses it to drop the queued order when the in-flight save gets a 409, so that order is never sent under the revision just adopted from the refresh. The docs already promised this, so their wording now matches the code.
   - **A failed refresh after a 409 no longer empties the gutter** (corner-prober, assessor, engine-realist). `makeClipSource` has a new `refresh()` that returns `undefined` on failure, and the conflict handler only replaces the clips when the refresh succeeds. `load()` still returns `[]` on failure.
   - Alt+Arrow at the edge of the gutter now calls `preventDefault`, so Alt+Left no longer sends the browser back (saboteur). I also removed the JSDoc on `save` that only repeated its signature (pruner).
   - New tests: a queued order is dropped on a conflict; a failed refresh is reported differently from an empty listing.

**Checks:** the targeted suites passed (50 tests). The wider gateway, shell and guest-self/publish suites passed 289 tests across 21 files, and `tsc` typecheck is clean.

**Not done (should-fix and comment-only items):**
- The integrator asked for the commit history to be rewritten so the dropped DynamoDB/IAM approach doesn't reach `main`.
- The purist asked to take `ClipOrderFacet` off the guest's `@sites` facet and to remove the overlap between `list` and `listing`.
- The integrator noted that the `order` field on `ClipRecord` in the design doc no longer matches what is stored.
- The pruner's prose cuts to the PR body, DEPLOYMENT.md and test comments.
- No `fsync` before the rename when writing the order file.
- Not yet documented that saves are only serialized within a single server process.
- Saves are still possible before the first listing has loaded.
- Orders longer than 1000 clips still fail with only a console warning.

Panel round 4 should decide whether any of these block the PR.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr190-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (2055115 cached reads)
- Output: 12941 tokens
- Cost: $1.380419
- Wall-clock: 1451s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
