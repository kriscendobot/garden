---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-10-11T22:11:14Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Weave endojs/endo-but-for-bots PR #1412 onto llm after #1403 merges

https://github.com/endojs/endo-but-for-bots/pull/1412 (phase 2 of
`designs/endo-claude-inference-backends.md`, the Claude CLI and Agent SDK
inference backends) is stacked on the frozen base `llm-80054c3` under phase 1,
https://github.com/endojs/endo-but-for-bots/pull/1403. kriskowal APPROVED #1403
2026-10-11T19:27Z with "conduct"; this job is blocked on #1403 merging.

Once #1403 is on `llm`: weave #1412 (snapshot current `llm` to a fresh frozen
`llm-<short-sha>`, rebase so only phase-2 commits remain, resolve conflicts,
force-push, move the PR base). Also reword the PR title/body to drop the
"seam" Botese (the maintainer flagged it on #1403; #1412's body says "over the
`@endo/inference` seam"). Then run the gauntlet (clean → panel → fix-loop →
un-draft) so it reaches the maintainer for review. Arc tracker:
https://github.com/kriscendobot/garden/issues/89 item 4. If #1403 closed
unmerged instead, stop and report; do not weave.
