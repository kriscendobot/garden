CI is GREEN (rc 0). The fix stage is complete.

## Completion report

**Job:** endojs/endo-but-for-bots PR #1018 — gauntlet FIX round 1 (design PR: `designs/ironhorse-panic.md`, "design(ironhorse): panic mechanism and message-embargo contract").

**What I did:** Read the automated design-panel round-1 verdict (request-changes disposition, must-fix) and applied its items as one follow-up commit (`c06d614b6`) to the PR head (`endojs/design/ironhorse-panic`), verifying the load-bearing claims against the actual `interp.rs` tree before editing.

**Changes applied:**
- **Coda stale citations (skeptic must-fix + should-fix, verified):** `XS_CODE_GET_LOCAL`, `GET_VARIABLE`, `GET_THIS_VARIABLE` already raise *catchable* `ReferenceError`s via `raise_js` (landed `47d5bb8c6`/`97fad0abd`) — not the raw `Halt::Throw` the doc claimed. Corrected the inventory and added the third, still-unconverted `XS_CODE_GET_CLOSURE_1/_2` site (interp.rs:10774) the survey omitted.
- **Prerequisite section:** the `raise` helper the doc framed as not-yet-built already exists as `raise_js(&mut self, value: Slot) -> Result<usize, Halt>`; rewrote the section to reflect the met prerequisite.
- **`PanicKind::Host` → `PanicKind::EngineFault` (ergonomist must-fix):** removes the collision with the document's pervasive "host" call-surface vocabulary; updated the debugger wire `kind` value too, with a rationale note.
- **Reversed WAL deferral (critic must-fix, theme 3):** restated *why* the deferral no longer applies — the maintainer's own review made the transcript a soundness prerequisite, and this revision's survey discharged the "unsurveyed" condition — rather than asserting a built-out mechanism unexplained.
- **Cross-file atomicity (critic + decomplector):** named the joint-commit mechanism per backend (ATTACH/2PC for the store-backed path; transcript-then-CAS watermark ordering for the production XS/CAS path the survey is actually grounded in) and added a "which backend first" Open Question; corrected the Dependencies-table claim of a single implicit shared transaction.
- **Latency tradeoff (critic):** stated the durability regression and deferred benchmarking to the follow-on implementation.
- **Variant-shape asymmetry (ergonomist should-fix):** stated no commit-path consumer matches `Halt` shape directly; routing goes through `is_panic()`/`CrankOutcome`.
- **Prose (copyeditor + novice):** fixed the ambiguous or/and coordination, list-intro fragment, list parallel structure, colon-before-predicate; named the third Scope case; glossed the vat/worker 1:1 relationship, "seam", and "Endor"; uniform classification tag `read`; removed a unicode ellipsis.

**Result:** Pushed as a review-feedback follow-up (`be17297e3 → c06d614b6`). CI watched to terminal: **GREEN** (5 checks, 0 failed, rc 0). Per stage instructions I did not re-run the panel — the driver re-posts panel-2.

**Follow-ups:** None from this stage. The doc now flags one implementation prerequisite (convert `GET_CLOSURE_1/_2` to `raise_js` before the Coda can cover reference errors uniformly) and one Open Question (which worker backend carries the first production transcript integration) — both intentional, for the implementation PR, not this design review.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1018-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (3567774 cached reads)
- Output: 28138 tokens
- Cost: $3.43025
- Wall-clock: 833s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
