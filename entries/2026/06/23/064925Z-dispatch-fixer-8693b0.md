---
kind: dispatch
role: fixer
host: endolinbot
posture: liaison
short_id: 8693b0
dispatch_root: dispatches/fixer--8693b0
repo: endojs/endo-but-for-bots
branch: chore/retire-function-keyword
pr_number: 474
model: sonnet
---

RSVP kriskowal's comment on PR #474 (id 4776353908,
2026-06-23T06:25:14Z):

> Please shepherd and run the gauntlet. Please also move the
> design into a more permanent location for future reference and
> frame as documentation of house style. Ensure that it can be
> found from CLAUDE.md. Dispatch a gardener to reinforce this
> house style going forward.

PR #474 (`chore/retire-function-keyword`) is a refactor on master
retiring the `function` keyword in favor of arrow / method syntax
per an erights review.

Compound:
1. Shepherd CI to green.
2. Run the gauntlet (cleaner → judge → fixer-loop → un-draft when
   judge approves).
3. Move the design (likely at `designs/retire-function-keyword.md`
   or similar) to a more permanent location for house-style docs.
4. Frame it as documentation of house style.
5. Ensure it's findable from CLAUDE.md.

Gardener follow-up (separate dispatch) reinforces the rule going
forward in role / juror files.
