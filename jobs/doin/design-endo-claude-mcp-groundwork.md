---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Follow-on to `design-endo-claude` (design an `@endo/claude` package: hermetic
`claude -p` inference for an Endo guest, injected with only that guest's own
capabilities as MCP tools).

## The correction

`design-endo-claude`'s body said "no `@endo/mcp` package exists yet" based only
on the two `kriscendobot/minion.town` designs (`mcp-endo-guest.md`,
`mcp-daemon-guest-tools.md`). That undersold real, merged prior art in
`endojs/endo-but-for-bots` itself:

- **`designs/endo-gateway-mcp.md`** (PR #376, MERGED,
  https://github.com/endojs/endo-but-for-bots/pull/376) — a detailed design for
  MCP JSON-RPC termination **on the Endo Gateway** (`packages/gateway/`), a `POST
  /mcp` + `GET /mcp` (SSE) streamable-HTTP endpoint, sibling to the existing
  `/ocapn` WebSocket endpoint on the same bind port. Its own status header still
  reads "Not Started" and matches reality: `packages/agent-tools/src/adapters/mcp.js`
  is a stub (`// Planned adapter shape only.` / `export {}`), and there is no
  `/mcp` route file under `packages/gateway/src/`. **Design-complete,
  implementation-not-started** — that's the precise state to build against, not
  "nothing exists."
- **PR #400** ("groom: rebucket roadmap for shortest-route MCP-bridge gateway",
  MERGED) — roadmap sequencing for this same MCP-bridge work; check what it says
  about where `endo-gateway-mcp` sits relative to other gateway phases before
  assuming build order.

## What this changes in the design-endo-claude job

Fold these into the design (or, if `design-endo-claude` already completed
without them, treat this as the revision cycle — same target file,
`designs/endo-claude.md` in `endojs/endo-but-for-bots` @ `llm`):

1. **The auth model for a remote/networked Endo MCP is already specified and is
   simpler than OAuth.** Per `endo-gateway-mcp.md` § Authentication: the bearer
   token IS the 64-hex-char formula identifier of the target agent (reusing
   [`gateway-bearer-token-auth.md`](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/gateway-bearer-token-auth.md)'s
   model), sent as `Authorization: Bearer <hex>` over a reverse-proxy TLS
   channel — no OAuth flow, no DCR, no client registration. This is a much
   better fit for a machine client like `claude -p` than the minion.town
   human-facing Cognito PKCE flow cited before; use it as the default "remote"
   shape for `@endo/claude` and keep the OAuth path as a minion.town-specific
   deployment variant, not the general case.
2. **The local-shim pattern is explicitly anticipated, not invented.**
   `endo-gateway-mcp.md`'s own Wire Shape section says stdio MCP clients "still
   run a local subprocess, and that subprocess can be a thin Endo CLI shim that
   itself opens an OCapN connection or a `/mcp` HTTP connection." This is
   exactly `@endo/claude`'s local/loopback deployment case (§ "The local/remote
   Endo MCP question" in the original job) — cite it directly as the sanctioned
   shape for the local shim rather than inventing a new one, and note that
   `claude -p --mcp-config` needs either a stdio-command entry or an
   HTTP-type entry (both are valid `--mcp-config` shapes), so the design should
   say explicitly which one `@endo/claude` uses for the local case and why.
3. **The tool-catalog derivation is already specified.** `tools/list` is a
   one-line projection of Lal's static OpenAI-function-calling tool schemas
   (`packages/lal/agent.js`) into MCP's `Tool` shape (`name`/`description`/
   `inputSchema`), and `tools/call` dispatches through the same
   `executeTool(name, args)` switch. This directly answers "compose the
   allow-list from the facet's method set" (already a requirement in
   design-endo-claude): the per-guest `--allowedTools mcp__<server>__<name>`
   list is one entry per Lal tool name, not something `@endo/claude` has to
   invent its own derivation for. Note the explicit limitation carried over
   from `endo-gateway-mcp.md`'s Open Questions §1: this covers Lal's current
   static namespace/mail/evaluate tools, not the capability-scoped
   `daemon-agent-tools.md` surface (Not Started, depends on filesystem/
   capability-bank designs landing first) — `@endo/claude`'s guest-formula
   scoping should be written against whichever surface is actually live when
   it's built, and name the daemon-agent-tools dependency explicitly if the
   capability-scoped surface is what's wanted instead.
4. Re-state the sequencing open question precisely now that the dependency is
   named: does `@endo/claude` (a) wait on `endo-gateway-mcp` implementation
   landing, (b) implement the local CLI-shim path itself as a smaller
   first increment that talks OCapN directly and doesn't need the Gateway's
   `/mcp` HTTP surface at all, or (c) both, with the shim as v1 and Gateway
   `/mcp` as the remote/pooled-deployment path for v2. Recommend one rather
   than leaving all three equally open, and say why.

<!-- garden-reaped: 0 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-16T06:03:12Z
