---
ts: 2026-05-29T05:47:27Z
kind: result
role: gardener
host: endolinbot
project: endo-but-for-bots
to: liaison
short_id: 7406cd
refs:
  - entries/2026/05/29/053130Z-dispatch-steward-f9a0b1.md
  - entries/2026/05/29/053831Z-result-gardener-095818.md
---

# Result: fixer `requested_reviewers` 422 fix (follow-on to the d94d11 dispatch)

## Context

This is the second pass under dispatch root `dispatches/gardener--d94d11/`.
The first gardener engagement under the same root (`095818` at
`053831Z-result-gardener-095818.md`) already investigated the missed
maintainer review on PR #376 and landed the structural fix as commit
`ccb4599b` on `origin/main` (steward AGENT.md *Maintainer-feedback
response* section + monitor-endo-but-for-bots PullRequestReviewEvent
row split by PR shape).

This pass picks up the one remaining item in the dispatch brief: the
one-occurrence pitfall the designer flagged about
`gh api repos/.../requested_reviewers -f reviewers='["X"]'` returning
HTTP 422.

## Finding

The buggy command shape was *literally encoded* in the fixer role file
at line 54: `gh api repos/<o>/<r>/pulls/<N>/requested_reviewers -f
reviewers[]=<login>`. Both `-f reviewers[]=<login>` and `-f
reviewers='["<login>"]'` return HTTP 422: `gh api` does not coerce
repeated `-f` keys into a JSON array, and the `-f` value side is parsed
as a plain string rather than JSON.

The working shape is to assemble the JSON body explicitly and pipe via
`--input -`:

```sh
echo '{"reviewers":["<login>"]}' | \
  gh api repos/<o>/<r>/pulls/<N>/requested_reviewers --input -
```

The brief suggested `skills/pr-review-thread-replies/SKILL.md` as a
possible host *if already being edited for related cleanup*, but that
skill covers thread replies (the `/pulls/<N>/comments/<id>/replies`
endpoint), not the `/requested_reviewers` endpoint. The wrong example
literally lives in `roles/fixer/AGENT.md`; correcting it in place is
the surgical fix.

## File edited and commit

Commit `7406cd35` on `origin/main`:

- `roles/fixer/AGENT.md` — replaced the broken
  `-f reviewers[]=<login>` example on line 54 with the working
  `echo '{"reviewers":["<login>"]}' | gh api ... --input -` shape, and
  named both failing shapes (`-f reviewers[]=<login>` and
  `-f reviewers='["<login>"]'`) so future readers recognize the trap.
- `updated:` bumped to 2026-05-29; `author:` unchanged (the fix is a
  one-line example correction, not a center-of-gravity shift).

## Threshold rationale

Per `skills/self-improvement/SKILL.md` § Threshold for landing a change:
"One vivid observation is enough to add a pitfall, a 'Note from the
field,' or an example to an existing skill or role." This is rule 4
specifically ("An outdated or wrong example"). The example was actively
misleading (it would have produced a 422 on every fixer dispatch that
followed it), so correcting in place rather than adding a separate
pitfall row is the right shape.

## Out of scope (not edited)

- `roles/COMMON.md` line 82 — references `gh api .../requested_reviewers`
  in narrative form without spelling out the option shape, so the
  narrative is still correct. Leaving as-is rather than over-specifying.
- `skills/pr-review-thread-replies/SKILL.md` — covers the `/replies`
  endpoint, not `/requested_reviewers`. No edit needed.

## Cumulative deliverables for the d94d11 dispatch root

Two commits on `origin/main`:

1. `ccb4599b` — steward: own maintainer-feedback response on draft PRs;
   dispatch by PR shape. (Landed by the `095818` pass.)
2. `7406cd35` — fixer: correct requested_reviewers gh api invocation
   (422 fix). (Landed by this pass.)

Both files (`roles/steward/AGENT.md`, `skills/monitor-endo-but-for-bots/SKILL.md`,
`roles/fixer/AGENT.md`) have their `updated:` frontmatter bumped to
2026-05-29.

## Self-improvement

Self-improvement: `roles/fixer/AGENT.md`; corrected a literally-wrong
`gh api ... requested_reviewers` invocation (both `-f reviewers[]=...`
and `-f reviewers='["..."]'` return 422) to the working
`echo '{"reviewers":["..."]}' | gh api ... --input -` shape.
