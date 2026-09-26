All checks are done and the picture is clear — steady state again. No re-run of the end-to-end demo is warranted: all six PR heads are byte-identical to the dispatch-12 proof, so re-executing against unchanged code would produce no new evidence. Nothing is newly unblocked; every follow-up still waits on external input (maintainer merge of #806, port answer, dialable address).

**Press dispatch 15 complete (2026-07-21 ~09:21–09:30Z) — steady state confirmed; all six PR heads unchanged; nothing newly unblocked.**

**Assessment (verified live, not assumed):**
- All six PRs unchanged since dispatches 12–14: #340 `6eb31274` → #684 `cc398cb1` → #688 `469335e6` → #693 `73ad1b6d` (stack), #683 `64b6dac5`, #806 `1e4f9104`. All OPEN, DRAFT, base chain intact.
- The `llm` base advanced again since dispatch 14 (`2e5da52f` → `d092e0e2`, the #802 endor Node-semantics-exports reland, merged 03:23Z — neither it nor the earlier cap-std-watch doc touches the OCapN transport code). Re-polled after the base move: #340, #683, and #806 all report **MERGEABLE/CLEAN**, so no weave is needed; #806 remains fully green (22/22 checks at last CI run, still valid — head unchanged).
- No new comments on any of the six PRs since dispatch 14's cutoff (checked via the issues/comments API with `since=2026-07-21T03:15Z` — all empty), no reviews on #806 or #693, no maintainer directives, job inbox empty, and no live peer worker on any stack branch (bus roster shows only unrelated presses).
- Adjacent activity noted, not pressed here: #777 (iroh 1.0 QUIC netlayer for OCapN) updated 05:23Z — a separate transport stream from the Noise stack.

**Liveness cited:** both minion.town routes answered live this dispatch — `https://minion.town/ocapn` → HTTP 426 and `https://minion.town/ocapn-daemon` → HTTP 426 (WebSocket upgrade endpoints alive, curl exit 0). The last full end-to-end proof (M4 greeter + M5 pure-CLI cross-host invite/accept, both PASSED with captured output) was dispatch 12, at these exact same six heads; re-running the demo against a byte-identical system would mint no new evidence, so per idempotency discipline I did not repeat it or post a duplicate evidence comment.

**Milestone state:** M1–M5 all remain proven (M5 = Pet-Daemon↔Pet-Daemon cross-host invite/accept over wss+Noise, dispatch-12 evidence on #693).

**Follow-ups (all still blocked on external input, unchanged from dispatch 14):**
1. **#806 merge** — the crossed-hello settlement-race fix is green and MERGEABLE/CLEAN against the current `llm` (verified after today's base advance); it awaits maintainer merge, after which one stack rebase inherits it plus the three recent `llm` advances.
2. **Cross-host TCP+CBOR** — awaits the maintainer's answer on a non-443 port (asked 2026-07-17, still unanswered).
3. **Bidirectional pairing** — awaits a publicly dialable garden-side address.
4. Session-reconnect design and relay implementation remain deliberately deferred.

No garden-repo (`main2`) changes, no PR comments posted, and no memory updates were needed this dispatch.
