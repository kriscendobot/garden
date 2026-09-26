The design is complete. Draft PR #1084 is open against `llm` with exactly the two-file diff, and its design-panel gauntlet will be staged automatically by the completion machinery (I leave it draft and do not hand-post a gauntlet).

## Completion report

**Job:** `design-exo-stream-codel-pacing` — design a follow-up to the fixed `buffer` option used by `@endo/exo-stream` readers (origin: maintainer note on endojs/endo-but-for-bots PR #832, discussion `r3885564599`).

**What I did**
- Studied the actual `@endo/exo-stream` protocol on the `llm` branch: the sync/ack credit chains, the initiator credit loop in `iterate-reader.js`, the producer gate in `reader-pump.js`, the push-based `makeBufferedReader`, and the `readableblob-lines.md` design the ask hangs off (fetched from PR #832's head since it isn't merged yet).
- Wrote `designs/exo-stream-adaptive-pacing.md` (Proposed) — an **opt-in, consumer-side, CoDel-inspired credit controller**. Key decisions, all covered per the brief:
  - **Where the policy belongs:** the initiator (consumer) side; the producer is unchanged, so consumer credit implicitly controls producer pace and buffer size.
  - **Signals & control loop:** item *sojourn* (local prefetch age, no round-trip term) as the CoDel signal, plus starvation and fill latency; CoDel governs the ceiling by **withholding credit** (lossless, never dropping), additive-increase governs the floor, escalating `interval/sqrt(count)` reduction cadence. A validated `stateDiagram-v2`.
  - **alpha:** a single monotone dial for relative aggressiveness, retained regardless of any default change.
  - **CapTP & cancellation, compatibility, limits/failure, verification plan:** all present. Numeric `buffer` stays bit-for-bit unchanged; wire format unchanged; push-based readers explicitly out of scope; injected monotonic clock with a count-based degraded fallback; hard `max` cap and `min ≥ 1` floor; all timing initiator-local (a hostile responder cannot inflate the window).
  - **`ReadableBlob.lines(buffer = 0)` left unchanged** — adaptivity is selected consumer-side at `iterateReader`, not by `lines`; a future default flip is gated behind adoption evidence.
  - Four open questions (defaults calibration, alpha decomposition, a writer-side dual "to be filed," the possible default flip).
- Validated: prettier clean on both files; the mermaid fence passes `mermaid.parse`.
- Updated `designs/README.md` (summary-table row + "Recently added" note) per the project's design conventions.
- Committed on `design/exo-stream-adaptive-pacing`, pushed, and opened **draft PR endojs/endo-but-for-bots#1084** against `llm` via `ensure-pr.sh` (needed `GARDEN_ENSURE_PR_LIST_LIMIT=800` — the open-PR marker scan truncated at the default 200). Diff is exactly the two files.

**What changed:** two new/edited files on a design branch; one draft PR.

**Follow-ups:** PR #1084 is left **draft** for the auto-staged design-panel gauntlet. Open questions in the design need maintainer input (notably the loopback-calibrated defaults and whether the writer-side dual is in scope). No inbox messages pending.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-exo-stream-codel-pacing.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (3579444 cached reads)
- Output: 32886 tokens
- Cost: $3.6011840000000004
- Wall-clock: 528s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
