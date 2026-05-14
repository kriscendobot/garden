---
ts: 2026-05-14T22:21:00Z
kind: result
role: gardener
project: garden
refs:
  - entries/2026/05/14/221128Z-dispatch-liaison-7d4081.md
  - entries/2026/05/14/215412Z-message-steward-c7f920.md
  - entries/2026/05/14/220015Z-message-steward-d3e810.md
  - entries/2026/05/14/221015Z-message-steward-f12b30.md
  - entries/2026/05/14/214954Z-message-understudy-c124ea.md
---

# Result: gardener bundle — four role-edits + kriskowal/garden re-activation

Dispatch `7d4081` landed in six commits on `main` (rebased twice during the engagement onto unrelated `library-lookup` and `vocabulary` commits; both rebases were clean apart from a single CLAUDE.md inventory-list merge).

## Commits pushed

1. `09d4807` — **`roles/understudy/AGENT.md` (new) + `CLAUDE.md`** inventory update. New role file. Posture: bounded authority, user reachable. Reads `roles/COMMON.md` plus its own brief (not layered on the liaison). Skills: `journal-sync`, `dispatch-worktree`, `inbox-drain` partition for `understudy`, `self-improvement`; explicitly does **not** load `autonomous-loop-pacing` (no self-scheduling). Handoff shape from steward: explicit `to: understudy` message with work inlined (preferred) or pointer to a prior dispatch / result. No standing monitors, no PR-creation-flow scan. CLAUDE.md inventory now lists `understudy` and the third-posture-row sentence under *Current inventory*.
2. `0881366` — **`roles/liaison/AGENT.md`** cross-link. Posture section names the understudy as the third row and notes the three are siblings (not parent-child). Active-set enumeration in *Translate user prompts to a role* includes `understudy`.
3. `45c0855` — **`roles/steward/AGENT.md`** four sections: (a) *Parent-context Monitor invariants* names the two `Monitor` task instances (daemon-log tail + inbox drain) the steward keeps continuously alive, with the per-cycle `TaskList` verification step and the two observed inbox-lag gaps as motivation; (b) *Issue surveillance on project repos* establishes that issue-class events are loud-by-default for every active standing-monitor repo, with the per-skill table tuning but not undercutting the floor; (c) *Design-to-PR pipeline* names the new per-cycle obligation (inventory uncovered designs on the roadmap branch; concurrency cap = 1 builder; continue until backlog clears; cites the new skill); (d) re-adds the `kriskowal/garden` row to the *Standing monitors* table (cadence 60s) and updates the prose to name the maintainer's 2026-05-14 authorization. Per-cycle procedure step 2 (*Survey*) gains the *Verify the parent-context Monitors* sub-step; step 3 (*Dispatch*) names the design-to-PR scan and the role-asymmetric `Agent` invocation for the garden monitor.
4. `a4448e6` — **`roles/monitor/AGENT.md`** restores the active mapping `garden → kriskowal/garden → skills/monitor-garden/SKILL.md` (re-activated note cites the authorization message), removes it from the dormant list.
5. `194dffe` — **`skills/monitor-garden/SKILL.md`** removes the DORMANT banner (the top blockquote); the body (project facts, posture, dispatch-role-asymmetry, per-class reaction table) is preserved verbatim. *Notes from the field* gains a 2026-05-14 re-activation entry citing the authorization chain.
6. `c065e86` — **`skills/design-to-pr-pipeline/SKILL.md` (new) + `CLAUDE.md`** inventory addition. The skill codifies inputs (`project_slug`, `repo`, `roadmap_branch`, `design_paths`), the "what counts as covered" rule (load-bearing path reference on an open or merged PR; closed-not-merged does **not** cover), the procedure (walk roadmap branch design directories, search PRs per design slug, compute uncovered set, check concurrency cap, dispatch builder with purpose slug `draft-initial-pr-<design-slug>`), the builder's brief (base = roadmap branch; initial PR = stub-checklist OR placeholder-readme OR initial-pass skeleton, builder picks per design shape), and composition with `design-queue-drift-check` (drift-check classifies; this skill dispatches for the eligible head).

## Understudy posture summary

Third row on the matrix beyond liaison (excess authority, user in loop) and steward (bounded, no user): **bounded authority, user reachable**. Acts directly within the same bounds the steward holds, asks the user (the way the liaison would) only when a decision genuinely exceeds those bounds. Reads `roles/COMMON.md` + `roles/understudy/AGENT.md`; does **not** layer on the liaison's brief. Watches the journal for `to: understudy` (or broadcast `*`) handoffs; sits idle between them.

## Design-to-PR pipeline shape

Inventory uncovered designs on the project's roadmap branch (today `llm` on `endojs/endo-but-for-bots`); concurrency cap = 1 builder across the estate; dispatch a builder with purpose slug `draft-initial-pr-<design-slug>` for the next uncovered design when the cap is free; run cycle-after-cycle until the backlog clears. The skill defines "covered" as a load-bearing reference to the design file path on any open or merged PR (closed-not-merged does not cover). The provisional rule from `221015Z-message-steward-f12b30.md` is the starting point and the skill tightens it to require the canonical path rather than a slug-only mention.

## kriskowal/garden re-activation citation chain

Maintainer authorization in the liaison session at ~2026-05-14T21:58Z, recorded by the steward at `entries/2026/05/14/220015Z-message-steward-d3e810.md` per the DORMANT banner's protocol. All four edits land in this engagement: the standing-monitors row re-added (steward), the active mapping restored (monitor), the DORMANT banner removed (monitor-garden), and the *Notes from the field* entry citing the authorization message lands inside the skill itself. The dispatch role asymmetry note (steward dispatches `liaison`, not `monitor`) is preserved.

## Self-improvement

Single observation: when a maintainer routes four discrete items in three consecutive `message` entries from the steward, the natural shape is one gardener dispatch with four well-scoped tasks rather than four serial dispatches. The bundling worked cleanly here (six commits, two clean rebases, one CLAUDE.md inventory-line merge); the role file already prefers bundling and this dispatch confirms the preference. No rule change owed; just an observation reinforcing the existing rule.

Self-improvement: nothing this time.
