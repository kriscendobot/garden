**Press dispatch 14 complete (2026-07-21 ~03:06–03:15Z) — steady state confirmed; all six PR heads unchanged; nothing newly unblocked.**

**Assessment (verified live, not assumed):**
- All six PRs unchanged since dispatches 12–13: #340 `6eb31274` → #684 `cc398cb1` → #688 `469335e6` → #693 `73ad1b6d` (stack), #683 `64b6dac5`, #806 `1e4f9104`. All OPEN, DRAFT, base chain intact.
- The `llm` base advanced again since dispatch 13 (`1ff3e0d3` → `2e5da52f`, the cap-std-watch design doc merge #793, pushed 02:51Z — 15 minutes before this dispatch). Re-polled after the base move: #340, #683, and #806 all report **MERGEABLE / CLEAN**, so no weave is needed; #806 remains 22/22 checks passing.
- No new comments on any of the six PRs since 2026-07-20T21:15Z (checked via the issues/comments API with `since=`), no new reviews on #806 or #693, no maintainer directives, job inbox empty on both drains, and no live peer worker on any stack branch.
- Adjacent activity noted, not pressed here: #786 (siesta OCapN orthogonal-persistence machine) updated 00:27Z — a separate work stream from the Noise transport stack.

**Liveness cited:** both minion.town routes answered live this dispatch — `https://minion.town/ocapn` → HTTP 426 and `https://minion.town/ocapn-daemon` → HTTP 426 (WebSocket upgrade endpoints alive). The last full end-to-end proof (M4 greeter + M5 pure-CLI cross-host invite/accept, both PASSED with captured output) was dispatch 12 (~12h ago) at these exact same heads; re-running the full demo against a byte-identical system would produce no new evidence, so I did not repeat it or post a duplicate evidence comment.

**Milestone state:** M1–M5 all remain proven (M5 = Pet-Daemon↔Pet-Daemon cross-host invite/accept over wss+Noise, dispatch-12 evidence on #693).

**Follow-ups (all still blocked on external input, unchanged from dispatch 13):**
1. **#806 merge** — the crossed-hello settlement-race fix is fully green and MERGEABLE/CLEAN against the current `llm`; it awaits maintainer merge, after which one stack rebase inherits it plus the two recent `llm` advances.
2. **Cross-host TCP+CBOR** — awaits the maintainer's answer on a non-443 port (asked 2026-07-17, still unanswered).
3. **Bidirectional pairing** — awaits a publicly dialable garden-side address.
4. Session-reconnect design and relay implementation remain deliberately deferred.

No garden-repo (`main2`) changes, no PR comments posted, and no memory updates were needed this dispatch.
