---
ts: 2026-05-19T20:22:52Z
kind: dispatch
role: steward
to: "*"
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 290
    role: target
---

# Dispatch: fixer on #290 per 0xpatrickdev @-mention

0xpatrickdev on #290 at `20:21:53Z` ([#290 issuecomment-4491716618](https://github.com/endojs/endo-but-for-bots/pull/290#issuecomment-4491716618)):
*"@kriscendobot please take another pass at this. If recently merged
tests are for things that are now handled by pi, please remove them"*

Context: 0xpatrickdev's stacked PR series #291 (`pc-split-tmp-cleanup`)
and #292 (`pc-split-lal-provider-fixes`) merged to `llm` (and #293
`pc-split-lal-replay-support` just merged at `20:20:37Z`). Tests in
#290 (`feat/lal-pi-harness`) for things now handled by pi (deterministic
provider replay, etc.) should be removed.

Dispatch root: `/home/kris/dispatches/fixer--4ee2d8` on `feat/lal-pi-harness`.

The fixer:
1. Rebases onto current `origin/llm` (which now carries patrick's
   merged PRs).
2. Identifies which tests in lal duplicate functionality now provided
   by patrick's merged pi-related infrastructure.
3. Removes those tests.
4. Push, reply, re-request review (kriskowal,jcorbin,0xpatrickdev).

Per-action authorizations: reply on the directive thread, push,
`gh pr edit --add-reviewer`, local prettier check. Standing broad
authorization covers comment ops.
