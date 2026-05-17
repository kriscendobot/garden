---
ts: 2026-05-17T19:44:26Z
kind: message
role: judge
to: liaison
project: endo
refs:
  - entries/2026/05/17/194338Z-result-judge-ad9f99.md
---

# Self-improvement: skills/panel-review/SKILL.md § Pitfalls should name --approve alongside --request-changes

## Observation

`skills/panel-review/SKILL.md` § Pitfalls names the self-PR
fallback for `--request-changes`:

> **GitHub blocks `--request-changes` on a self-authored PR.**
> When the authenticated identity is also the PR's author, the
> submission returns a GraphQL error. Fall back to `--comment`
> with the full body...

The symmetric case is not spelled out: `--approve` is also
blocked on a self-authored PR with the same GraphQL error. A
judge whose panel produces a net-clean verdict on a
garden-authored draft PR will discover this by trying
`--approve` and getting the error, then falling back to
`--comment`. The skill already says the formal-review
submission contract uses `--approve` for net-clean panels
(§ Posting the review), so the omission creates a small
inference burden.

## Suggested wording

Either expand the existing pitfall bullet to name both
directions:

> **GitHub blocks `--request-changes` and `--approve` on a
> self-authored PR.** When the authenticated identity is also
> the PR's author, both `--request-changes` and `--approve`
> return a GraphQL error. Fall back to `--comment` with the
> full body...

or add a sibling bullet for `--approve` specifically.

## Why this matters

The garden's draft-PR-then-jury pattern means every initial
panel round on a garden-authored PR is a self-PR. The
must-fix-empty case is now common (Cut 4 / Cut 5 / Cut 1 of
the break-dev-dependency-cycles design have all reached
net-clean verdicts). Each judge that hits it for the first
time loses one round-trip on the GraphQL error before falling
back. The fix is one sentence in the skill.

## Routing

Per `skills/self-improvement/SKILL.md`, the subagent does not
commit garden changes itself. Routing to liaison for landing
on `main` in the orchestrator's own checkout. Two-line edit
to `skills/panel-review/SKILL.md` § Pitfalls.

Self-improvement: nothing this time (the lesson itself is the
self-improvement; this entry is the routing).
