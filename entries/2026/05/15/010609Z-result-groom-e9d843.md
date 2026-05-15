---
ts: 2026-05-15T01:06:09Z
kind: result
role: groom
project: endo
worktree: dispatches/groom--e9d843/project
repo: endojs/endo-but-for-bots
refs:
  - entries/2026/05/15/010018Z-dispatch-liaison-e9d843.md
  - entries/2026/05/15/005358Z-result-groom-9cfd4e.md
---

# Result: groom targeted M½ extraction on `designs/README.md` (llm branch)

Commit on llm: `f4b39716f` "groom(designs): extract Milestone ½ for project-hygiene work" (+86 / -37; 123 lines changed).
Tip before push: `56d3275ea` (the prior groom commit). Push succeeded first try against fresh fetch.

## Sub-mode

Targeted post-event reconciliation. The dispatch named one structural change (extract M½) following directly from the prior groom's self-improvement note ("Is M1 the right home for build-system hygiene like `break-dev-dependency-cycles`, or should an M0.5 / M-side bucket exist?"). No velocity recalibration, no full dependency-graph re-survey; the velocity numbers from the 2026-05-14 round still hold and only bucketing changed.

## Two-question criterion application

The dispatch's criterion was "(a) not user-facing capability AND (b) prereq or substrate-cleanup for M1 capability work". I walked the 22 M1 rows and applied it:

**Moved to M½ (6 rows):**

- `endo-bytes` (Implemented): shared `Uint8Array` helper package, factor-out of duplicates. Not user-facing.
- `chat-playwright-smoke` (Complete): CI smoke gate, not a feature.
- `hex-package` (In Progress): shared hex ponyfill, factor-out of four ad-hoc implementations.
- `break-dev-dependency-cycles` (In Progress): build-system, dissolves the workspace devDep SCC so turbo's `^build` form runs clean. Explicitly the row the prior groom flagged.
- `ci-no-npm-lifecycle` (Not Started): CI supply-chain posture (`enableScripts: false`).
- `base64-native-fallthrough` (Not Started): `@endo/base64` performance fallthrough to native intrinsics.

**Kept in M1 (capability work or daemon-internal core):**

- `endo-gateway`: per-host HTTP virtual host is a user-facing service. Stayed.
- `daemon-content-store-gc`, `daemon-cross-peer-gc`, `daemon-guest-eval-simplification`: daemon-internal, closer to capability scope than to project hygiene. Stayed.
- `daemon-locator-terminology`, `daemon-rename-to-manager`: API cleanup but daemon-scoped, kept with the rest of the daemon-renaming family.
- All other M1 rows are clear capability work (docker-selfhost, agent-tools, platform-fs, mount, etc.).

`endo-gateway` was explicitly NOT moved despite being recently added; it lifts hosting out of per-user Daemon and closes issue #173, which is user-visible.

## Substantive diff (one file, one commit)

`designs/README.md` only. Changes:

- **Header `Last updated`**: annotated with "(M½ project-hygiene milestone extracted from M1)".
- **New § Milestone ½: Project Hygiene** inserted between M0 and M1: goal paragraph stating the two-question criterion, six-row table, exit criterion, estimated duration of ~1-2 weeks remaining.
- **§ Milestone 1 table**: six rows removed; M1 drops from 22 rows to 16 (10 remaining + 6 completed/implemented).
- **§ Size and Time Estimates → Per-Design Estimates**: six rows' Milestone column updated from `1` to `½`.
- **§ Size and Time Estimates → Per-milestone aggregate**: added an M½ row (2 completed designs).
- **§ Summary by Milestone**: added M½ row (4 remaining), M1 row dropped from 14 to 10 remaining and 10-13 → 8-10 weeks. Total-remaining count is invariant (52); only bucketing changed.
- **§ Timeline → Mermaid Gantt**: M½ section inserted with `2026-03-06, 2w`; M1 changed from `2026-03-06, 12w` to `after mhalf, 10w` so the chain re-flows. The Mermaid `after mN` chain stays correct because mhalf is upstream of m1.
- **§ Timeline → Duration table**: M½ row inserted (1-2 weeks); M1 row's duration 10-13 → 8-10 weeks; cumulative columns and target-date language re-projected. M2 target moves from "Late August to mid-September" to "Mid August to early September"; later milestones shift correspondingly.
- **§ Timeline → critical path footnote**: "Milestones 0, 1, and 2 form the critical path" updated to "Milestones 0, ½, 1, and 2".
- **§ Strategic Early Items → Progress as of**: appended a paragraph documenting the M½ extraction, the criterion applied, the six rows moved, and `endo-gateway`'s reason for staying in M1.

## What I did not change

- No velocity recalibration. The S/M/L ratios from 2026-05-14 (0.7 / 1.2 / 1.3) still hold; the data did not change, only the bucketing.
- No dependency-graph edit. The graph's nodes for the moved designs (`@endo/hex`, `@endo/bytes`, etc.) are library-scope and not in the Mermaid block (the block is daemon/familiar/ocapn-scoped subgraphs). No edges needed reclassification.
- No open-questions journal `message`. The dispatch named the criterion and the candidate list; the selection was mechanical. The borderline rows (daemon-content-store-gc, daemon-cross-peer-gc, daemon-guest-eval-simplification, daemon-locator-terminology, daemon-rename-to-manager) were kept in M1 with brief reasoning above; if the maintainer wants a tighter M½ (or wants the daemon-rename family extracted too), that's a one-line follow-up dispatch.
- No edits to design files' own metadata. The Milestone column lives in the README's per-design estimates table; design-file frontmatter does not carry a milestone field.

## Push

`git push origin HEAD:refs/heads/llm` succeeded first try (FETCH_HEAD matched `56d3275ea`; no concurrent groom). GitHub printed the dependabot vulnerability summary banner on push, unrelated to this commit.

## Identity

Author and committer pinned by `dispatch-prepare.sh` to `endolinbot <main.barn5084@fastmail.com>`. No `Co-authored-by` / `Generated with [Claude Code]` trailers.

Self-improvement: the prior groom's self-improvement note pointed at this exact reshape, and the dispatch closed it on one targeted pass. The skill machinery worked as designed (self-improvement note → liaison-side dispatch → targeted reconciliation). No new skill or role edit warranted. One thing worth noting for the next groom: the M½ goal paragraph names a two-question criterion that future grooms (or the maintainer) may want to apply preemptively when classifying new designs (the prior groom added `break-dev-dependency-cycles` to M1 without flagging it as hygiene, and only the post-pass self-improvement caught it). A skill-level note about "when adding a new row to a milestone, ask the two-question test first" might compound, but it is below the threshold for a skill edit on a single observation.
