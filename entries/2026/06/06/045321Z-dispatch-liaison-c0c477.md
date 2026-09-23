---
ts: 2026-06-06T04:53:21Z
kind: dispatch
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/06/044451Z-dispatch-liaison-f00965.md
---

Dispatched boatman (dispatch-root `dispatches/boatman--c0c477`) to **strip the self-referential `Mirror of endojs/endo#2422.` line** from all 4 commit bodies on endojs/endo#2422 and force-push. Maintainer-requested cleanup of the procedural reflection the bot's retcon baked into the squashed messages. Pure message rewrite: trees unchanged, content unchanged.

#2422 head `118f7bbc6`, 4 commits (all Kris Kowal), MERGEABLE, APPROVED (dckc + boneskull). The 4 bodies each end with `Mirror of endojs/endo#2422.` (circular on #2422 itself). endo master unprotected, so the tree-preserving force-push keeps the approvals.

Boatman brief: fetch #2422 head `118f7bbc6`; `BASE=$(git rev-parse 118f7bbc6~4)`; detach at BASE; cherry-pick the 4 commits in order (118f7bbc6~3..118f7bbc6); after each, rewrite the message dropping any line exactly `Mirror of endojs/endo#2422.` (and any now-trailing blank), keeping the rest byte-identical, via `commit --amend -F <cleaned-msg-file>` under the kriskowal `-c user.*` override (author+committer stay Kris Kowal). VERIFY tree-preservation: each new commit's `^{tree}` equals the corresponding original commit's tree, and final `HEAD^{tree}` == `118f7bbc6^{tree}`. RUN `interpret-trailers --parse` EMPTY on all 4. Confirm NO `Mirror of` line remains (`git log <BASE>..HEAD --format=%B | grep -i 'mirror of'` empty). Force-with-lease against `118f7bbc6` to `kriskowal-ponyfill-host-module`. Confirm dckc + boneskull APPROVED persist + MERGEABLE. Edit cross-link 4576217955 to the new head. `identity_switch_authorized: true`.

Expected report: new #2422 head, tree-unchanged confirmation (per-commit), no-Mirror-line confirmation, all-4 Kris Kowal + trailers-empty, force-with-lease, approvals-persist, mergeable, edited cross-link.
