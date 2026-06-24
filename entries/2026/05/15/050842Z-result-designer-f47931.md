---
ts: 2026-05-15T05:08:42Z
kind: result
role: designer
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/designer--f47931/
refs:
  - entries/2026/05/15/044500Z-dispatch-liaison-f47931.md
  - projects/endo/drafts/endopen.md
---

# Result: designer endopen (f47931) — opencode comparative analysis + 4 sibling gap-closing designs

## Deliverables

Authored under `project/designs/` on the dispatch worktree:

- `designs/endopen.md` (primary, Reference): comparative analysis mirroring the `endoclaw.md` shape — architecture-comparison table, feature-by-feature mapping, contrasts (capability model, persistence, extensibility, security), citation index of 19 OpenCode source files (HEAD `d59d9966`, cloned to `dispatches/designer--f47931/external/opencode/`).
- `designs/endopen-concurrent-subagents.md` (Not Started, M3): panel guest pattern + Chat widget exposing Endo's structural concurrency advantage; addresses the maintainer's framing that concurrent subagents "fall out of endo more trivially given its formula isolation + capability model".
- `designs/endopen-openrouter.md` (Not Started, M1): OpenRouter provider for Lal in three phases (minimal cut → registry refactor → form-based config).
- `designs/endopen-tui-shell.md` (Not Started, M4): browser-side opencode-shaped *coding* space kind in `packages/chat`; complement of M6 `endor-tui`.
- `designs/endopen-acp-server.md` (Not Started, M3): ACP (Agent Client Protocol) server adapter so Zed and other ACP clients can drive Endo while preserving the capability story by routing permission requests through `daemon-form-request`.

Updates:

- `designs/README.md`: 5 summary-table rows, milestone placements, dependency-graph edges, per-design size estimates, milestone tallies (54 remaining; ~54–74 weeks effort; 109 designs total).
- `journal/projects/endo/drafts/README.md`: drafts-of-record entries for all five new designs (plus a row absorbing the sibling endopi dispatch's 9 drafts that landed concurrently).
- All 5 design files copied to `journal/projects/endo/drafts/` per the dispatch-survival pattern.

## Branch and PR

Branch `design/endopen` pushed to `endojs/endo-but-for-bots`:

- Head SHA: `7424956fd`
- Push URL hint: https://github.com/endojs/endo-but-for-bots/pull/new/design/endopen

The PR open step is the next action; the designer's per-action authorization in the dispatch covers opening as DRAFT against `llm`.

## Findings

- **Maintainer's framing on concurrency is right.** OpenCode's `task` tool is fundamentally synchronous; the `background: true` flag is gated behind `OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS=true` (one boolean at `packages/opencode/src/tool/task.ts` line 113). Endo's guest-as-vat model gives concurrent subagents by default; the gap is the UX surface, not the runtime.
- **OpenRouter integration in OpenCode is small but structurally informed.** OpenCode's `BUNDLED_PROVIDERS` map (`provider.ts` lines 88–119) + the `customLoaders` dictionary (lines 410–459) separate "how to talk to a provider" from "what extra headers / options the provider wants". Lal's per-provider-file pattern is fine at 4 providers but the registry pattern pays off at 10+.
- **OpenCode's ACP server is the killer interop feature.** Zed integrates via a four-line `agent_servers` block. Endo gaining an ACP adapter would make it a drop-in alternative for any ACP client, with the bonus that Endo's permission story (form-request via daemon) is *stronger* than OpenCode's (auto-approve).
- **The OpenCode TUI vocabulary is portable to Chat as a space kind.** Sidebar / transcript / status-bar / command-palette / todo-pane can land as a new `coding` space kind without rewriting any existing Chat component; it composes with the existing `blob-viewer`, `browser-tree`, `chat-bar`, and `command-registry` modules.

## Counts

- Gaps identified: 4 with dedicated spin-outs (concurrent-subagents, OpenRouter, opencode-shaped UX, ACP server) + 6 surfaced-but-deferred in the primary doc's summary table (MCP client, MCP server, LSP, plan/build modes, todo state, cost telemetry).
- OpenCode source files cited: 19 (full inventory in `designs/endopen.md` § Citation Index).

## Self-improvement

`Self-improvement: nothing this time` — the dispatch flow (read template, walk both codebases, author primary + spin-outs, mirror to journal, commit+push before validation) executed cleanly per the 2026-05-15 `015257Z` self-improvement directive. One small datum: the project's `git push origin HEAD:design/endopen` form requires the full `refs/heads/design/endopen` refname rather than the bare `design/endopen` when the source is `HEAD` on a detached HEAD; the existing `journal-sync` skill uses `HEAD:journal` and works because `journal` is a top-level branch name git can disambiguate. This is a minor friction (one extra error round-trip) and worth a one-line note in `WORKTREES.md` § Per-dispatch worktree triple or in the `worktree-per-pr` skill if it isn't already captured.
