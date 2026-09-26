CI is GREEN (rc 0). The fix stage is complete.

## Completion report

**Job:** endojs-endo-but-for-bots-pr1018-gauntlet-fix-4 — gauntlet FIX round 4 for PR #1018 (`design(ironhorse): panic mechanism and message-embargo contract`, a design-only PR editing `designs/ironhorse-panic.md`).

**Panel verdict applied:** round-4 must-fix (from kriscendobot review, 2026-08-31T08:38:17Z). Applied the request-changes and should-fix items across seven seats in one follow-up commit `6815f03fd`, pushed via `safe-push-pr-head.sh` (advance mode, `875737517 → 6815f03fd`).

**What changed in the design:**
- **critic (must-fix):** Reconciled the three artifacts that treated an uncaught `Throw` inconsistently by separating two axes explicitly — *embargo coverage* (uniform: every non-`Committed` outcome discards its outbound, no hangover) versus *retryability* (panic-only). Added a clarifying paragraph after the embargo table, grounded the terminate-on-throw default as a conservative choice, and recorded reject-and-continue as an Alternatives entry plus a new Open Question.
- **skeptic (request-changes):** Added two Verification acceptance-bar bullets — one asserting the net-new FFI `catch_unwind` guard converts a panicking `extern "C"` callback into a per-worker `Halt::Panic(EngineFault)` without aborting co-resident vats; one driving each named host-handle/effect failure branch (non-idempotent-provider barrier, no-reconstruction-descriptor broken re-seat).
- **decomplector (should-fix):** Pinned `CrankOutcome::classify` to compute `Panicked` via `is_panic()`, not a second enumeration.
- **ergonomist (request-changes/should-fix):** Marked `is_panic()`'s `Decode | StepLimit` inclusion provisional to match the Open Question; moved the "match via `is_panic()`/`CrankOutcome`" steering note onto the `Halt` declaration; specified the diagnostic payload of `EngineFault` and `ReferenceError`.
- **novice (request-changes):** Glossed E-language/KeyKOS, CAS, and arena; lifted the five-way host-function classification to the top of its section; forward-referenced § Prompt.
- **copyeditor/pedant:** grammar/parallelism fixes, µ→us, heading capitalization, e.g.→for example, TDZ introduced at first use.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0 — 5/5 checks green, 0 failed.

**Follow-ups:** none. Per the gauntlet contract I stopped after the single fix pass; the driver re-posts panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1018-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 108 tokens (4827664 cached reads)
- Output: 28855 tokens
- Cost: $4.15854
- Wall-clock: 858s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
