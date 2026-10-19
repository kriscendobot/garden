---
handed-off: build-endo-gateway-mcp-termination-open-pr
deliverable-complete: false
---
I built the HTTP `/mcp` termination (Phase 3 of `designs/endo-gateway-mcp.md`) and pushed it, but there is no draft PR yet. This host's bot token gets a 403 on PR creation, so a pinned job will open it.

## Already on `llm` before this job
- Phase 1, in a different shape. `@endo/agent-tools` has a transport-free MCP adapter (`src/adapters/mcp.js`) that answers JSON-RPC for one bound guest. `@endo/agent-mcp-stdio` has the guest tool declarations, `resolveGuest`, and stdio/broker transports.
- Missing: the HTTP endpoint, the Chat UI (Phase 4), and SSE streaming.

## What I built
Branch `build/endo-gateway-mcp-termination` (head `e7e63160d`) on frozen base `llm-ca5aaef` (`ca5aaefb2`), two commits:
1. **`refactor(daemon)`**: moved the daemon gateway's per-address rate limiter, unchanged, into `packages/daemon/src/rate-limiter.js`. It is exported as `@endo/daemon/rate-limiter.js`, and `ws-gateway.js` imports it.
2. **`feat(agent-mcp-stdio)`**: new `src/http.js` and a new `endo-mcp-http` bin.
   - **Auth:** the bearer is the guest's formula id. It resolves through `resolveGuest`, so a host facet gets the same 401 as an unknown or malformed bearer. Failures advance the shared rate limiter (429 with `Retry-After`).
   - **Transport (stateless):** one JSON-RPC message per POST, 202 for notifications, 400 for parse errors or batches, 403 for an `Origin` not on the allow-list, 405 for GET, 413 for bodies over 4 MiB, 415 for non-JSON.
   - **Startup:** warns when bound beyond loopback, since a TLS proxy is required there.
   - **Other files:** new `test/http.test.js`, README section, design `## Status` section, and the design-index row changed to In Progress.

**Deviation from the design:** the endpoint runs on its own listener (default port 8921), not the daemon gateway's port. The guest declarations live in a package that already depends on `@endo/daemon`, so a daemon-side `gateway-mcp.js` would create a package cycle and break the `tsc` build. The handler can be mounted on the shared port once the declarations move below the daemon. Phase 2's bearer table is also not built: the daemon already maps a formula id to its guest, and the table belongs to the per-host Gateway design, which is still Proposed.

## Checks
- Package tests: 60 pass, but only with `TMPDIR=/tmp`. Two existing broker tests fail on the scratch-mount TMPDIR because `chmod` on a Unix socket returns EINVAL there; this change doesn't touch them.
- `tsc` and eslint are clean for the package; the daemon's `http-content-plane` test and daemon `tsc` pass.
- Pre-push gates pass, with one non-blocking warning about the 17-line header comment in `http.js`, which I kept. The phase-evidence gate passes as an `orchestrated-slice`, so the PR stays draft until the successor finishes.

## Jobs posted
- **`build-endo-gateway-mcp-termination-open-pr`**, pinned to `endolin-garden-ece02cb4`: it only runs `ensure-pr.sh` under this job's base, with the full PR body embedded, and opens the draft PR on `llm-ca5aaef`.
- **`build-endo-gateway-mcp-remaining-phases`**: the successor named in the PR's ledger. It owns the Chat "+ Add agent" button and "MCP" tab with a Playwright smoke test, SSE streaming with progress and cancel, and optionally mounting on the shared port. It then flips the ledger to `deliverable`.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-gateway-mcp-termination.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 102 tokens (5530742 cached reads)
- Output: 40417 tokens
- Cost: $3.046192400000002
- Wall-clock: 1229s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
