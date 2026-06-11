---
ts: 2026-06-11T05:35:03Z
kind: message
role: liaison
to: liaison
project: endo
---

Structural lessons from the endo-strategy sub-orchestration (`liaison--32c83f`), routed per skills/self-improvement (structural → message to liaison; gardener candidates):

1. **Essay-authoring has no home in the role library.** The maintainer's brief commissions "a journalist per essay", but `roles/journalist/AGENT.md` is bulletin-rendering only; every Workstream B/C dispatch needed an inline role-stretch disclaimer. Either widen the journalist role file with an essay/periodical-authoring engagement kind (it already has the `daily-progress-summary` periodical precedent) or carve an essayist role. Five Opus-quality essays landed cleanly under the stretch, so the posture works; it just is not encoded.

2. **`skills/model-selection` lacks an engagement-kind override row.** The journalist's Sonnet row reflects bulletin maintenance; essay composition is squarely the Opus tier definition ("composes substantive prose"). I overrode to Opus with rationale recorded in each dispatch entry. The gardener could add either an essay-engagement row or a general "engagement kind trumps role row when the role is stretched by a maintainer brief" note.

3. **Scout role-stretch for reconnaissance worked but is unencoded.** The brief uses "scout" for design-gap reconnaissance; `roles/scout/AGENT.md` is benchmark-only. The scout itself reported the stretch ran cleanly on the role's evidence-discipline spirit. Second observation of recon-shaped scouting would warrant a role-file widening.

4. **Procedural gotcha for `skills/dispatch-worktree`:** when a standing-monitor worktree has the target branch checked out from the same bare clone (here `llm` on `endojs-endo-but-for-bots.git`), the prepare script's `fetch +refs/heads/<branch>:refs/heads/<branch>` is silently refused ("refusing to fetch into branch ... checked out at ...") and the project worktree comes up at a STALE tip — my scout/designer/journalist worktrees materialized at 68246ad92 (2026-05-11 ledger, pre-renumbering) instead of 72d1c764c. Workaround applied: fetch into a side ref and `git -C project checkout --detach <sha>`. Candidate fix for the script: fetch into `refs/dispatch/<branch>-<id>` (never a checked-out ref) and worktree-add from that. Worth a Notes-from-the-field row and possibly the script fix; one vivid observation, surfaced for the gardener.

5. FYI: scholar `f7892a` separately flagged that `journal/library/conventions.md` has no idempotency anchor for `source_kind: web` (proposed `source_content_hash`); journalist `2a3e67` separately flagged a locale pitfall in the em-dash grep sweep. Both already in their own message entries.

Self-improvement: covered by this message.
