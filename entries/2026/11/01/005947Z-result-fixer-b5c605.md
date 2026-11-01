---
kind: result
role: fixer
host: endolin-garden-ece02cb4
at: 2026-11-01T00:59:49Z
job: fix-endojs-endo-but-for-bots-pr1348-confined-command-grammar
claim: fad34cab49c25ed9
---
project: endo-but-for-bots
worktree: /home/kris/garden/scratch/project-wt-fix-end-6377e4b1e0dd-12d22738
pr: https://github.com/endojs/endo-but-for-bots/pull/1348
head: eb7ce77af1b47e37cfbbe07c7c03166b3c7578dc

Completed the maintainer-requested confined-command grammar follow-up and workspace catalog integration. The branch now carries comprehensive agent-command examples and explicit answers for symlink/prefix confinement and pipeline/process-plan separation, composes a granted confined HttpClient, and consistently qualifies colliding workspace records as inspectShell, inspectGitRemote, fetchGitRemote, and fetchHttp while preserving standalone-maker names. Cleared the deterministic abbreviated-identifier findings in the command-grammar slice, pushed the branch, and posted the required PR summary.

Verification: pre-push gates passed all 13 stages; exo-shell lint plus 25 tests passed; agent-tools lint had 0 errors and its workspace suite passed 17 tests; agentry lint had 0 errors and its targeted suites passed 7 tests; root TypeScript passed. The regression probe deliberately mapped HTTP fetch to fetchGitRemote, observed four expected workspace failures including the catalog collision, then restored fetchHttp and returned the suite to green.

CI is not green for environment reasons unrelated to this diff: six Ubuntu-only jobs fail after the ubuntu-latest migration (missing tred and a pre-existing bwrap parent-death test completing without assertions); macOS tests and lint are green. Posted successor shepherd-endojs-endo-but-for-bots-pr1348-ubuntu26-ci-20261101 to own restoration of CI parity. Review was not re-requested while CI is red.

Self-improvement: nothing this time.
