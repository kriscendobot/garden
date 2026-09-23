Design complete and the draft PR is verified. Writing the completion report.

## Completion report

**Job:** `explore-ironhorse-promise-chain-shortening` (designer / exploratory) — feasibility survey of V8-style promise resolution chain shortening for the Ironhorse VM.

**What I did**
- Set up an isolated project worktree off `endojs/endo-but-for-bots` `llm` (`387ea6614`) and surveyed the promise implementation **directly in the VM source** rather than assuming from designs, cross-checked with an Explore subagent.
- Read the required context: `ironhorse-engine.md` § Metering, the two sibling designs (`ironhorse-panic.md`, and the rejection/debugger siblings `ironhorse-debugger-recovery-and-uncaught.md` / `pass-style-promise.md`), and the `ironhorse-known-defects.md` promise defect list.
- Wrote `designs/ironhorse-promise-chain-shortening.md` (Reference status, no code), validated its mermaid diagram parses, committed it on `design/ironhorse-promise-chain-shortening`, and opened a **draft** design PR.

**Key findings (evidence-cited in the doc)**
- Ironhorse uses the naive XS/spec algorithm with a **level-1 native-promise adoption** fast path (`promise.rs` `settle_promise`, pass-through reaction on the source) but **no deep chain collapse** — an N-deep following-chain is N reactions + N FIFO microtask jobs.
- **The metering doctrine already bounds the pathological worst case**: `drain_promise_jobs` charges each link (`PROMISE_JOB_FRAME_METERING` = 393752) and calls `check_meter()` between jobs, so a long/cyclic-looking chain is metered per link and `MeterAbort`s deterministically. No metering blind spot, no unbounded-compute DoS — this dissolves the prompt's central worry.
- **Correction of a stale premise:** the handler-throw path a debugger-design note called unimplemented (`Halt::Unsupported("promise:handler-throw")`) has in fact landed; shortening is not blocked on it.
- **CapTP:** cross-vat chains can't be collapsed locally (the VM sees only local promises); that's a separate CapTP/OCapN three-party-handoff problem, flagged explicitly.
- **Recommendation: defer** — bounded worst case, not a parity gap, meter-version-breaking, and 13 open promise conformance defects (`F111`–`F129`) outrank it. Recorded a follow-pointer mechanism sketch + test plan and named trigger conditions for a future build.

**What changed:** one new design file. Draft PR **kriscendobot/endo-but-for-bots#6** (verified: `isDraft: true`, base `llm-387ea66` pinned frozen snapshot, head `design/ironhorse-promise-chain-shortening`, garden-job marker present).

**Follow-ups / notes**
- Per the manual-gauntlet-trigger regime I left the PR draft and did **not** stage a gauntlet; the maintainer promotes design-panel review with `run the gauntlet #6` when ready.
- The bot PAT cannot create PRs on `endojs/endo-but-for-bots` (`Resource not accessible`), so the review surface is the fork-internal PR against the `llm-387ea66` frozen base — the standard frozen-base shape.
- Open questions in the doc (tick-observability headroom vs test262, whether real workloads show retained-promise pressure, debugger-panel legibility) are the maintainer-facing decisions surfaced for review.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/explore-ironhorse-promise-chain-shortening.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (4273092 cached reads)
- Output: 34167 tokens
- Cost: $5.4193685
- Wall-clock: 771s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
