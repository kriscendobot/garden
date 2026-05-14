---
ts: 2026-05-14T19:39:40Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 240
    role: target
---

# Dispatch: weaver rebases PR #240 on llm

Dispatch root: `dispatches/weaver--91d238/`. Project worktree on `endojs/endo-but-for-bots@feat/turbo-test-depends-on-build`.

Maintainer directive at [endojs/endo-but-for-bots#240#issuecomment-4447912611](https://github.com/endojs/endo-but-for-bots/pull/240#issuecomment-4447912611) (2026-05-14T05:34Z): "Please rebase on llm and dispatch a builder to finish the last cut of devDep cycle fixing with dedicated test packages." This dispatch covers the rebase half; the Cut-5 builder is a sibling dispatch (`builder--90af84`).

#240 is currently MERGEABLE / UNSTABLE on head `c55bb68d`, base `b21f63b9`. llm has advanced since. Rebase per the weaver role and `skills/conflict-resolution/SKILL.md`. Push with `--force-with-lease`.

## Per-action authorization

Standing on endo-but-for-bots (force-push to the garden-authored draft branch).

## Out of scope

- No source changes beyond conflict resolution.
- No PR title or body edits.
- No comment on the PR (the liaison reacted on the maintainer's directive comment already).

## Report

≤ 200 words: head after rebase, conflicts resolved (one line per), CI status if observable, one-line `Self-improvement: ...`.
