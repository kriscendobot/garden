---
ts: 2026-05-29T05:29:51Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/05/29/052712Z-dispatch-liaison-1947d5.md
  - entries/2026/05/29/052950Z-message-boatman-7afc31.md
---

Ferried kriscendobot/endo#1 upstream to endojs/endo as a first-time Shape-1 ferry.

- Source: kriscendobot/endo#1, branch `fix/3289-install-engines-retry`, head `82f66580` (single commit, bot-authored). Bot-side frozen base `master-052b048` was NOT carried upstream.
- Upstream PR: https://github.com/endojs/endo/pull/3291 (DRAFT, per dispatch).
- Upstream branch: `kriskowal-3289-install-engines-retry`, base `master`.
- Upstream head SHA: `44b80546d6b714d559e92436821e0ab33e353093` (short 44b80546).

Mechanics: detached at upstream master tip `c49fb048`, cherry-picked the source commit, then `commit --amend --reset-author` to rewrite author and committer to `Kris Kowal <kriskowal@kriskowal.com>`. Stripped the `(#3289)` subject suffix, removed the redundant inline `(endojs/endo#3289)` body parenthetical, and added a `Fixes #3289` trailer (upstream issue #3289 is OPEN, so the close-reference is valid). The one-file diff (`packages/benchmark/install-engines.sh`) is byte-identical to the source.

Attribution + trailer verification: PASS. `git log master..HEAD --pretty=fuller` shows Kris Kowal as both author and committer on the single commit; `interpret-trailers --parse` is empty (no Co-Authored-By, no Generated-with-Claude-Code).

CI at ferry time: all 18 checks pending (browser-tests, build, check-action-pins, cover, lint, test matrix, test-async-hooks, test-hermes, test-ocapn-python, test-xs, test262, viable-release, zizmor). Not waited on; shepherd handles CI-driven follow-up. Note: this PR's purpose is to de-flake the test-xs install-engines step, so test-xs is the bellwether check.

Cross-link: garden side posted at https://github.com/kriscendobot/endo/pull/1#issuecomment-4570986927 (`Mirror of https://github.com/endojs/endo/pull/3291 (head 44b80546).`). Upstream side handed to steward via the message entry above (no steward running this session).

Self-improvement: nothing this time. The project worktree's `origin` is the live ssh remote for endojs/endo (not the bare clone the dispatch prompt described), and `git push origin HEAD:<branch>` needed the fully-qualified `HEAD:refs/heads/<branch>` form because no remote-tracking branch matched the short name; both are environment quirks, not skill gaps.
