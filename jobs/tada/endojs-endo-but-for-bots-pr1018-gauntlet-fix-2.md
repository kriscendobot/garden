CI is GREEN (rc 0). The fix stage is complete.

## Completion report

**Job:** `endojs-endo-but-for-bots-pr1018-gauntlet-fix-2` — FIX round 2 of the PR #1018 gauntlet (design doc `designs/ironhorse-panic.md`).

**Panel round-2 verdict:** must-fix. Two explicit must-fix items, both applied and verified against the tree first:

1. **pedant (must-fix) — em-dash rule.** Removed all 17 em-dash occurrences from prose, rewriting each as a period, parentheses, or colon per `skills/em-dash-style`. Verified zero `—` (and no other typist-hostile code points) remain.
2. **skeptic (must-fix) — unverified "not a compromised daemon" premise against the live FFI boundary.** Verified the claims in-tree (`with_transport`'s `.expect(...)` at `worker_io.rs:363`, reached from the `unsafe extern "C"` send callbacks; no `catch_unwind` anywhere in `rust/endo/xsnap/src/`; the `spawn_shared_worker`/`spawn_inproc_xs_manager` in-process topology in `inproc.rs`). Added a new § Scope paragraph ("The already-live FFI abort hazard") surveying that the live C-XS worker aborts the *whole daemon process* (Rust 1.71+) on any uncaught panic in the glue, so `EngineFault`'s thread/FFI catch is a **net-new requirement on the existing xsnap glue**, not something Ironhorse already provides. Cross-referenced from Formal Category item 3.

**Also applied (cheap, unambiguous should/comment-only fixes to reduce round-3 churn):** heading title-case (`What Is`), `e.g.,` comma, present-tense slip (`wants`), and moved the vat/worker parenthetical out of the opening definition (flagged by copyeditor + novice).

**Pushed** as one review-feedback follow-up commit `87e0d79a1` to `endojs/design/ironhorse-panic` via `safe-push-pr-head.sh` (advance mode). **Did not** re-run the panel (driver re-posts panel-3).

**CI:** watched bounded to terminal — GREEN (5 checks, 0 failed, rc 0).

**Follow-ups:** remaining panel items are should-fix/comment-only (e.g. transcript mandatory-vs-opt-in adoption discussion, `<panic kind>` enumeration completeness for `decode`/`step-limit`, the flat-vs-nested `Halt` shape doc-comment, the "tentative-local" sixth category) — left for the next panel round to accept or re-raise.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1018-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 82 tokens (3154179 cached reads)
- Output: 21726 tokens
- Cost: $3.0102795
- Wall-clock: 647s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
