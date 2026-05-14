---
ts: 2026-05-14T06:06:52Z
kind: result
role: boatman
project: endo
worktree: dispatches/boatman--re-ferry-syrup-frame-109--20260514-055543--1e1ee4/project
repo: endojs/endo
to: liaison
refs:
  - entries/2026/05/14/055635Z-dispatch-liaison-cf8e02.md
  - entries/2026/05/13/014830Z-result-liaison-7e3b9a.md
  - entries/2026/05/14/060538Z-message-boatman-355658.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 109
    role: source
  - repo: endojs/endo
    pr: 3256
    role: target
---

Re-ferried `endojs/endo-but-for-bots#109` -> `endojs/endo#3256` to incorporate the package rename and the thousands-separator chore.

- Upstream PR: https://github.com/endojs/endo/pull/3256
- Upstream branch: `endojs/endo:feat/syrups-package`
- New upstream head SHA: `acddddba16d524c8eb16d71fb35c43f34fa491ae` (force-pushed over prior `ed80869d4fe2b325a13e8bf2639f0422f3fae57c`)
- Source PR: https://github.com/endojs/endo-but-for-bots/pull/109 (head `642ce3fd6b8c5ff0d3cae7657eaa42145810662a`; cross-link comment https://github.com/endojs/endo-but-for-bots/pull/109#issuecomment-4448086971 posted)

Approach: same as prior ferry. `git diff fa0b6a9ad..642ce3fd6 | git apply --index` onto a fresh branch off `upstream/master`, single squashed commit. The merge-base with upstream master is unchanged (`fa0b6a9ad`). Diff stat is 17 files, +1500/-31 — identical shape to the prior ferry; the rename and the underscores chore are net-neutral to line count, and the squash naturally elides the unrelated PR #84 hardened-url-shim merge and its compensating fixup as before.

Verification clean: `git log upstream/master..HEAD --pretty=fuller` shows author and committer `Kris Kowal <kris@cixar.com>` on the single commit; `git interpret-trailers --parse` returns empty. The commit message uses the upstream PR template's section headings (Description, Security, Scaling, Documentation, Testing, Compatibility, Upgrade) and drops the source's fork-only `Refs: #29 #108` line.

Force-push used `--force-with-lease=feat/syrups-package:ed80869d4fe2b325a13e8bf2639f0422f3fae57c` to fail safely if anything else had advanced the upstream branch in the interim. The lease accepted; push succeeded.

**Identity discipline**: PR #3256 is on a primary repo (`endojs/endo`), so the title edit, body edit, and the explanatory force-push comment all route via the steward, not direct from the boatman. The proposals are in `entries/2026/05/14/060538Z-message-boatman-355658.md`. The source-side cross-link on #109 (a non-primary repo) was posted directly under kriskowal: https://github.com/endojs/endo-but-for-bots/pull/109#issuecomment-4448086971.

**Open question for liaison/user**: the upstream branch `feat/syrups-package` would arguably want renaming to `feat/syrup-frame-package` to match the renamed package. Doing so means deleting the existing branch (closing PR #3256, since GitHub does not retarget) and opening a fresh PR off the new branch. Not done in this dispatch; the existing PR has review weight worth preserving. Decision deferred.

Self-improvement: nothing this time. The re-ferry was structurally identical to the first ferry, and the same procedure (squash via merge-base diff onto a fresh branch, verify attribution, force-push with lease) carried through cleanly. The pr-formation skill's discipline (template sections, no file callouts) made the body-redraft mechanical.
