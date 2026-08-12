Inbox is empty. The job is complete.

## Completion report

**Job:** Design the recovery path for the Ironhorse debugger row and fixes for the three break-on-uncaught follow-ups, following on merged PR #600, oracle-locked to XS.

**Deliverable:** Draft PR **[endojs/endo-but-for-bots#975](https://github.com/endojs/endo-but-for-bots/pull/975)** against `llm` — design doc `designs/ironhorse-debugger-recovery-and-uncaught.md` plus its `designs/README.md` plan integration (summary row + detail-status row). Draft, base `llm`, diff is exactly those two files.

**What I did:**
- Read the researcher report (issue #940) and the existing `daemon-xs-worker-debugger.md` / `ironhorse-engine.md` designs, then **re-verified all five research claims against the current `llm` head (`0ac48c54b`)**, not the head the research was written against.
- **Claim 1 (recovery):** Established the three debugger slices are still fetchable as unreachable objects but their merge-base with `llm` is **505 commits back**, across a wholesale `endor-* → ironhorse-*` crate rename and a ~19k-line `interp.rs` rewrite. **Explicit recommendation: a fresh `builder` re-deriving against today's `ironhorse-vm`, NOT a `weaver` cherry-pick** — the slices are reference material, not a mergeable branch. Slice 1 (leaf `ironhorse-debug` protocol core) ports nearly verbatim; slice 2's VM seam re-derives.
- **Claim 2 (client no-op):** Confirmed `debug-session.js` still ships `uncaughtExceptions`; C-XS pin unchanged, so `'uncaught'` silently disables exception breaking. Designed both an engine fix and an independent client-stack fallback.
- **Claim 3 (engine-raise):** Verified via subagent and **stronger than reported** — engine errors build `Halt::Throw` inline with no centralized raise helper, so `try/catch` can't catch an engine `TypeError`. Designed it as a **gating prerequisite**, not a loose follow-up.
- **Claim 4 (parity nits):** Confirmed all three in the exact source-to-recover (`breakpoints.rs`); folded their fixes into slice 1's re-land.
- Designed break-on-uncaught around the structural predicate `jumps.is_empty()` + a one-byte target-opcode peek (oracle-locked to `fxTryNodeCode`, no bytecode change), the `uncaughtExceptions` pseudo-breakpoint (option A), a `caught` attribute on `<break>`, and an equal-computron metering-neutrality acceptance test. Supersedes the C-XS `flag == 2` sketch for the Ironhorse engine.

**Follow-ups named in the design:** the engine-raise-unwind VM prerequisite (sub-slice or sibling PR), the client-stack `setExceptionBreakMode` fallback (daemon package), and open questions on xsbug-GUI attribute tolerance and whether C-XS should also gain the pseudo-path.

No mermaid diagrams were used (tables only), so no validation was required.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/xs2rust-endor-debugger-design.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (3638793 cached reads)
- Output: 33890 tokens
- Cost: $4.31176575
- Wall-clock: 527s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
