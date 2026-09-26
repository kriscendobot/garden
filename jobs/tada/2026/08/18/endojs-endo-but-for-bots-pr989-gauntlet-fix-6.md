CI is GREEN (rc 0). The fix stage is complete.

## Completion report

**Job:** endojs/endo-but-for-bots PR #989 gauntlet — FIX round 6 (design doc `designs/worker-quiescence-embargo.md`).

**What I did:** Read the panel-6 request-changes verdict (seven seats) and applied every **must-fix** item once, plus the cheap directly-adjacent should-fixes, then pushed and drove CI green.

**Must-fix items applied:**
- **critic** — host-power seam splits a Node crank: added "no outstanding host-power continuation" to the Quiescence definition, named host-power/sync-reply inputs in the pure-function invariant, and added a Node `setImmediate` fence (Decision 6) that re-arms until in-flight host-power promises settle, so one XS crank stays one Node crank.
- **skeptic #1** — named the Node crank-abort observable (a genuine pump/flush fault sets the flag) and distinguished it from an ordinary delivery rejection that CapTP turns into a `CTP_RETURN isRejected` reply frame that must flush; updated the failure-atomicity test bullet accordingly.
- **skeptic #2** — mid-crank `suspend` no longer discards the buffer: the per-crank outbound `Vec<Vec<u8>>` is persisted alongside `machine.suspend_to_cas` and rehydrated on resume; added the non-empty-buffer resume test (Decision 10, lib.rs row, test strategy).
- **ergonomist / decomplector / novice #1** — decoupled session kind from buffering policy: worker-ness is now an explicit session kind (dedicated worker entry point / `sessionKind: 'worker'`) that installs crank exclusivity unconditionally, with `bufferOutboundUntilQuiescence` a pure policy knob read only for a worker session; added a three-state table naming the reachable configurations (connection.js row, § config option, Decisions 3 & 7).
- **novice #2** — repeated the emission-seam reconciliation at the Node buffer site in § Design.
- **copyeditor / pedant** — fixed the "four verbs / no third verb" contradiction.

**Cheap should-fixes folded in:** `stuckCrankThreshold` → `stuckCrankThresholdMs` with a stated default and a Rust `stuck_crank_threshold_ms` spelling; dangling/loose `§` cross-references repointed to real headings; bare `## What is the Problem Being Solved?` heading restored; `(emphasis added)` flag on the maintainer quotation; double-colon and 125-column reflow fixes; `designs/README.md` row re-sorted before `worker-rust-xs`.

**What changed:** one commit `712c472a28` on `design/worker-quiescence-embargo`, pushed via `safe-push-pr-head.sh` (advance mode, clean fast-forward from `b92806987f`). 2 files, +166/−65.

**CI:** GREEN — `total=5 failed=0` at the bounded watch (rc 0).

**Follow-ups:** I deliberately did not attempt the larger subjective should-fixes (prose-compression of thrice-restated decisions; affected-components table cells being essay-length) — those are judgment calls the panel flagged as should/comment, and rewriting them risks new nits. The driver re-posts panel-7 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr989-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 113 tokens (6704317 cached reads)
- Output: 48598 tokens
- Cost: $6.693556499999998
- Wall-clock: 1107s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
