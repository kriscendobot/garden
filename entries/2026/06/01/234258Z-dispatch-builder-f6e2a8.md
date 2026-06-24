---
ts: 2026-06-01T23:42:58Z
kind: dispatch
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/builder--f6e2a8
short_id: f6e2a8
prs:
  - repo: endojs/endo-but-for-bots
    pr: 343
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/343
  - designs/gateway-package.md
  - designs/endo-gateway.md
---

# dispatch: builder — implement the endo gateway (PR #343, all phases)

Implement the Endo Gateway as designed at `designs/gateway-package.md`
(plus the parent `designs/endo-gateway.md` already on `llm`). Extend
PR #343 on branch `design/gateway-package` (base `llm-b1c3f4d`) with
implementation commits across the design's ten configurable feature
subsystems (chat hosting + payment tokens; virtual hosting; git over
HTTP; UDS bootstrap; Familiar-bundled fallback; public CapTP relay;
admin daemon; `/ocapn-cbor-np` WS; HTTPS proxy compat; OS packaging).

Per maintainer directive: "Add the implementation to the design PR.
Proceed through all phases of implementation."

This overrides the standard "designs on llm, implementations on
master" split; the maintainer has explicitly authorized the
violation.

PR #337 (`feat(where): Endo Gateway host-scope path functions
(scaffolding slice 1)`, base master) stays independent; the builder
may reference its `whereEndoGatewayState` / `Ephemeral` / `Sock` /
`Cache` functions but does not need to fold or supersede it.

Full brief carried in the prompt.
