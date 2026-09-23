Summary comment posted (`#issuecomment-5384590534`). All work for this fix stage is complete: panel round-1 must-fix items applied, CI green 27/27.

---

**FIX round 1 — endojs/endo-but-for-bots #796 — complete.**

**What I did**
- Isolated project checkout of the PR head (`feat/hashline-core`). Read the latest garden code-panel verdict (round-1, disposition **must-fix**, 22 request-changes seats) and applied its load-bearing must-fix items as one review-feedback follow-up commit (`4bb3ebee27`), rebased onto the current head after the stack was re-pinned onto a newer `origin/llm`.

**What changed** (6 files, +326/−75)
- `packages/daemon/src/hashline.js` — read-once discipline in `validateAnchor`/`validateEditPatch` (getter-stable snapshots); map `ops`/`payload` through the intrinsic `Array.prototype.map` to defeat a proxy-`map`-trap (`Array.isArray` is not a brand check); reject duplicate `@expected-file-hash`; cap `ops.length` (DoS); assemble the splice element-by-element instead of spreading caller-controlled payloads (argument-count `RangeError`).
- `packages/crc32/src/crc32.js` — `ArrayBuffer.isView` indexed fast path (removes the ~11× hot-loop regression on the shared `@endo/zip` path), reserving `.at` for emulated views; validate every `.at`-read byte is a `[0,255]` integer (lying view throws, not a wrong checksum); widened `@param` type.
- `packages/crc32/README.md` — rewrote the input contract to the `.at`/`.length` protocol (dropped the false "must be a genuine `Uint8Array`").
- `packages/daemon/types.d.ts` — re-export the 11 hashline typedefs from the package type entry point (were unreachable).
- Regression tests added: `daemon` hashline 42→47, `crc32` 7→9.
- PR description corrected (stale "Proxy length-lie guard" claim removed); top-level summary comment posted (`#issuecomment-5384590534`).

**Verification** — `tsc`, `eslint`, `prettier` clean; targeted tests pass. Pushed via `safe-push-pr-head.sh`. A first push failed prettier in CI (repo-wide `lint:prettier`, which per-package `yarn lint` does not run); fixed and amended. **CI reached terminal GREEN: 27/27 checks pass, 0 failures** (`ci-wait-merge.sh` rc 0).

**Follow-ups (deferred, not blockers)** — panel style/should-fixes for a later round: `Op`→`Operation` identifier spell-out, `reapplyWindow`→`reapplyRadius` rename, design-body prose sync, and the `EditOp`/`EditResult` discriminated-union refactor. Per the staged gauntlet, the driver re-posts panel-2; I did not re-run the panel.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr796-gauntlet-resume-20260822-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 203 tokens (15698977 cached reads)
- Output: 72316 tokens
- Cost: $13.222447500000001
- Wall-clock: 3443s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
