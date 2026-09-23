---
ts: 2026-05-14T18:07:04Z
kind: result
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/14/175815Z-dispatch-liaison-3114c6.md
  - entries/2026/05/14/180519Z-result-boatman-99ec85.md
  - entries/2026/05/14/180506Z-message-boatman-cbd791.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 226
    role: source
  - repo: endojs/endo
    pr: 3255
    role: target
---

Re-ferry of `endojs/endo-but-for-bots#226` to `endojs/endo#3255` closed.

- Upstream PR #3255 force-pushed from `41c6bd4a92` (the old migrate-to shape) to `638306eacce0b58055ac2c6d3f000a0edbd30f4f` (the alias-not-migrate shape per turadg's r3229246963).
- Title rewritten to `feat(eslint-plugin): alias eslint-plugin-import to import-x@4`. Body rewritten per `pr-formation`: endojs/endo template sections, no fork-only references, no checklists, behavior-over-diff. Liaison-side verification confirms author and committer are both `Kris Kowal <kris@cixar.com>` on the single new upstream commit.
- Source-side cross-link comment posted on `endojs/endo-but-for-bots#226`: [issuecomment-4453378793](https://github.com/endojs/endo-but-for-bots/pull/226#issuecomment-4453378793).
- Steward-bound explanatory comment for #3255 drafted at `entries/2026/05/14/180506Z-message-boatman-cbd791.md`; the steward will post on its next cycle under the kriscendobot identity, citing turadg's r3229246963.
- turadg's inline discussion thread on `.changeset/migrate-eslint-plugin-import-x.md` (r3229246963) is anchored on a file whose body changed in the reshape; the inline anchor is expected to detach. The substance was addressed by the reshape and is acknowledged in the steward-bound comment.

This is the fourth recent re-ferry on the same pattern (`#75 → #3232`, `#109 → #3256`, `#223 → #3257`, `#226 → #3255`). The boatman wisdom landed at `entries/2026/05/14/061345Z-result-boatman-bf7290.md` (cherry-pick if upstream healthy; recompute from master if upstream stale) has now seen both branches exercised in adjacent dispatches; future writers of a `skills/pr-handoff/SKILL.md` have the example pair on hand.

Worktree-index marked collected; dispatch root torn down.

Self-improvement: nothing this time. The dispatch went straight through; the bare-clone bootstrap (no `worktrees/endojs-endo.git/` on `kmkmbp2021` before this engagement) is a one-time host-setup cost the prior re-ferries paid on `endolinbot`. A future host-bootstrap skill could capture this, but the cost is small enough that an ad-hoc clone is fine for now.
