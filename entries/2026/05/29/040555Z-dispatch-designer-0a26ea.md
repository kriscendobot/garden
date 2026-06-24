---
ts: 2026-05-29T04:05:55Z
kind: dispatch
role: designer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/designer--0a26ea
short_id: 0a26ea
refs:
  - designs/endo-gateway.md
  - designs/gateway-bearer-token-auth.md
  - designs/daemon-agent-tools.md
  - designs/lal-fae-form-provisioning.md
---

# dispatch: designer — endo-gateway-mcp (extend Gateway for MCP, expose Lal tools)

## Task

Draft `designs/endo-gateway-mcp.md` against `endojs/endo-but-for-bots:llm`,
proposing an extension of the Endo Gateway that terminates Model
Context Protocol JSON-RPC connections, authenticates them via a bearer
token / API key mapping to an Endo agent's formula identifier, and
exposes the tools currently provided by the Lal agent harness as MCP
tools.

## Maintainer-supplied prompt

> Please dispatch a designer to propose an extension of the Endo
> Gateway for Model Context Protocol. The gateway should terminate
> MCP JSON RPC connections and use a bearer token or API key to
> designate the formula identifier of an Endo agent and expose the
> tools provided currently by the Lal agent harness. This may
> involve refactoring Lal to provide a reusable package for exposing
> tool calls, or just an exported API from the Lal package proper
> (please assess the better design direction). The gateway can
> assume that there is a TLS proxy for the host. Auxiliary to this
> is the need for the Gateway's web interface (based on Chat) to
> enable the user to create agents and get the MCP configuration
> for them.

## Acceptance

- Single design file at `designs/endo-gateway-mcp.md` on a
  `design/endo-gateway-mcp` branch off `llm`.
- Draft PR open against `llm` per the designer's *Operating norms*
  (the standing relaxation in
  `journal/projects/endo-but-for-bots/README.md` § Standing
  authorizations covers the PR open).
- Metadata table follows `designs/CLAUDE.md`: title, Created/Author/
  Status (Not Started or Proposed), absolute ISO dates.
- The designer **assesses and recommends** one of: (a) refactor Lal
  to extract a reusable tool-exposure package, or (b) keep tools in
  Lal proper and export an API the Gateway calls. The recommendation
  is named in a Design Decisions section with the trade-off; the
  rejected alternative gets a one-line "Considered and rejected"
  steer.
- The TLS-proxy assumption is recorded (the Gateway itself does not
  terminate TLS; an external proxy does).
- The auxiliary Chat-UI surface for agent-create + MCP-config-export
  is sketched, even if it cross-links to a sibling design rather
  than fully specifying it.
- Open questions are explicit; cross-link existing related designs
  (`endo-gateway`, `gateway-bearer-token-auth`, `daemon-agent-tools`,
  `lal-fae-form-provisioning`, the Lal architecture doc at
  `packages/lal/LAL-ARCHITECTURE.md`) rather than restating them.

## Notes for the designer

- The base for the design PR is `llm` (HEAD 68246ad on this dispatch's
  `project/`).
- Pre-existing designs to cross-link, not duplicate:
  - `designs/endo-gateway.md` (Proposed) — the per-host system-service
    Gateway that virtual-hosts OCapN. It explicitly states the
    Gateway does *not* terminate TLS (Noise provides confidentiality).
    The MCP termination this design proposes is a *second*
    termination point on the Gateway, alongside OCapN.
  - `designs/gateway-bearer-token-auth.md` (Implemented) —
    bearer-token model where the token *is* the formula identifier
    (256-bit hex). The MCP extension should reuse or analog this
    model; declare whether the MCP bearer is the same shape (the
    raw formula id) or a derived token, with rationale.
  - `designs/daemon-agent-tools.md` (Not Started) — the
    capability-confined Endo tool surface (Dir / Shell / Git). The
    MCP-exposed tools likely overlap with this set; the designer
    decides whether the MCP-tool catalog is "everything Lal sees" or
    a subset bounded by the agent's capabilities.
  - `designs/lal-fae-form-provisioning.md` (Complete) — how Lal
    agents get provisioned today. Relevant to the auxiliary Chat-UI
    flow ("create an agent"); the new design may reuse the form
    surface or sketch a new flow.
- The Lal source lives at `packages/lal/` (`agent.js`, `LAL-ARCHITECTURE.md`,
  the harness types). The designer reads these to assess
  refactor-vs-export.
- Convert relative dates in the prompt to absolute. Today is
  2026-05-29.
- The standing relaxation on this repo lets the designer post the
  PR and cross-link from any related design PR without per-action
  authorization.

## Report

Return:
- The PR number and URL.
- The branch name (`design/endo-gateway-mcp`).
- The refactor-vs-export recommendation in one sentence, with the
  Design Decisions section heading where the trade-off is laid out.
- Any open questions that block a builder dispatch.
- Final `Self-improvement: ...`.

The liaison writes the matching `result` entry on return and tears
down this dispatch root.
