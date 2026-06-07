---
ts: 2026-06-07T03:50:00Z
kind: result
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 426
    role: target
refs:
  - entries/2026/06/07/034000Z-dispatch-fixer-c71c70.md
  - entries/2026/06/07/034500Z-result-fixer-c71c70.md
  - entries/2026/06/07/034700Z-dispatch-fixer-f1fc5f.md
  - entries/2026/06/07/034908Z-result-fixer-f1fc5f.md
  - https://github.com/endojs/endo-but-for-bots/pull/426
  - https://github.com/endojs/endo-but-for-bots/pull/426#issuecomment-4641290562
  - https://github.com/endojs/endo-but-for-bots/pull/426#issuecomment-4641292826
  - https://github.com/endojs/endo-but-for-bots/pull/426#issuecomment-4641329669
  - https://github.com/endojs/endo-but-for-bots/pull/426#issuecomment-4641339930
---

# result: steward — PR #426 eslint-plugin-unicorn directives addressed via two-dispatch chain

Maintainer issued two directives on PR #426 in quick succession at
2026-06-07 03:38–03:40Z; the steward dispatched two fixers and the
gap is now closed at PR #426's tip.

## Directive 1 (03:38:27Z, kriskowal): fresh PR based on master

Fixer `c71c70` verdict: master already provides
`eslint-plugin-unicorn ^56.0.1` in root `package.json` devDeps (line
32). Opening a fresh PR against master would produce an empty diff.
The fixer correctly declined to open the PR and posted a verification
comment explaining the state plus answering the maintainer's second
question ("why didn't the failure manifest upstream"): upstream's
atomic commit `c423ed37b chore(eslint-plugin): require
underscore-delimited groups in numeric literals` added all four pieces
(root devDep + peerDep + rule + test) in lockstep, so upstream's CI
never hit the asymmetry. The asymmetry only appeared on the bot fork
because the master-into-llm merge dropped the root devDep per the
prior sync's curated-devDep precedent while still adopting the peerDep
and rule.

Verification reply on PR #426:
<https://github.com/endojs/endo-but-for-bots/pull/426#issuecomment-4641329669>.

## Directive 2 (03:40:04Z, kriskowal): address directly on PR #426

Fixer `f1fc5f` outcome: two commits appended to PR #426's branch
`merge/actual-master-into-llm-20260606`:

- `5abcb01b7` `chore: add eslint-plugin-unicorn to root devDeps`.
- `1d0f019a6` `chore: Update yarn.lock` (regenerated; +114/-3).

Branch tip: `61804678` → `1d0f019a6` (regular append push, no
force).

Reply on PR #426 citing both SHAs:
<https://github.com/endojs/endo-but-for-bots/pull/426#issuecomment-4641339930>.

## Current CI state

PR #426 head `1d0f019` at this entry's time: 5 SUCCESS, 20
IN_PROGRESS, 0 FAILURE. Fresh CI propagating; the prior 5-FAILURE
set (lint + 4 test-matrix) should resolve once the eslint chain
reads clean.

## Adjacent observation (not actioned this entry)

The asymmetric-merge pattern that caused this gap deserves a
forward-looking note: when a future master-into-llm sync merge
involves an atomic four-piece (devDep + peerDep + rule + test)
upstream commit, all four pieces must travel together OR be
explicitly partitioned with rationale. The 2026-06-06 builder's
"matching the prior sync's precedent" decision dropped the root
devDep without surfacing that the peerDep would then dangle. A note
to that effect on the builder/weaver role file or
`skills/conflict-resolution/SKILL.md` might prevent this class of
recurrence.

## Recovery note

This `result` entry was rewritten on the second attempt after the
job-board-poll daemon's 30s journal-reset wiped the first commit
between `git commit` and `git push` (the file landed on disk briefly
and was committed, but the daemon's `fetch+reset --hard
origin/journal` discarded the commit before my push could land).
This bash command does the Write+add+commit+push in a single
invocation to beat the reset window, per the memory rule on the
daemon's behavior.

Self-improvement: the daemon-reset memory rule is load-bearing here.
Tight-chain bash, or `kill -STOP` the daemon, or do the substantive
work under a `dispatches/*/journal/` sub-worktree where the daemon
does not reach. The steward's parent-context journal at
`/home/kris/journal/` is the daemon's reset target; any future
multi-step write should treat that constraint as routine.
