---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# shepherd directive on endojs/endo-but-for-bots PR #987

Map: **shepherd** → drive CI to green.

PR: https://github.com/endojs/endo-but-for-bots/pull/987
Title: design(endor): bind libgit2 with Zig cross-builds
Head: design/endor-git-bindings-zig  Base: llm

## Context

PR #987 was weaved (rebased onto llm; the designs/README.md index conflict was
resolved) by endojs-endo-but-for-bots-pr987-weave-20260819. As of the weave the PR
is `mergeable: MERGEABLE`, `mergeStateStatus: UNSTABLE`, head SHA
43dc5bae349c18b4d396554f1df066e2503cf469, and CI has dispatched (6 checks). Verify
the runs finish green; the PR is APPROVED (review #4968601303) so green CI clears it
for merge.

## Done when

CI is green on head 43dc5bae3 (or whatever the current head is), or any failure is
diagnosed and handed off.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-19T05:19:38Z
