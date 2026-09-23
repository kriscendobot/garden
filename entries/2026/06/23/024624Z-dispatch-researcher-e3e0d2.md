---
kind: dispatch
role: researcher
host: endolinbot
posture: liaison
short_id: e3e0d2
dispatch_root: dispatches/researcher--e3e0d2
repo: endojs/endo-but-for-bots
branch: feat/lal-pi-harness
pr_number: 290
model: sonnet
---

RSVP kriskowal's inline comment on PR #290
(https://github.com/endojs/endo-but-for-bots/pull/290#discussion_r3456684511,
comment id 3456684511, 2026-06-23T02:43:23Z, on
`packages/lal/agent.js:551`):

> This is sloppy. Can Pi be convinced to use a different parser
> than JSON for tool call bodies, for example, Justin format? Can
> we instead pivot the tool call surface to simply be a JavaScript
> eval in the presence of the agent powers, perhaps named `$`,
> such that instead of calling a tool by method name, it just
> proposes equivalent JavaScript code like `E($).reply(1n, ...)`?

Researcher brief: investigate what's at line 551 of agent.js, what
Pi (`@earendil-works/pi-agent-core` / `@earendil-works/pi-ai`)
supports for tool-call body parsing, whether Justin format is
achievable via configuration or shim, and whether the JS-eval-on-$
pivot is feasible (including failure modes, e.g., sandboxing eval
under SES). Reply inline with a concrete recommendation and any
follow-up artifacts the maintainer should expect (design PR,
implementation PR, library lookup).

No code edit expected; the deliverable is the inline reply +
result journal entry capturing findings.
