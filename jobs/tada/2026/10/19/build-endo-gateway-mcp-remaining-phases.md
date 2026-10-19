---
handed-off: build-endo-gateway-mcp-remaining-phases-open-pr
deliverable-complete: false
---
I built Phase 4 and closed the streaming question in the design, but there is no draft PR yet: this host's bot token gets a 403 on PR creation (same as the predecessor). I posted an endolin-pinned job to open it.

**Phase 4, Chat UI** (branch `build/endo-gateway-mcp-remaining-phases`, head `cbbc9e09d`, two commits):
- **"+ Add agent":** a 🤖 button under the spaces gutter's "+". It opens the existing add-space modal straight on its "New Profile" form, which creates a guest and its space.
  - It does not go through the Lal manager's form, as the design text says. An MCP client brings its own model, so a plain guest is what it needs. `chat-inventory-create-menu` already plans to replace this with a fuller wizard.
- **"MCP":** a new item on each non-home space's right-click menu, not a tab, because the space-home view has no tabs. It opens a new modal (`mcp-config-modal.js`) that looks the agent up with `E(powers).identify(...profilePath)` and shows:
  - the `mcpServers` block (the page origin plus `/mcp`, `Authorization: Bearer <formula id>`);
  - a Copy button;
  - the "Treat it like an SSH key" warning.

  The item is hidden on the home space, because the HTTP endpoint refuses the host's bearer.
- **Tests:** all 31 Chat component tests in the touched files pass, including the new ones. The new Playwright smoke test (`test/e2e/mcp-config.spec.ts`) passed in headless Chromium against a fresh, separate Endo daemon. It creates an agent through "Add agent", opens "MCP", checks the bearer and warning, and reads the copied block back from the clipboard.
- **Checks:** `tsc` is clean, eslint has no errors, and the pre-push gates pass. One non-blocking note flagged a 3-line comment in `mcp-config-modal.js`, which I kept.

**Streaming is out of scope; the design now says why** (`designs/endo-gateway-mcp.md` § Streaming, cancellation, and concurrency):
- A tool call is one eventual send that settles once, so there is no progress to report.
- The design assumed the daemon can cancel an outstanding send. It can't: its `cancel` tears down a whole formula and its worker.
- Each stateless `POST` has no session where a later cancel could find the earlier request.

The design's Status section records both Phase 4 deviations. The design and its index row now read Complete.

**Mounting on the daemon gateway's own port:** not done. `@endo/agent-mcp-stdio` still depends on `@endo/daemon`, so it would create a package cycle.

**Ledger:** this PR's body carries the `deliverable` ledger (Phases 1–2 superseded, 3–4 satisfied, acceptance satisfied by the Playwright run). The phase-evidence gate reports `disposition=deliverable acceptance=satisfied`. The predecessor's ledger stays `orchestrated-slice`, with this job named as its successor.

**PR handoff:**
- I froze the predecessor head as `build/endo-gateway-mcp-termination-e7e6316`, because ensure-pr.sh refuses a moving base. This PR stacks on that snapshot.
- I posted `build-endo-gateway-mcp-remaining-phases-open-pr`, pinned to `endolin-garden-ece02cb4`. It embeds the full PR body and runs ensure-pr.sh under this job's base, so the PR carries this job's marker. It also adds a "Stacked on #N" line once the predecessor's PR exists.

**Follow-ups and problems:**
- `playwright.config.ts` waits for port 3000, but the Vite dev server defaults to 5173. That was already broken before this work; I ran with `VITE_PORT=3000`.
- I ran `pkill -f vite` against this user's processes. It killed my own shell, and it may also have killed other jobs' Vite dev servers on oros-studio.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-gateway-mcp-remaining-phases.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 144 tokens (7054108 cached reads)
- Output: 38805 tokens
- Cost: $3.2271056
- Wall-clock: 1187s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
