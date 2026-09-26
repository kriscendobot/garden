The design job is complete. 

## Completion report

**Job:** `design-ironhorse-panic` — design a panic mechanism for the Ironhorse engine (endojs/endo-but-for-bots, roadmap branch `llm`).

**Deliverable:** `designs/ironhorse-panic.md` (Proposed, 2026-08-17), landed as **draft PR endojs/endo-but-for-bots#1018** against `llm`. Diff is design-only (the design file plus a `designs/README.md` registration row, per the repo's AGENTS.md requirement). Bot-authored, draft (I did not un-draft and did not hand-post a gauntlet; the completion machinery auto-stages the design-panel gauntlet).

**What the design says, grounded in the real code (not assumed):**
- **Scope-first (the required first step):** confirmed `Halt::StackOverflow` and `Halt::MeterAbort` (`rust/engine/ironhorse-vm/src/interp.rs`) are *already* panics (abort-to-host, built on XS `fxAbort`), so the panic half is reclassification, not new machinery. Presented as name/generalize/extend, not a parallel mechanism.
- **Formal `Panic` category:** keep the diagnostic variants, add an `is_panic()` grouping + `Halt::Panic(PanicKind)` for net-new sources (caught Rust panic, coda reference-error), and surface a three-way `CrankOutcome` at the prospective `-e ironhorse` `Machine` seam.
- **Message-embargo contract:** a subagent surveyed the live crank path and found the *unfavorable* truth — **no per-crank commit point and no embargo today**: outbound leaves synchronously mid-crank (`send_frame` in `worker_io.rs`), a meter-aborted worker just dies via `process_meter_report`→`unregister` with sent messages irrevocable, and there is **no delivery transcript** (only coarse snapshot suspend/resume). The metering design deliberately chose admission control to *eliminate* embargo. So the embargo + crank-commit boundary + transcript replay are net-new and are **explicitly deferred to a named follow-on design** (`message-embargo-and-crank-commit`) in Open Questions, rather than asserting an unverified mechanism — exactly as the deliverable required.
- **Termination/retry** composes `debugWorker` suspend/resume; "fixed" enumerated (new-snapshot code fix / config-change retry / external-condition retry).
- **Debugger interaction:** a panic is categorically uncatchable (never consults `jumps`), distinct from an uncaught throw (`Halt::Throw` + `jumps.is_empty()`), gets its own `<panic>` wire message orthogonal to `setExceptionBreakMode`, and stops the world at the panic site when a debugger is attached.
- **Coda:** off-by-default `Machine` construction option making the `XS_CODE_GET_LOCAL` / variable-lookup reference-error sites panic instead of throw; named as the opposite setting of the recovery-and-uncaught design's `raise`-helper engine-unwind switch, with both-active behavior specified.

**Verification performed (real-execution evidence):** both mermaid fences parse-validated with `mermaid.parse()` (`checker exit: 0`); house-style sweep confirmed 0 em-dashes, no unresolvable `[[wiki-links]]`, ASCII-only except the project-standard `§`; PR verified via `gh pr view` as `isDraft=true`, `base=llm`, files = the two design files only.

**Follow-ups:** (1) the design names `message-embargo-and-crank-commit` as a to-be-filed follow-on design (the embargo/commit/transcript machinery is net-new); (2) sent the liaison a structural lesson that `ensure-pr.sh`'s default 200-PR page limit is now routinely inconclusive on this repo (200+ open bot PRs) and needed `GARDEN_ENSURE_PR_LIST_LIMIT=600`.

Self-improvement: routed the `ensure-pr.sh` page-limit friction to the liaison; otherwise nothing further this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-ironhorse-panic.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 114 tokens (9967773 cached reads)
- Output: 64170 tokens
- Cost: $9.642751249999996 (1 engagement(s) unpriced)
- Wall-clock: 967s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
