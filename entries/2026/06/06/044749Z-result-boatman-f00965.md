---
ts: 2026-06-06T04:47:49Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/06/044451Z-dispatch-liaison-f00965.md
---

Shape-2 re-ferry of the retconned bots#351 onto endojs/endo#2422 (`kriskowal-ponyfill-host-module`). Pure structural regroup: replaced the PR's 14-commit history with the clean 4-commit shape; net content unchanged.

**Source.** endojs/endo-but-for-bots#351, head `d52d2e2b6` (fetched via `refs/pull/351/head`, verified). The 4 commits oldest→newest: `e3f0e262f` feat(ses): StrictModuleDescriptor type, `158b22f9d` feat(compartment-mapper): host module exits, `caa766b6b` test(import-bundle): round-trip bundleSource and importBundle with an exit and condition, `d52d2e2b6` docs(changeset): host module exits. All originally endolinbot.

**Recompute.** Detached at `origin/master` (`5865ff102`, verified against `git ls-remote origin refs/heads/master`). Cherry-picked the 4 in order, clean (no conflicts). Author+committer normalized to `Kris Kowal <kriskowal@kriskowal.com>` on all 4 via rebase `--exec ... commit --amend --reset-author`. No `(#351)` subject suffixes present. Bodies carry `Mirror of endojs/endo#2422.` (upstream-equivalent reference to this very PR; not a trailer, kept per body discipline). TRAILER GATE: `interpret-trailers --parse` empty on all 4.

**Net-content fidelity (load-bearing).** Recomputed `+`/`-` content hunks (file headers excluded) == `gh pr diff 351` content hunks: 382 lines each side, byte-identical after sort. 20 files, matching. Confirms the regroup carried the same content.

**Force-push.** `git push --force-with-lease=kriskowal-ponyfill-host-module:a509e0e66... origin HEAD:refs/heads/kriskowal-ponyfill-host-module` → `+ a509e0e66...118f7bbc6 (forced update)`. Lease held against the prior tip.

**New #2422 head:** `118f7bbc66d51b3883b60a6515d3f5d1effef43d` (short `118f7bbc6`).

**Post-push verify.** 4 commits, MERGEABLE, reviewDecision APPROVED. Both prior approvals persist (endo master not branch-protected): **dckc APPROVED** and **boneskull APPROVED**, both anchored to old ancestor `1bf012f0b` (undisturbed by the force-push). naugtur/erights/kriskowal/dckc COMMENTED reviews also retained. Title/body left unchanged.

**CI.** Re-triggered fresh on the new head; all checks pending at report time (build, cover, lint, the test/test262 matrices, test-xs, test-hermes, test-ocapn-python, viable-release, zizmor, check-action-pins). Did not wait.

**Cross-link.** Edited existing garden-side comment id `4576217955` on endo-but-for-bots#351 in place to `Mirror of https://github.com/endojs/endo/pull/2422 (head 118f7bbc6).`. No upstream-side comment (retired). No comment on endojs/endo.

**Identity.** `gh auth status` showed kriskowal active (push:true, admin:true on endojs/endo) throughout; per-commit `-c user.name/email` override of the worktree bot-identity pin.

Self-improvement: nothing this time. The Shape-2 procedure, trailer gate, and the sort-based net-content-hunk fidelity check (382 lines, byte-identical) all ran exactly as the pr-handoff skill prescribes; the regroup-not-content-change framing held end to end with no gaps in the playbook.
