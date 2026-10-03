Fix round 6 for endojs/endo-but-for-bots#1407 is done and CI is green (33 checks, 0 failed).

A previous claimant of this job had already pushed the fixes to the PR head (2026-10-03 11:23Z) before it was requeued. I checked each one against the round-6 panel verdict (review 5400384875 on `a62e91aca`) and pushed nothing more.

**Must-fix items:**
1. **engine-realist** is fixed in `f276210a5`. In `packages/daemon/src/manager.js`, after `guestPathIssuer.issue(...)` the code now looks the guest up with `controllerForId.get(id)` and checks `formulaForId.has(id)`, instead of calling `provideController(id)` again. A guest collected while its socket was being issued is therefore no longer recreated: its socket is revoked and the call throws. The `context.cancelled` revoke listener is now registered once per guest, tracked with a `WeakSet` of controllers.
2. **orthographer** is fixed in `a49568bb9`. The prose now says canceled/canceling in the design doc, the `manager.js` comment, the `serve-guest-path.js` comment, and the `guest-bootstrap-path.test.js` test title and error text. The `cancelled` identifiers are unchanged.
3. **pruner**: the PR body no longer has the "Files to review most closely" sentence. It is still about 560 words, against the 300-word probe; the panel only asked for that sentence to go.

**Should-fix items, also in `a49568bb9`:**
- **typist:** the `GuestPathIssuer.issue` type now documents that it can throw synchronously.
- **archivist:** the `packages/claude/README.md` cleanup sentence now covers the root-session fallback.

The stylist's `fsp` note was left alone: the same name is used by three existing files in the package.

**CI:** `ci-wait-merge.sh --no-merge` on head `a49568bb9` returned rc 0. Panel round 7 is next and is the driver's to post.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-guest-scoped-daemon-bootstrap-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 94 tokens (3711638 cached reads)
- Output: 14281 tokens
- Cost: $2.1790596
- Wall-clock: 4497s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
