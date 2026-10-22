---
handed-off: design-endor-bus-tui-phase-breakdown-open-pr
deliverable-complete: false
---
# design-endor-bus-tui-phase-breakdown: completion report

The phase breakdown is written and pushed, but the draft PR is **not open yet**. This host's bot token gets a 403 on `createPullRequest` for endojs. I posted successor job `design-endor-bus-tui-phase-breakdown-open-pr`, pinned `requires: host=endolin-garden-ece02cb4`, which carries the full PR body and opens the draft PR. It is on the board: `jobs/todo/design-endor-bus-tui-phase-breakdown-open-pr.md` on `journal2`.

**Branch:** `endojs/endo-but-for-bots` `design/endor-bus-tui-phases` at `df3f03d07`. It is one commit that touches only `designs/endor-bus-tui.md`. Its base, `llm-f02cd81`, already existed and points at the same commit as `llm` (`f02cd81b2`).

## What changed in `designs/endor-bus-tui.md`

- **New `## Ownership map`.** The two designs conflict:
  - `endor-tui.md` § Process model, and the in-flight Phase 1 PR #1525, make `endor tui` a separate client process.
  - This design said "the daemon owns the terminal."

  The map resolves it: the daemon holds all window and region state, and the `endor tui` client owns the terminal, layout and focus. "Attached" means at least one client is following the screen. Window and region IDs are scoped to the worker that owns them, so another worker can't reach them by guessing an ID.
- **`## Phases` split into 7 phases**, one builder PR each. `rust/endo` exists only on `llm`, so each PR is based on a frozen `llm-<sha>` branch. A mermaid diagram shows the dependencies and passes a parse check.
  1. **Daemon region store plus the text and buffer `tui.*` verbs (the first mergeable phase).** It needs nothing from #1525. It adds:
     - a pure `TuiStore` with a `tui_store::dispatch` function;
     - codec functions in `codec.rs`;
     - one `tui.*` branch in `handle_control_message`;
     - a cleanup in `Supervisor::unregister` that drops everything a worker owned when it exits;
     - a scrollback ceiling, so the daemon never stores unbounded worker output.

     **Acceptance tests** (`cargo test -p endo`):
     - store unit tests: role mismatches, scrollback eviction, line numbering, and a check that worker B can't use worker A's IDs;
     - codec round-trips, plus a `bad-argument` result for missing or wrong-typed fields;
     - a test that runs the full verb sequence through `dispatch`;
     - a test that `unregister` clears the worker's state;
     - clippy clean.

     Exit criterion: a worker sending raw envelopes can create and update a status window, and its state is gone after it exits.
  2. `endor tui` follows the store (a `tui.screen.follow` snapshot, then updates) and draws worker windows. This is the first phase that builds on #1525.
  3. The XS-side `endor:tui` module for text and buffer regions, built on the existing `issueCommand` host function. Phases 2 and 3 can be built in parallel.
  4. Input events and buffer editing.
  5. Canvas regions, mouse, focus events and floating windows.
  6. The Exo wrapper and `@tui-screen`.
  7. Hardening and diagnostics.
- **New `## Open questions`:**
  - Which screen size should be reported when several clients are attached?
  - Which client's input should reach a worker?
  - Where should the chat verbs that #1525 uses be specified? `endor-tui.md` says this design defines them, but it doesn't.
  - Should the stale PRs #166 and #216 be closed as superseded?
- Small edits: added an `Updated: 2026-10-22` row, and the Known Gaps reference now points to Phase 7. The status stays *Not Started*.

## Follow-ups

- `design-endor-bus-tui-phase-breakdown-open-pr` (posted, pinned to endolin) opens the draft PR. Its report will name the PR, which starts the design review automatically.
- The build of endor-bus-tui Phase 1 (daemon region store and the text and buffer verbs) comes after that review passes. The successor's report names it so the build is posted from there.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-endor-bus-tui-phase-breakdown.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (2692571 cached reads)
- Output: 20589 tokens
- Cost: $1.7479422000000002
- Wall-clock: 530s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
