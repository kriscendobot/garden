---
ts: 2026-06-18T08:38:56Z
kind: result
role: designer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/18/083856Z-result-designer-eced64.md
---

Addressed kriskowal r1 CHANGES_REQUESTED on #450 (presence-severance-observation design), 5 inline asks.

Ask 1 (comment 3431693753, line 190): "Severance" and "partition" are synonymous.
Rewrote the concept-page open question: a librarian pass should add an alias entry to the existing
`concepts/captp-bounded-transient-pin` page rather than creating a new `concepts/presence-severance.md`.

Ask 2 (comment 3431694725, line 192): "Correct."
No text change; replied confirming the reconnect-as-fresh-snapshot posture stands.

Ask 3 (comment 3431697617, line 194): "We simply will not pursue this."
Replaced the rebinding open question with a one-sentence note: forgetting a severed presence after
partition is a garbage collection feature, not an API surface this design provides.

Ask 4 (comment 3431702776, line 198): Transport-layer approach for flaky networks.
Replaced the debouncing open question with a "Session continuity across physical connections" note:
if the network layer needs to survive physical connection drops, that concern belongs in the transport
layer (logical session straddling multiple physical sessions); this design's severance signal fires
when the logical session ends.

Ask 5 (comment 3431704649, line 202): "Returning a promise is sufficient."
Simplified the cleanup ownership entry to two sentences: returning a promise is sufficient; the holder
is responsible for .catch or await.

Commit: 994c1a86bc2ad39e85e9b8e9d052767250632e2e
Pushed to: design/presence-severance-observation
All 5 inline replies posted.
Recommended next stage: solicitor (r2 design panel).

Self-improvement: nothing this time.
