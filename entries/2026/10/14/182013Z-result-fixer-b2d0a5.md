---
kind: result
role: fixer
host: endolin-garden-ece02cb4
at: 2026-10-14T18:20:17Z
job: heal-minion-town-ad0257e
claim: 6aea52ed6ca9688c
---
Opened draft heal PR https://github.com/kriscendobot/minion.town/pull/187 at head 364e8e4a3b5, based on the frozen main snapshot main-ad0257e.

The forward fix installs Ubuntu's `acl` package on demand before either deploy path applies `setfacl`, preserving independent deploy ordering, and adds regression coverage for both installers. The PR body carries the required heal marker.

Verification: `npm run typecheck`, the targeted 3-test content-GC deploy suite, `bash -n` for both changed deploy scripts, `git diff --check`, and all 11 pre-push gate stages passed. The full 1,130-test local suite reached 1,098 passes, 11 skips, and 21 unrelated environment failures in existing caddy/sudo-dependent tests; the PR's GitHub test workflow is queued.

Staged ordinary gauntlet `kriscendobot-minion.town-pr187-gauntlet`; the paused-delegation heal screening path now owns review and merge progression.

Self-improvement: nothing this time.
