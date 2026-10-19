---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
arc: minion-town-mcp-ocapn
---
PR-open handoff for job `build-endo-gateway-mcp-remaining-phases` (endojs/endo-but-for-bots). The bot PAT on oros-studio-garden-ce242c49 gets a 403 on createPullRequest, so this job is pinned to an endolin host. The work is done and pushed. Head `build/endo-gateway-mcp-remaining-phases` is at `cbbc9e09d71f5fd12ca70c91274e273dc145fda2`. It is stacked on the frozen base `build/endo-gateway-mcp-termination-e7e6316` (= `e7e63160d`, the head of the predecessor job `build-endo-gateway-mcp-termination`, whose own PR-open handoff is `build-endo-gateway-mcp-termination-open-pr`). Do NOT change any code.

Your only task: write the PR body between the BODY markers below to a file, check that `git ls-remote origin build/endo-gateway-mcp-remaining-phases` still shows cbbc9e09d, then run this from an `ensure-project-worktree.sh` checkout of the head (cwd = that project worktree, so the phase-evidence gate resolves the `designs/` paths):

    /Users/dom/garden/scripts/jobs/gardening/ensure-pr.sh build-endo-gateway-mcp-remaining-phases endojs/endo-but-for-bots build/endo-gateway-mcp-remaining-phases build/endo-gateway-mcp-termination-e7e6316 --title "feat(chat): Add agent button and per-agent MCP config (endo-gateway-mcp Phase 4)" --body-file <file>

Keep the job base `build-endo-gateway-mcp-remaining-phases` (not this job's base) so the PR carries the original job marker. The PR must open as DRAFT. Name the PR number in your completion report so the gauntlet is staged. Once the predecessor's PR exists, add a line `Stacked on #<that number>.` to the top of this PR's body if it is not already there.

-----BODY-----
Refs: `designs/endo-gateway-mcp.md` (milestone M6)

Stacked on the `endo-mcp-http` termination (head `build/endo-gateway-mcp-termination`, job `build-endo-gateway-mcp-termination`). Review only the top two commits.

## Description

This completes `designs/endo-gateway-mcp.md` with the Chat side (Phase 4) and records why streaming is out of scope.

- **"+ Add agent"** (`spaces-gutter.js`). A 🤖 button under the gutter's "+" opens the add-space modal directly on its New Profile form (`add-space-modal.js` gains `show({ mode: 'new-agent' })`). That form creates a guest and its space. It does not route to the Lal manager's form: an MCP client brings its own model, so the agent it drives is a bare guest. `chat-inventory-create-menu` is the fuller wizard and already subsumes this affordance.
- **"MCP"** (`mcp-config-modal.js`, new). Each non-home space's context menu has an "MCP" item. It looks the agent up with `E(powers).identify(...profilePath)` and shows:
  - the `mcpServers` block, with `url` set to the page origin plus `/mcp` and `Authorization: Bearer <formula id>`;
  - a Copy button;
  - the warning "This token is the agent's full authority. Treat it like an SSH key."

  The home space hides the item, because the termination refuses the host's bearer. This is a context-menu item rather than a tab because the space-home view has no tabs to add one to.
- **Streaming** (design only). The design now says why SSE, `notifications/progress` and `notifications/cancelled` forwarding are out of scope:
  - a `tools/call` is one eventual send that settles once, so there is no progress to report;
  - the daemon's `cancel` tears down a whole formula and its worker, and nothing cancels a single outstanding send;
  - each stateless `POST` (Decision 8) has no session in which a later cancel could find the earlier request.

  The termination already answers `202` to notifications and `405` to `GET`.
- **Mounting on the gateway port** is unchanged. The package cycle (`@endo/agent-mcp-stdio` depends on `@endo/daemon`) still holds.

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Design: `designs/endo-gateway-mcp.md`
Index: `designs/README.md` (status row only, no phases of its own)
Disposition: deliverable
Phase 1: superseded | `@endo/agent-tools` (`src/adapters/mcp.js`) plus the `@endo/agent-mcp-stdio` guest declarations, already on `llm`, are the extracted reusable tool surface
Phase 2: superseded | no bearer table is needed: the bearer resolves through `resolveGuest` on the user daemon; the table moves to the per-host Gateway of `gateway-package` (Proposed)
Phase 3: satisfied | `POST /mcp` with bearer auth, the shared rate limiter, and initialize, tools/list and tools/call in `endo-mcp-http` (`packages/agent-mcp-stdio/test/http.test.js`, predecessor commits); the design's § Streaming, cancellation, and concurrency now scopes the SSE stream out, with the reasons above
Phase 4: satisfied | the 🤖 "Add agent" button and the per-space "MCP" config modal in `@endo/chat` (`test/component/mcp-config-modal.test.js`, `test/component/spaces-gutter-home.test.js`)
Acceptance: satisfied | `packages/chat/test/e2e/mcp-config.spec.ts` passed in headless Chromium against a live, freshly started Endo daemon: it creates an agent through "Add agent", opens "MCP", checks that the block carries `Bearer <64-hex>:…` and the warning, and reads the copied block back from the browser clipboard
<!-- /garden-phase-evidence-ledger -->

### Security Considerations

The modal shows the agent's formula id, which is the agent's full authority, so it carries the warning beside the block. It never shows the host's id: the menu item is hidden for the home space, and `endo-mcp-http` refuses host bearers anyway. The lookup is the existing `identify` call, so no new identifier is minted.

### Scaling Considerations

None. There is one `identify` call each time the modal opens.

### Documentation Considerations

The design's Status section and the design index now read Complete. `@endo/chat` is private, so there is no changeset.

### Testing Considerations

- New component tests cover the block shape, Copy, the unknown-name error, hiding the modal, the menu item being hidden on home and shown elsewhere, and "Add agent" opening the New Profile form. All 31 component tests in the touched files pass.
- The Playwright smoke test passed locally with an isolated daemon (separate `XDG_*` dirs, `ENDO_ADDR=127.0.0.1:18920`) and `VITE_PORT=3000`. `playwright.config.ts` expects port 3000 while `vite.config.js` defaults to 5173. That mismatch predates this PR.
- `tsc` is clean and eslint reports no errors.

### Compatibility Considerations

The change is additive. `addSpaceModal.show()` with no argument behaves as before.

### Upgrade Considerations

None.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
-----END BODY-----
