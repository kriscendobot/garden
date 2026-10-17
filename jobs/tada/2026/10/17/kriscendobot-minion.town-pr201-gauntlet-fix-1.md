Fix round 1 on PR #201 is pushed, but CI was still pending when the 3600s deadline hit (ci-wait-merge rc 4). All three checks were `pending` (Claude harness amd64, Claude harness arm64, and `test`), so the driver needs to re-post this stage.

The PR head had already moved past the panel's reviewed commit `3e82b6b`. Commits `9935a16` and `30c73db` had already applied the main must-fix items: the `makeExo` interface guard on the clip power, removal of `acceptInvitation`, `makeApp` rollback, and the browser demo wired into CI. Both also covered the typist `@import` fix and the pruner trims. I added `b17d11d` for what was still open (`30c73db` → `b17d11d`, pushed with `safe-push-pr-head.sh`):
- **Storage limit:** a space directory now holds at most 256 names (`NEW_CLIP_MAX_DIRECTORY_ENTRIES`). It applies to `makeDirectory`, `writeText`, `importLocator` and `makeApp`; replacing an existing name still works. This answers the saboteur's point that any URL holder could fill the owner's storage.
- **Reserved names:** `__proto__`, `constructor` and `prototype` are now rejected as path names (warden).
- **Stale references:** the `model.js` comment now points at `test/new-clip.test.ts` (integrator). The non-ASCII ellipsis in the `shell.js:982` comment is replaced with `..` (typist).
- **Tests:** `test/new-clip-daemon.test.ts` now covers the reserved names and the 256-entry cap.

Locally, `tsc` is clean and `test/new-clip.test.ts` passes, 15 of 15. `test/new-clip-daemon.test.ts` skips without `ENDO_CHECKOUT`, so the new cap and reserved-name tests only run in CI.

I did not take these panel items:
- Locksmith's finding 2 (close over a one-method facet): the power already closes over the space only.
- Coverage-auditor's `c8 --all` suggestion.
- Typist's `types.d.ts` move.
- Saboteur's catch-logging and CSRF/rate-limit notes.
- Wire-watcher's extra adversarial tests and `importLocator` label caveats beyond the header note.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr201-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s)
- Input: 202 tokens (8615875 cached reads)
- Output: 46893 tokens
- Cost: $4.337457100000001
- Wall-clock: 14220s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
