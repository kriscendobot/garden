---
ts: 2026-05-20T06:07:35Z
kind: result
role: designer
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/designer--3c5dc1/project
---

Round 1 of kriskowal's CHANGES_REQUESTED on PR #266 (design/endopen) addressed. Body "Partial review."; 7 inline comments acknowledged 2026-05-20T06:00Z.

**Substantive design integration** (commit `061c3a8` on `design/endopen`, pushed to origin):

- *Authentication via guest formula identifier as bearer token* (comment 3271518822) folded into `designs/endopen-acp-server.md` as `### Authentication and multiplexing` subsection + *Design Decisions* #4. Bullet removed from *Open Questions*.
- *One adapter multiplexing on formula identifier* (comment 3271520018) folded into same subsection + *Design Decisions* #5. *Multi-tenancy* bullet removed from *Open Questions*.
- *Guest agent as virtual mount for ACP cwd* (comment 3271522272) folded into new `### ACP cwd as a virtual mount on the guest agent` subsection + *Design Decisions* #6. `session/new` lifecycle-table row updated. *Mapping ACP cwd to Endo Mount* bullet removed from *Open Questions*.
- *Updated* metadata field bumped to 2026-05-20 in both the design file and the `designs/README.md` summary row.

**Prettier asks** (comments 3271515258, 3271534288): ran prettier 3.5.3 with the project's config on both files; both already pass `--check` with no diff. No prettier commit needed. For `endopen-concurrent-subagents.md` flagged the underlying visual-width drift in the ASCII panel-widget mockup (58 vs 59 cells; the file uses ASCII box-art, which the designer norm now discourages in favor of mermaid). Offered to convert to mermaid or normalize widths in a follow-up.

**Agreed acks** (comment 3271529318): acknowledged in reply only; decision retained (renumbered #8).

**META item the steward must pick up** (comment 3271527062): "Review the related editMessage design through the lens of satisfying the ACP requirements. Post comments there and dispatch a fixer to address them." Replied "Steward will coordinate the editMessage review separately." Not touched in this dispatch.

**Inline reply ids**:

| comment | reply id |
|---|---|
| 3271515258 | 3271570207 |
| 3271518822 | 3271570848 |
| 3271520018 | 3271571039 |
| 3271522272 | 3271571279 |
| 3271527062 | 3271571374 |
| 3271529318 | 3271571511 |
| 3271534288 | 3271571709 |

**Top-level summary comment**: PR #266 issuecomment-4495054881.

**Pre-push gates**: `pre-push-gates.sh --probes-only --summary` produced findings only on pre-existing lines outside my diff (the script falls back to `origin/master` when HEAD is detached, which expands scope to the full branch divergence). Diff-only check of just my two changed files showed no new findings across `no-ascii-banners`, `no-pull-citations`, `no-inline-import-jsdoc`, `filename-no-stutter`, and `sentence-per-line-md`.

**Push**: `git push origin HEAD:design/endopen` from `061c3a8` (was `8a4dc74`); no errors.

The brief noted more reviews may follow; this dispatch handled round 1 only.

Self-improvement: `skills/pre-push-gates/probes/sentence-per-line-md.sh` and its siblings fall back to `origin/master` when invoked from a detached HEAD whose upstream cannot be resolved by `@{u}`, expanding scope from "my diff" to "everything ahead of master". This is fine for a builder pushing from a feature branch but surprising for a designer dispatched in detached-HEAD mode against a long-lived design branch. A small probe-driver enhancement that takes an explicit `--base <ref>` (or auto-detects the branch from the dispatch root's `journal/worktrees/<host>/<basename>.md` row) would make the gates usable from any dispatch worktree without per-call manual scoping. Recording as a message to liaison.
