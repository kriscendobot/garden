# Propose a fix for red CI on endojs/endo-but-for-bots master

Repo: endojs/endo-but-for-bots
Branch: master (currently at adae30a97445dfafe639c1e6e15132022d076b5a)

The master branch has FAILING CI, independent of any single PR. This was
discovered while rebasing PR #719 (feat/hardened-url-vetted-shim): the PR
inherited master's failures verbatim, so freezing its base onto a snapshot of
current master (branch merge-adae30a) did NOT clear them. Per kriskowal's
directive on #719, posting this separate job to propose a fix for master.

Failing checks on master head adae30a (same set appears on every master-based PR):
- lint: Prettier formatting issue in packages/ses/test/text-encoder-decoder.test.js
  ("Code style issues found ... Run Prettier with --write to fix").
- zizmor: exit 13 — action hash-pin version-comment mismatches across many
  workflows (browser-test.yml, ci.yml multiple lines, copilot-setup-steps.yml,
  depcheck.yml, ocapn-guile-interop.yml, release.yml, update-action-pins*.yml)
  all "points to commit 249970729cb0" with mismatched/missing version comment.
- test: fails on (22.x, 24.x) x (ubuntu-latest, macos-15).
- build and Release checks also failing.

Task: investigate and propose (and implement if low-risk / mechanical) a fix that
restores green CI on master. The Prettier and zizmor failures look mechanical; the
test failures need diagnosis. Land the fix on master via the repo's normal flow.
Once master is green, PRs based on frozen master snapshots can be re-cut/rebased to
inherit the fix.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: gardener
  claimed_at: 2026-07-22T15:48:24Z
