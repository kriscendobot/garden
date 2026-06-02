---
ts: 2026-06-02T18:44:00Z
kind: message
role: groom
project: endo
to: liaison
---

# GROOM-OPEN-QUESTIONS: MCP-bridge rebucket pass

Latest grooming pass: 2026-06-02T18:44:00Z.

## 2026-06-02 grooming pass

The maintainer asked for a rebucket and reprioritize pass emphasizing
the shortest route to a gateway-as-MCP-bridge for Endo agents, with
AWS hosting, Stripe-token purchase (computrons / cogitrons / storage /
network), and user identity by public key with OAuth bonding plus key
recovery / rotation. The substantive `designs/README.md` diff adds
Milestone B (MCP Bridge Hosting, cross-cutting cut), introduces
Milestone 7 (Public Hosting and Billing) as the home for the AWS
stack (PR #356) and three named design gaps, raises `endo-gateway-mcp`
to Strategic Early Items in M1, and names the gateway-package
implementation stack PRs #343 / #388-#397 in the M1 row.

The questions below need maintainer adjudication before the next
grooming pass can act on them.

### Design-gap M-bin assignments

- **gateway-oauth-bonding.md** (new, gap): proposed M-bin is **M7**
  (Public Hosting and Billing). The design is hosting-specific (the
  hosted gateway is the OAuth relying party, not the per-user
  daemon) and is the slice most likely to spawn churn. Recommended
  action: confirm M7 placement, or move to M1 if the maintainer
  wants the bonding shape pinned alongside `endo-gateway-mcp` rather
  than waiting for the hosting story.

- **gateway-key-recovery.md** (new, gap): proposed M-bin is **M7**,
  same rationale as bonding (hosted-service operator concern).
  Distinct from the broader Pass-Invariant-Eq follow-up in
  [endo-gateway.md](endo-gateway.md) Open Question 1, which stays
  open as a deferred item against `daemon-agent-network-identity`.
  Recommended action: confirm M7 placement and confirm that the
  narrower operator-side re-issue scope is the right MVP shape (vs.
  scoping to full Eq-preservation, which is materially harder).

- **gateway-stripe-adapter.md** (new, gap): proposed M-bin is **M7**.
  The maintainer's directive named Stripe explicitly; the
  `verifyPaymentProof` contract is already in flight as Phase 8 PR
  #396. Recommended action: confirm M7 placement; confirm that a
  thin design note (wire shape + failure modes) is the right
  artifact rather than skipping straight to implementation.

- **gateway-resource-classes** (likely fold into stripe-adapter):
  Phase 8 PR #396 names compute / storage / network / inference as
  the four resource classes, but the per-class measurement surfaces
  (what counts as a computron, how cogitrons map to upstream
  provider tokens, how network bytes are counted across HTTP / WS /
  OCapN) need spec text. Recommended action: fold into
  `gateway-stripe-adapter.md` as a "Resource classes" section
  unless the metering complexity demands its own design.

### Should Milestone B reshape Milestone 1's priority order?

Today the M1 table lists 10 active backlog rows (Cancel-now-shipped
not counted), of which `endo-gateway` and `endo-gateway-mcp` are
both Strategic Early Items after this pass. The other eight M1 rows
(`daemon-docker-selfhost`, `daemon-agent-tools`, `daemon-mount`,
`filesystem-watchers`, `daemon-locator-terminology`,
`daemon-rename-to-manager`, `daemon-xs-worker-snapshot`,
`endoclaw-timer`, `endoclaw-network-fetch`) compete for the same
developer attention but only `endoclaw-network-fetch` is on the
critical path of the MCP-bridge cut (OAuth bonding will need
outbound HTTP). Recommended action: confirm that the MCP-bridge
cut's P0-P4 sequence is the priority within M1 for the foreseeable
future, with the other eight rows running in parallel where they
do not contend, or pick an alternate sequencing if the AWS hosting
or the Stripe billing should land earlier than P2 / P3 imply.

### Should `endopi-provider-registry-and-oauth` be raised?

The MCP-bridge cut focuses on **external clients driving Endo
agents** (Claude Desktop sends MCP RPCs to the gateway, which
drives `packages/lal/agent.js`'s tools). The reverse direction
(Endo agents calling out to upstream LLM providers like Claude Pro
or ChatGPT Plus via OAuth) is the
[endopi-provider-registry-and-oauth](../packages/lal/CLAUDE.md)
design, currently parked at M1 with "Partially satisfied by
`packages/genie`" annotation. Recommended action: leave at M1; the
MCP-bridge cut does not depend on it (the gateway routes MCP
requests to agents using their own existing provider plumbing).

### Should the gateway-package design be promoted from PR #343 to
"the home M1 design", retiring `endo-gateway`?

PR #343 explicitly "supersedes" `endo-gateway.md`, but the README
still has separate rows for `endo-gateway` (M1) and would have a
new `gateway-package` row at M7 if I had added one. The merge of
PR #343 will replace `endo-gateway.md` with `gateway-package.md`.
Recommended action: defer the README row consolidation to the
groomer's next pass after PR #343 merges; the substitution is
mechanical at that point. (The current rebucket pass leaves the
`endo-gateway` row in M1 because that is what `llm` carries
today.)

### Does Milestone B's exit criterion match the maintainer's
intent?

The exit criterion is "A user signs into a hosted Endo Gateway via
OAuth, the gateway provisions an Endo agent for them (or bonds to
their existing key via key recovery), the user purchases compute /
storage / network / inference tokens via Stripe, configures their
MCP client (Claude Desktop, etc.) with the agent's bearer token +
the gateway's `/mcp` URL, and the MCP client successfully calls the
agent's tools." Recommended action: confirm or revise. The MCP
adapter currently exposes the **static Lal tool set** (namespace
/ mail / evaluate), not the capability-scoped Dir / Shell / Git
tools from `daemon-agent-tools` (which is Not Started); the exit
criterion does not pin which tool surface counts as "successful".
