---
kind: dispatch
role: fixer
host: endolinbot
posture: liaison
short_id: f7d5dc
dispatch_root: dispatches/fixer--f7d5dc
repo: endojs/endo-but-for-bots
branch: feat/lal-pi-harness
pr_number: 290
model: sonnet
---

RSVP kriskowal's inline comment on PR #290
(https://github.com/endojs/endo-but-for-bots/pull/290#discussion_r3456812783,
comment id 3456812783, 2026-06-23T03:25:48Z, on
`packages/lal/agent.js:551`):

> Strike the idea. If we are stuck with JSON, it is better to lean
> in encode and decode smallcaps, not just guess that any string
> with a plus prefix is a bigint. SmallCaps is much more rigorous
> and touches all strings, including some that need to be escaped.
> The bigint coercer is still sloppy and should be replaced.
>
> We are using patterns and interface guards for tool calls in this
> setup, which is a good reason to not try to force eval through
> JSON. We would lose the harness's retry loop around invalid input
> and output, since all code is valid and does not provide the
> same degree of validation of arguments and return values. If Pi
> is not configurable, we would need to investigate forking Pi.
> So, dealing with SmallCaps rigorously is our best option today.

Decision: the JS-eval pivot is rejected. The path forward:
- Keep JSON as Pi's transport.
- Replace the sloppy `coerceBigintArgs` (and the
  `validateAndFixupArgs` re-parse layer) with a rigorous SmallCaps
  encode/decode round-trip via `@endo/marshal`.
- Keep patterns / interface guards for validation (they remain
  load-bearing for Pi's retry loop).
- Tool-call args are encoded as SmallCaps strings in the
  parameters and decoded at the agent boundary; results are
  encoded as SmallCaps before returning to Pi.

Fixer brief: rewrite the coercion pipeline in `lal/agent.js`
around line 551 to use `@endo/marshal`'s SmallCaps codec
(`makeMarshal({serializeBodyFormat: 'smallcaps'})` or equivalent).
Drop the prefix-based BigInt heuristic. Update the system prompt
so the model knows tool-call args are SmallCaps strings.
