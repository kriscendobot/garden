---
role: shepherd
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-16T18:01:16Z -->

# shepherd endojs/endo-but-for-bots PR #714

Drive CI to green on PR #714 (feat(platform): add listTree, rangeRead,
rangeReadText — consolidate genie/lal/fae fs reads).

- PR: https://github.com/endojs/endo-but-for-bots/pull/714
- Head: feat/platform-range-and-tree-reads  →  base: llm
- At claim time: OPEN, MERGEABLE, mergeStateStatus UNSTABLE (checks pending/failing).

Task: use the shepherd skill (skills/pr-ci-watch, ci-failure-classification-loop)
to watch the checks, classify any red, and push PR-attributable fixes to the head
branch until CI is green. Report non-PR-attributable/infra flakes rather than
chasing them (see the Endo guile-interop Codeberg flake and composite-tsconfig
gotcha in prior memory). Do NOT merge — merge is the conduct child that runs next.

Routed from the "shepherd and conduct" attention directive by kriskowal:
https://github.com/endojs/endo-but-for-bots/pull/714#issuecomment-4995011322
