---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 284
upstream_mirror_repo: null
upstream_mirror_pr: null
created_at: 2026-05-21T12:12:00Z
last_appended_at: 2026-05-21T12:12:00Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#284

Created from the code-panel verdict (23 seats, in-band fallback) on the
retention-paths Phase 1 PR (`feat/daemon-retention-paths-phase-1`) on the
2026-05-21 close-review round (kriskowal directive 2026-05-21T11:44Z:
"rebase + run the gamut again + add to bulletin board for close review").
The PR collapses the design's Phase 1 (snapshot API), Phase 2 (subscription
API), and Phase 3 (CLI) into one mergeable change. Four deferrals warrant
revisit when the PR merges; three are design-side phases that land as
follow-on PRs against `llm`, and one is a rebase-hygiene reminder.

## Items

- [ ] **Phase 2: Chat UI panel for retention paths.**
  **Source juror(s)**: archivist, integrator.
  **Round**: 1.
  **Recommended action**: open a follow-up PR adding the paths affordance
  on every value in Chat (per `designs/daemon-retention-paths.md` § Chat
  UI § Reveal button on every value), a floating Paths panel subscribed
  via `followRetentionPaths`, and the in-panel pet-name removal
  affordance. Phase 1 ships only the daemon + CLI surface; the Chat UI
  is the user-facing payoff and the design's primary motivator.

- [ ] **Phase 4: per-path delete-pet-name and per-value
  Disincarnate / Reincarnate.**
  **Source juror(s)**: locksmith, archivist.
  **Round**: 1.
  **Recommended action**: open follow-up PRs against `packages/chat/`
  (and any daemon-side host-method additions required) for per-path
  "Delete pet name on this path" with confirmation, and a per-value
  Disincarnate / Reincarnate toggle. These are write-side affordances
  the design's *Phase 4 (Chat write affordances)* names; Phase 1 is
  read-only.

- [ ] **Refactor of `graph.js`'s private `listRetentionPaths` and
  finer-grained edge-event topic.**
  **Source juror(s)**: assessor, engine-realist.
  **Round**: 1.
  **Recommended action**: when Phase 2 (Chat UI) ships and the
  retention-path surface has a real consumer's load pattern, refactor
  `packages/daemon/src/graph.js`'s private `listRetentionPaths` to
  shape its output at the graph layer (instead of the host-layer
  rewrite in `daemon.js`). Same follow-up: introduce a sibling
  `formulaGraphChangeTopic` (or extend `formulaChangeTopic`) to carry
  edge-add / edge-remove events so the subscription's recompute can
  be skipped when the graph is structurally unchanged. Phase 1 uses
  `formulaChangeTopic` as the coarse change signal; the deferral is
  named in the design's *Known Gaps and TODOs*.

- [ ] **CapTP wrapping discipline for `listRetentionPaths` if
  `RetentionPathSegment` gains remotable fields.**
  **Source juror(s)**: curator.
  **Round**: 1.
  **Recommended action**: note for the Phase 2 (Chat UI panel) author.
  The current `host.js:1565-1568` wraps `followRetentionPaths` in
  `makeIteratorRef`, but `listRetentionPaths` returns the raw array
  through CapTP. Pass-through is acceptable for an array of plain
  records; if a future iteration adds remotable fields to
  `RetentionPathSegment` (e.g., a back-reference to the formula
  controller for click-through), the wrapping discipline needs
  revisiting.

- [ ] **Rebase against current `origin/llm` head before merge.**
  **Source juror(s)**: integrator.
  **Round**: 1.
  **Recommended action**: at merge time, the steward (or weaver) rebases
  the PR onto current `origin/llm` head. As of 2026-05-21T12:12Z the PR
  is 3 commits behind (`merge-base 751c9628c`, `llm head ea8f5bfb5`);
  GitHub reports `MERGEABLE` so this is a hygiene item rather than a
  conflict. The diff vs current `origin/llm` shows a phantom
  `designs/forge-gap-analysis.md` deletion that disappears on rebase
  (the file was added on llm after the PR's merge base).
