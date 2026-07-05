---
gate: orchestrated
orchestrated_by: xs2rust-endor-strings-utf16
priority: normal
roadmap: xs2rust-endor
posted_by: producer
posted_at: 2026-07-05T21:42:11Z
---

---
model: fable
roadmap: xs2rust-endor
---
# Designer: revise the string-representation section to UTF-16, re-base string metering

**Program:** `xs2rust-endor` XS→Rust port. Repo `endojs/endo-but-for-bots`, branch
`xs2rust-endor` (PR #600 — keep DRAFT). Design doc: `designs/xs2rust-endor-engine.md`.
This is child 1/3 of the CESU-8→UTF-16 revisit (orchestration `xs2rust-endor-strings-utf16`).

## What to change in the design doc
1. **§ Value and heap model — the string paragraph.** Today it reads (≈line 312):
   *"Strings remain CESU-8 in chunks (the `mxCESU8` configuration the endor build already
   uses), and NaN canonicalization follows `mxCanonicalNaN`…"*. Revise it to specify
   **UTF-16 code-unit storage** for JS string values, and state the consequence explicitly:
   code-unit indexing (`length`, `[i]`, `charCodeAt`, `codePointAt`, iteration, comparison)
   becomes **intrinsically O(1)**, so the auxiliary constant-time-index machinery CESU-8
   needs — cached last-access cursors, ASCII/BMP fast paths, index side-tables — is
   **deleted**, not ported. Note the trade: ~2 bytes/code-unit vs ~1 for ASCII under CESU-8,
   bought for simpler, obviously-correct indexing. Address snapshot/allocation observability:
   string chunk bytes change size, so `currentHeapCount`/chunk-growth numbers shift — that is
   fine under the accuracy-over-parity meter (below); just call it out so snapshot-atom
   round-trip and the differential harness expectations are updated deliberately, not
   silently. Keep the NaN-canonicalization sentence.
2. **§ Metering — string-op weights.** The metering DOCTRINE is already correct: the doc was
   revised 2026-07-04 (maintainer directive) to **accuracy over parity** — the meter is
   endor's own release-versioned deterministic cost model, a proxy for wall-clock cost, and
   the C-XS oracle governs **results only**, computrons advisory. So do NOT rewrite the
   doctrine. Add only that **string-op cost-table weights (concat, compare, index, slice,
   char access) are re-based to the UTF-16 representation** — O(n) in **code-unit** length,
   O(1) for a single code-unit index — derived from the cost-calibration instrumentation
   (sibling `xs2rust-endor-meter-opcode-cost-instrumentation`) and the live calibration work
   (`xs2rust-endor-meter-calibration-stage-c1`), **not** CESU-8 byte length chosen to match
   the oracle. Frozen per release, recalibrated across releases with an `endor-meter-N` bump.
   (The plan flagged the metering section as needing the accuracy-over-parity update — verify
   it is present and coherent; it should already be there.)

## Definition of done
Revised design doc pushed to PR #600's branch (design-doc edits only — no Rust). A short PR
comment summarizing the representation change and the string-metering re-basing, so the
supervisor's binding-question/approval loop can ratify it. Because this is a load-bearing
representation decision, **the build child does not start until this design section is
accepted** (the orchestration sequences design → build → test; the supervisor
`port-xs-to-rust-memory-safe-engine-*` owns binding-design approval).
