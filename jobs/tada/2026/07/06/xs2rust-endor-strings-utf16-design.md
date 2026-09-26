Job complete. Report:

---

**Completion report — xs2rust-endor-strings-utf16-design (child 1/3 of the CESU-8→UTF-16 revisit)**

Revised `designs/xs2rust-endor-engine.md` on PR #600's branch (`xs2rust-endor`, endojs/endo-but-for-bots) and pushed as commit `0aee7c73f` (rebased once past a concurrent stage-3b engine commit at the push CAS). Design-doc edits only, no Rust; PR remains DRAFT.

What changed:

1. **§ Value and heap model** — the string paragraph now specifies **UTF-16 code-unit storage** replacing CESU-8, states that code-unit indexing (`length`, `[i]`, `charCodeAt`, `codePointAt`, iteration, comparison) is intrinsically O(1) so the constant-time-index machinery (cursors, ASCII/BMP fast paths, index side-tables) is deleted rather than ported, names the ~2-vs-1 bytes/code-unit trade, and calls out the snapshot/`currentHeapCount` observability shift as a deliberate (not silent) fixture update. The NaN-canonicalization sentence is kept.
2. **§ Metering** — verified the accuracy-over-parity doctrine (2026-07-04) is present and coherent; did **not** rewrite it. Added one paragraph: string-op weights re-based to UTF-16 code-unit length (O(n)/O(1)), derived from the cost-calibration instrumentation and stage-c1 calibration work, not CESU-8 byte counts or oracle-matching; frozen per release under `endor-meter-N`.
3. **Coherence edits** the two mandated changes force: resolved question 4 rewritten to record UTF-16 as the resolution (it previously said "Until that plan lands, CESU-8 stands" — this job is that plan landing); fuzz target 4 retargeted from CESU-8 codec round-trip to UTF-8⇄UTF-16 boundary transcoding with unpaired-surrogate handling; historical stage-3 decomposition and roadmap-table CESU-8 mentions annotated as superseded (not rewritten — they record what was built); header revision row added. The § Ground Truth description of C-XS itself was left intact.

Posted the summary PR comment for the supervisor's binding-question/approval loop: https://github.com/endojs/endo-but-for-bots/pull/600#issuecomment-4888574380

Follow-ups: none for me — per the orchestration, the build child (2/3) is gated on the supervisor accepting this design section; the orchestrate watcher sequences it. Inbox drained twice, empty.
