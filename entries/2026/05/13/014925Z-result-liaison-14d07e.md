---
ts: 2026-05-13T01:49:25Z
kind: result
role: liaison
project: garden
to: "*"
refs:
  - entries/2026/05/13/014210Z-dispatch-liaison-9c3ae6.md
  - entries/2026/05/13/014744Z-result-gardener-363f6c.md
---

# Orchestrator closure: journalist role landed

Gardener subagent returned cleanly from dispatch `9c3ae6`; dispatch root torn down. First real exercise of the `gardener` role.

What landed on `main`:

- `0b0b464` — `roles/journalist/AGENT.md` (65 lines, gardener-authored, dated 2026-05-13). Role description, posture (the journalist consumes data the review-queue daemon and the per-PR roles produce; it does not poll GitHub), skills list, operating norms, definition of done.
- `c5c1207` — inventory and interlock: `CLAUDE.md` § Current inventory lists `journalist`; `roles/liaison/AGENT.md` § Translate user prompts to a role enumerates it; `roles/review-queue/AGENT.md` clarifies that the journalist owns the bulletin rewrite for *Pending kriskowal reviews* while the review-queue still owns the daemon and the canonical-set data; `roles/steward/AGENT.md` § Subordinate roles dispatched names the journalist with its dispatch triggers (after any ADD or REMOVE since the prior cycle, plus on each cycle's housekeeping pass when the designs or PR backlog has moved).

Design choice (the gardener's report, summarized): the milestone-mapping rule is a lookup against `endo-but-for-bots@llm:designs/README.md` § Per-Design Estimates, which has an integer-milestone column for every design. The journalist matches each PR row in three passes: (1) PR title slug against design filename (case-insensitive, Conventional-Commits-style); (2) PR-number cross-reference in the README's Notes column; (3) repository-binned fallback for anything that does not match. The roadmap is `endo-but-for-bots`-specific by design, so non-endo PRs (Agoric, agoric-labs, cosgov, etc.) land in the per-repo fallback bins. Section-ownership split: journalist owns *Pending kriskowal reviews* and the milestone-organized portion of *PR backlog*; everything else stays with the role that posts to it.

Out of scope this dispatch (deliberately): the journalist's first real bulletin rewrite. That fires when the steward next picks up an ADD/REMOVE from the review-queue daemon under the updated subordinate-roles list.

Operational note from the gardener (worth flagging): when the orchestrator (me) writes a `dispatch` journal entry *after* `dispatch-prepare.sh` has materialized the subagent's `journal/` worktree, the subagent's checkout is detached at the prep-time HEAD and does not include the freshly-committed dispatch entry. The same issue is independently surfaced by the other-terminal liaison session in `entries/2026/05/13/014830Z-result-liaison-7e3b9a.md` from the boatman ferry. Fix shape (not done this turn): either (a) `dispatch-prepare.sh` runs `git -C <root>/journal fetch + reset --hard origin/journal` as its last step, picking up the just-pushed dispatch entry, or (b) the orchestrator writes the dispatch entry *before* preparing the worktree triple. Routed to follow-up.

Self-improvement: the gardener role's first dispatch was tight and self-contained, suggesting the role file's shape is right. The journalist's actual classification-pass will be the next exercise; until that runs we will not know if the milestone-mapping rule actually holds against the design README's real shape. Logged as the gardener's own first note from the field.
