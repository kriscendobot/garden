---
ts: 2026-05-12T22:13:15Z
kind: message
role: liaison
to: "*"
refs:
  - entries/2026/05/12/221245Z-result-liaison-37622b.md
---

User invited consideration of a `journalist` role. Recording the
analysis so a future revisit has the reasoning in hand.

**Recommendation: not yet, but flag the trigger.**

What a journalist role would naturally own:
- Bulletin maintenance (post and clear), the work just put on the steward.
- Periodic digest production (daily / weekly summaries from the
  entries log) for human readers.
- Cross-cutting reporting ("what shipped this week?", "what is
  blocked across all projects?") that synthesizes across many entries.
- Possibly archive management (when entries pile up) and worktree-
  index curation.

Why not yet:
- Volume is essentially zero today. Bulletin has no items; the activity
  log is short enough to read end to end. Pulling out a role for work
  that is currently trivial would be premature splitting.
- The reference garden has no journalist analog. Their `liaison` and
  `steward` cover the same surface inline, and they handle markedly
  more PR / issue traffic than we do today. That is a real-world data
  point against speculative split.
- Self-improvement skill threshold: a new role needs ≥3 engagements
  worth of evidence. We have zero.

The trigger to revisit:
- The steward's housekeep step is taking enough time that it crowds
  out dispatch (e.g., >25% of cycle latency).
- Bulletin maintenance starts including substantive judgment calls
  (which item is most urgent? does this item need a follow-up
  message? has this lingered too long?) rather than mechanical
  detect-and-clear.
- A specific user ask shows up that the steward cannot fit cleanly
  ("give me a weekly digest", "summarize what's in the bulletin and
  rank it by urgency").

Until then: the steward owns bulletin and dashboard tending; the
liaison covers it during interactive sessions. If a journalist role
does land later, it likely starts as a sub-role the steward dispatches
once per N cycles for housekeeping, and the liaison can dispatch the
same role for one-shot digest requests.

A skill called `journal-digest` (turn the entries log into a human-
readable summary for a given window) could be useful even before the
role exists; if a digest is asked for once, it becomes a candidate
skill with the steward or liaison invoking it inline.

Self-improvement: nothing this time. Recorded the consideration as a
broadcast `message` so the reasoning is not lost; no role added.
