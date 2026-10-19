---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
---
PR-open handoff for job `build-endo-gateway-mcp-termination` (endojs/endo-but-for-bots). The bot PAT on oros-studio-garden-ce242c49 gets a 403 on createPullRequest, so this job is pinned to an endolin host. The work is done and pushed. Head `build/endo-gateway-mcp-termination` is at `e7e63160d9eac20bec1cb68b0688c8400f478400`, and the frozen base `llm-ca5aaef` is at `ca5aaefb2`. Do NOT change any code.

Your only task: write the PR body between the BODY markers below to a file, check that `git ls-remote origin build/endo-gateway-mcp-termination` still shows e7e63160d, then run this from an `ensure-project-worktree.sh` checkout of the head (cwd = that project worktree, so the phase-evidence gate resolves the `designs/` paths):

    /Users/dom/garden/scripts/jobs/gardening/ensure-pr.sh build-endo-gateway-mcp-termination endojs/endo-but-for-bots build/endo-gateway-mcp-termination llm-ca5aaef --title "feat(agent-mcp-stdio): streamable-HTTP MCP termination (endo-mcp-http)" --body-file <file>

Keep the job base `build-endo-gateway-mcp-termination` (not this job's base) so the PR carries the original job marker. The PR must open as DRAFT. Name the PR number in your completion report so the gauntlet is staged.

-----BODY-----
Refs: `designs/endo-gateway-mcp.md` (milestone M6)

## Description

This adds the Model Context Protocol termination of `designs/endo-gateway-mcp.md` (Phase 3). External MCP clients such as Claude Desktop or Cursor can now drive an Endo guest over streamable HTTP.

`@endo/agent-tools` and `@endo/agent-mcp-stdio` already shipped the transport-free projection (catalog guard, dispatch check, error taxonomy) and the static guest-agent tool declarations. This PR adds only the HTTP transport on top of them.

- **`packages/agent-mcp-stdio/src/http.js`** (new) is the code to review most closely.
  - `makeMcpHttpHandler` is a mountable `POST /mcp` route.
  - `makeGuestServerResolver` binds each bearer to a guest-scoped MCP server, once per formula id. A failed resolution is not cached.
  - `startMcpHttpGateway` is the listener, and `mainHttp` is the process entry.
- **`bin/endo-mcp-http.js`** (new) is configured by `ENDO_MCP_HTTP_HOST` (default `127.0.0.1`), `ENDO_MCP_HTTP_PORT` (default `8921`) and `ENDO_MCP_HTTP_ALLOWED_ORIGINS`.
- **`packages/daemon/src/rate-limiter.js`** is the daemon gateway's per-address failed-auth limiter, moved verbatim out of `ws-gateway.js` and exported as `@endo/daemon/rate-limiter.js` so both surfaces share one implementation.
- `server.js` now exports `isFormulaIdentifier`, the existing validator, for bearer parsing.
- The design gains a `## Status` section, the index row is now In Progress, and the README has a new section.

Transport shape, stateless per the design's Decision 8:
- One JSON-RPC message per `POST`, answered with `application/json`.
- `202` for a notification.
- `400` for a parse error or a batch. 2025-06-18 dropped batching.
- `405` for `GET`, since no server-initiated SSE stream is offered.
- `415` for a non-JSON body, `413` for a body over 4 MiB, and `404` off-path.
- No `Mcp-Session-Id` is issued.

**Deviation from the design text: this runs on its own listener, not the daemon gateway's port.** The guest declarations live in `@endo/agent-mcp-stdio`, which depends on `@endo/daemon`. A `packages/daemon/src/gateway-mcp.js` that imported them would create a package cycle and break the composite `tsc` build. `endo-mcp-http` holds an ordinary daemon session and the reverse proxy routes `/mcp` to it. `makeMcpHttpHandler` is a `(req, res) => Promise<boolean>` route, so it can mount on the shared port once the declarations move below the daemon. Phase 2's `publishAgent` bearer table is not needed while the termination is per-user, because the daemon already resolves a formula id to its facet. The table belongs to the per-host Gateway of `gateway-package`, which is still Proposed.

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Design: `designs/endo-gateway-mcp.md`
Index: `designs/README.md` (status row only, no phases of its own)
Disposition: orchestrated-slice
Successor: build-endo-gateway-mcp-remaining-phases
Phase 1: superseded | `@endo/agent-tools` (`src/adapters/mcp.js`) plus the `@endo/agent-mcp-stdio` guest declarations, already on `llm`, are the extracted reusable tool surface
Phase 2: superseded | no bearer table is needed: the bearer resolves through `resolveGuest` (`lookupById` plus the guest-facet check) on the user daemon; the table moves to the per-host Gateway of `gateway-package` (Proposed)
Phase 3: partial | `POST /mcp` with bearer auth, the shared rate limiter, and initialize, tools/list and tools/call in this PR (`test/http.test.js`); SSE streaming, progress and cancellation are open in the successor
Phase 4: open | the Chat "+ Add agent" affordance and the "MCP" tab belong to the successor
Acceptance: open | the Playwright smoke test the design requires for the Chat UI belongs to the successor
<!-- /garden-phase-evidence-ledger -->

### Security Considerations

The bearer is the guest's formula id, so knowing it grants the guest's full authority. This is the same model as `gateway-bearer-token-auth`, and the README says to treat the bearer like an SSH key.

Every bearer resolves through `resolveGuest`. A formula that resolves to a **host** facet, or to anything carrying a host-only method, gets the same `401` as an unknown or malformed bearer. An MCP client can therefore never reach host authority, even with the host's own formula id. Each failure advances the per-address limiter (`429` with `Retry-After` while limited). The 401 body does not say whether a formula exists.

A request carrying an `Origin` header outside the allow-list is refused with `403`, which is the transport's DNS-rebinding guard. Non-browser MCP clients send no `Origin`.

The listener is plaintext. Startup prints a warning when it binds beyond loopback, because a TLS-terminating reverse proxy is required there, as the design assumes. Clients cannot choose the guest through tool arguments: the adapter's argument-scope check still applies.

### Scaling Considerations

One daemon session serves every guest. Each guest is resolved once (three eventual sends) and then cached for the life of the connection. Request bodies are capped at 4 MiB.

### Documentation Considerations

There is a new README section, "Streamable HTTP (`endo-mcp-http`)", with the client config block. Both packages are private, so there is no changeset.

### Testing Considerations

`packages/agent-mcp-stdio/test/http.test.js` runs a real HTTP listener against fake daemon facets. It covers:
- bearer parsing, and per-bearer guest selection with caching;
- unknown, malformed and host-facet bearers being indistinguishable, and rate limiting;
- the 202, 400, 403, 404, 405 and 415 shapes;
- `mainHttp`'s exit codes and its non-loopback warning.

The full package suite passes (60 tests), as do `tsc` and eslint. The broker tests need a TMPDIR whose filesystem allows `chmod` on a Unix socket, which is pre-existing and unrelated. The daemon's `http-content-plane` test still passes after the limiter move, and daemon `tsc` is clean.

### Compatibility Considerations

The change is additive. `ws-gateway.js` behavior is unchanged, since the limiter moved verbatim.

### Upgrade Considerations

None.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
-----END BODY-----
