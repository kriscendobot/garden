Gauntlet FIX round 4 for PR #796 is complete: panel must-fix items applied, pushed to the PR head, and CI is green.

**What I did**

Applied the round-4 panel's gating must-fix items (plus the cheap, verified should-fix items in the same cluster) across three disjoint file sets, committed as one review-feedback follow-up (`b5932998b7`) on `feat/hashline-core`, and drove CI to green.

**`@endo/daemon` hashline core** (`src/hashline.js`, `src/types.d.ts`, `types.d.ts`, `test/hashline.test.js`):
- **typist** — `EditOp` and `EditResult` are now discriminated unions matching what the validator enforces; the splice narrows on `op`/`success` and the ten downstream casts are gone (one documented cast remains at the validation boundary).
- **locksmith** — the injected `sha256Hex` digest power is a separate positional parameter, no longer an `ApplyEditOptions` member, so a mount forwarding guest options can't occupy the power's slot.
- **warden** — `applyEditPatch` now returns `SpliceOutcome { result, newText }`; the spliced file text rides a separate channel and is not a field of the boundary-crossing `result`.
- **breaker/assessor** — result character length capped before `joinLines`, reported as `patch-syntax`, so an oversized payload no longer escapes the structured-failure contract as a raw `RangeError`.
- **saboteur/wire-watcher** — `parseHashlineText` enforces `MAX_EDIT_OPS`; payload rejects unpaired surrogates (injectivity domain stated in the wire contract); `sha256Hex` output is shape-checked; `lineAnchorHash` `hexWidth` typed `2|4`; stale/incorrect comments and typist-hostile code points fixed.
- Migrated the test suite to the new API and added 6 regression tests (errorMessage non-Error throw, digest shape-check, reapply-window boundary, result-char cap, surrogate rejection, parser op-cap). **63 tests pass.**

**`@endo/crc32`** (`src/crc32.js`, `test/crc32.test.js`, `README.md`): bounded the emulated `.length` to 2³²−1 (saboteur/breaker); reject a detached buffer instead of silently checksumming empty (spec-keeper); symmetric guard on the `.at` read; `@param`/`@throws` spelled out. **16 tests pass** (zip, its consumer, still green at 13).

**Docs** (`designs/README.md`, `designs/cli-edit-verb.md`, `.changeset/daemon-hashline-core.md`, PR body): synced README totals for the `cli-edit-verb` In-Progress flip, removed stale second-hashline-copy prose and fixed the `joinLines` signature (integrator/archivist/curator), enumerated the changeset's value exports, disclosed zip's crc32 input-validation tightening (migrator), and rewrote the stale PR description to match head (integrator).

**Verification**: daemon `lint:types` + `test:types` + eslint + prettier clean; hashline 63 / crc32 16 / zip 13 tests pass locally; **CI green (27 checks, 0 failures)**.

**Follow-up**: none required for this stage — the driver re-posts panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr796-gauntlet-resume-20260822-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 39 tokens (5389634 cached reads)
- Output: 13143 tokens
- Cost: $21.570147249999998
- Wall-clock: 2971s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
