I opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1377 for the outbound embargo leg. It meets both acceptance items: one coverage case per row of the design's termination-path table, and the crash-after-send, before-ack property. The live XS worker is not wired to it yet; that still depends on #989 and #1374 (see Follow-ups).

**Stacking.** The previous leg's transcript PR (#1376) is still unmerged, so I stacked on its head (`ae86b858a9`). My one commit is `d3af4b6dcf` on `llm-ironhorse-panic-embargo`, and the PR targets the frozen base `llm-1706e63`, so its diff also shows #1376's commit. A rebase after #1376 merges removes it.

**Open questions.** The mentat job has finished: its answers are on draft PR #1370, which is still open, and in the numbered comment on #1018. I followed them: `MeterAbort` terminates, ordinary rejections commit, uncaught throws discard and terminate, and `Decode`/`StepLimit` stay panics. On #989 I followed its scope split: #989 keeps the quiescence boundary and in-memory buffering, and this leg adds only durable release and duplicate suppression. There is one pending batch per worker and one release authority, never a second buffer. The PR body lists each of these decisions as a review item.

**What changed:**
- **`Embargo`** (new, in the `slot-machine-transcript` crate) is the worker's single release authority. Guest sends are held until the crank ends. A crank that ran to completion commits, and only then are its frames sent, in order and behind any earlier frames still waiting. Every other outcome, `MeterAbort` included, discards them and records the crank aborted. After a restart, committed frames that were never acknowledged are sent again.
- **`DuplicateSuppressor`** (new, receiver side) remembers the highest event sequence delivered from each worker and drops anything at or below it. Its marks can be saved and restored.
- **`ExecutionOutcome::verdict()`** (endo crate) picks commit or discard from the outcome type alone, never from the specific halt reason. The endo crate now depends on the transcript crate, and the new coverage test is added to CI's endo test list.

**Tests (all pass locally):**
- **Coverage per table row, 10 tests.** Five rows use real engine runs: normal completion, a handled rejection, an uncaught throw, stack overflow, and `MeterAbort`. `EngineFault`, `Decode` and `StepLimit` have no way to trigger them from JS, so those rows use constructed halts. Each discard row checks that zero frames were sent and none are resent after a restart.
- **Crash-after-send, before-ack, 8 transcript tests.** The worker is crashed after every possible send, before the acknowledgement is saved. In every case the receiver sees each committed frame exactly once.
- The transcript crate passes 24 tests (8 new), and its formatting check is clean.

**Follow-ups:**
- **Live C-XS wiring is not done.** The worker's send functions still write straight to the transport instead of going through `Embargo`. Per the #1370 answer, the XS main loop first needs #989's one-delivery-at-a-time admission, and the C-XS `Panicked` adapter from #1374.
- **The Coda (reference-error) row is partial.** `PanicKind::ReferenceError` doesn't exist yet, so the row only tests the Coda-off case (an uncaught throw, discarded). The Coda leg should replace the stand-in with the real row.
- #1377 goes to the gauntlet automatically; CI has not been checked yet.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-outbound-embargo.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 108 tokens (5808140 cached reads)
- Output: 43672 tokens
- Cost: $3.364764
- Wall-clock: 553s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
