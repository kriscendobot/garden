---
kind: result
role: fixer
host: endolinbot
short_id: f7d5dc
dispatch_root: dispatches/fixer--f7d5dc
repo: endojs/endo-but-for-bots
branch: feat/lal-pi-harness
pr_number: 290
model: sonnet
---

Addressed kriskowal's inline comment (id 3456812783, 2026-06-23T03:25:48Z)
on `packages/lal/agent.js:551`, which rejected the prior
JS-eval pivot proposal in favor of rigorous SmallCaps encode/decode.

## Commit landed

`370f246e6` — `refactor(lal): rigorous SmallCaps encode/decode for tool args`

Force-pushed to `feat/lal-pi-harness` (lease anchor `aa6b682cd`).

## What changed

Replaced the two-step `coerceBigintArgs` (regex heuristic) +
`validateAndFixupArgs` (post-validation fixup) with a single
`decodeToolArgs(name, rawArgs)` using `makeMarshal({ serializeBodyFormat:
'smallcaps' })` from `@endo/marshal`:

- Inbound: reconstructs SmallCaps body from Pi's JSON-parsed args
  (`body = '#' + JSON.stringify(rawArgs)`), calls `fromCapData`, then
  runs `mustMatch` against the per-tool `@endo/patterns` guard.
  Secondary fallback for JSON-string-encoded args (smaller-LLM habit)
  is preserved.
- Outbound (in `toAgentTool`): `toCapData(harden(result))`, strip `#`
  sentinel, send SmallCaps JSON as tool-result text.

System prompt updated with a SmallCaps encoding table and rules.
`test/smallcaps-footgun.test.js` rewritten against the new contract
(26 tests pass including `!`-escape paths, BigInt decode, and
`#undefined` workerName decode).

## RSVP posted

Inline reply on comment 3456812783:
https://github.com/endojs/endo-but-for-bots/pull/290#discussion_r3456865559

Top-level PR summary posted:
https://github.com/endojs/endo-but-for-bots/pull/290#issuecomment-4775412676

Review re-requested from kriskowal.
