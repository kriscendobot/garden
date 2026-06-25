Worktree torn down, inbox empty. Work complete.

---

## Completion report: `endojs-endo-but-for-bots-pr416-refresh`

**Directive** (kriskowal, PR #416): "Please refresh. The pi harness has merged and the shape of that informs mapping messages to the Pi tree. Also please respond to [#issuecomment-4780562528]."

**What I found.** The branch `pc-agent-tools-and-agentry-designs` was already current with `llm` (no rebase needed). The substantive refresh was reconciling the design docs with the merged pi harness and pinning the mapping the maintainer flagged. Verified against code:
- **#290** merged the pi harness (`c4755248a`): lal now drives `@earendil-works/pi-agent-core`; `makeAgent` composes the same loop.
- **#125** added the per-message revision log (`editMessage` / `messageHistory` / `done`, stored in `revisionsByNumber`) in `packages/daemon/src/mail.js`, a second axis orthogonal to the `replyTo` reply-to tree.
- The `packages/conversation-tree` adapter already bridges daemon `replyTo` → tree-node `parentId`. Confirmed the comment's claimed symbol names match reality (`replyTo` is the daemon field; `parentId` is the pi/tree-node field).

**What changed** (commit `398de6838`, pushed to the PR branch):
- `designs/agentry-agent-builder.md`: new section **"Mapping pi's session tree to the daemon mail model"** pinning the invariant *the reply-to tree is the sole branch axis; the per-message revision log is strictly intra-node and never forks*; new Design Decision 12; #290/#125 added to the Dependencies table.
- `designs/endopi.md` § Session model: added the revision-log row and a reconciling note (this is where the comment said the gap was), closing "which revision was current when a reply branched off a node." Bumped `Updated` to 2026-06-25.
- `designs/README.md`: synced the endopi `Updated` date.

**Response posted** ([#issuecomment-4803571477](https://github.com/endojs/endo-but-for-bots/pull/416#issuecomment-4803571477), as kriscendobot): top-level summary naming the head SHA, the doc changes, and an explicit adoption of recommendation #4780562528 with the mapping table, reconciled to the merged code. Design-only docs, so no tests/lint to run.

**Follow-ups:** none. The #305 UI decision (branch user edits rather than overwrite) is referenced in the design, not owned by this PR.

**Self-improvement:** nothing this time.
