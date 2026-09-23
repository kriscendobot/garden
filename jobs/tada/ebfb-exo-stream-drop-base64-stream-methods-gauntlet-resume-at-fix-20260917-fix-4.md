CI is GREEN (rc 0). The fix stage is complete. A prior claimant of this same job had already applied the panel-4 must-fixes, pushed to head `e47a1af3`, and posted the round-4 fix summary; I re-derived that state, verified the fixes landed, and confirmed CI reached terminal green.

## Completion report

**Job:** Gauntlet FIX round 4 — endojs/endo-but-for-bots PR #1100 (`feat(exo-stream)!: use one stream method for byte streams`).

**State re-derived on clean resume:** A prior claimant of this same fix-4 job had already completed the apply-and-push work before the reaper requeue:
- Panel-4 (`request-changes`, must-fix) reviewed head `31a0a96b7e`.
- Round-4 fixes were applied and pushed to PR head `e47a1af3d8` (current head), with a **"Round-4 fix summary"** comment posted at 2026-09-17T04:06:15Z.

**Must-fix items addressed by that push** (verified via the summary comment + committed head):
- `looksLikeReadableBlob` / `ReadableBlobSource` now require `stream` on every branch (predicate, type, and regenerated agent-tools fs/git declarations); `text`-only sources rejected with a crisp shape error.
- Dropped the unreachable/untested `isPassByCopyContainer` clause in `code-mode-type-extract.js`.
- Changeset: bumped `@endo/9p-server`, `@endo/endo-fs-asset-server`, `@endo/endo-fs-exec` `patch → major`; documented the three absent upgrade obligations.
- Stale base64 prose swept (`from-mount-backend.js`, `9p-server/README.md`, `sandbox/factory.js` + `lifecycle.test.js`, extended `DESIGN.md` code points).
- Added `packages/exo-stream/BENCH.md` + committed `test/bytes-wire-cost.bench.js`; scoped DESIGN.md perf claim to the measured Node 22 env.
- Replaced hand-picked reader round-trip chunks with a `@fast-check/ava` property test.
- Declined/deferred items recorded with rationale (yarn.lock retcon deferred to `retcon #1100`; historical `streamBase64` in `designs/*`; `assertReadableBlobSource` narrowing).

**CI verification (this attempt):** `ci-wait-merge.sh ... --no-merge` → `rollup-terminal ... total=32 failed=0 → CI GREEN`, rc 0. Independent check-run count: 30 completed (23 success, 7 skipped), no failures/pending.

**Work I did this attempt:** none needed on the tree — re-derived that the fix was already committed/pushed and only the bounded CI watch remained; ran it to terminal green. Made no new commits (no edits required).

**Follow-ups:** the driver re-posts panel-5 next. `retcon #1100` remains a noted deferred item (yarn.lock hunk consolidation) if the maintainer wants it before merge.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-exo-stream-drop-base64-stream-methods-gauntlet-resume-at-fix-20260917-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 230 tokens (11501220 cached reads)
- Output: 76242 tokens
- Cost: $9.797973999999996
- Wall-clock: 2959s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
