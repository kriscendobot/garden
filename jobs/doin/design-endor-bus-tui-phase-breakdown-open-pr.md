---
arc: moonshots
role: designer
tier: mentor
fallback-tier: minion
requires: host=endolin-garden-ece02cb4
dispatch: automatic
---
Open the draft design PR for job `design-endor-bus-tui-phase-breakdown` on endojs/endo-but-for-bots. The predecessor ran on oros-studio-garden-ce242c49, whose bot PAT gets a 403 on `createPullRequest` for endojs. It already pushed everything:

- head `design/endor-bus-tui-phases` at `df3f03d07`, a single commit touching only `designs/endor-bus-tui.md`
- frozen base `llm-f02cd81`, which already exists and equals `llm` at `f02cd81b2`

Your only task: get a project checkout with `scripts/jobs/ensure-project-worktree.sh design-endor-bus-tui-phase-breakdown-open-pr endojs/endo-but-for-bots design/endor-bus-tui-phases`, cd into it, and run, with the body below saved to a file F:

    scripts/jobs/gardening/ensure-pr.sh design-endor-bus-tui-phase-breakdown endojs/endo-but-for-bots design/endor-bus-tui-phases llm-f02cd81 --draft --title "design(endor-bus-tui): phase breakdown sequenced after endor-tui Phase 1" --body-file F

Use the predecessor's job base, as shown, so the PR carries its `garden-job` marker. Then confirm the PR is draft and that its head and base are correct. Leave it draft. Name the PR URL in your report, so the completion machinery stages its design-panel gauntlet. The build of Phase 1 follows once that design gauntlet passes. Name it in your `## Follow-ups` as the build of endor-bus-tui Phase 1 (daemon region store and text/buffer verbs).

----- PR BODY (everything between the markers) -----
Refs: designs/endor-bus-tui.md (M11), designs/endor-tui.md, #1525

## Description

Design step: this PR breaks the worker-programmable terminal UI in `designs/endor-bus-tui.md` into buildable phases. They are sequenced after the endor-tui Phase 1 skeleton that is in flight in #1525, and the first mergeable phase has its acceptance tests written out.

- **New `## Ownership map`.** It settles the tension between the two designs. endor-tui § Process model (and #1525) makes `endor tui` a separate client process, while this design says "the daemon owns the terminal". The map puts window and region **state** in the daemon and the **terminal, layout and focus** in the `endor tui` client. "Attached" means at least one client is following the screen. Window and region IDs are scoped to the owning worker handle, so an ID alone carries no authority.
- **`## Phases` re-cut into 7 phases**, each one builder PR on a frozen `llm-<sha>` base (`rust/endo` exists only on `llm`):
  1. **Daemon region store plus the text/buffer `tui.*` verbs.** This is the first mergeable phase, and it needs nothing from #1525. Its parts are a pure `TuiStore`, the codec, one `tui.*` arm in `handle_control_message`, an owner sweep in `Supervisor::unregister`, and a scrollback ceiling. The acceptance tests are spelled out.
  2. `endor tui` follows the store (`tui.screen.follow` snapshot plus deltas) and renders worker windows. This is the first phase that builds on #1525.
  3. The XS `endor:tui` module for text and buffer regions, built on `issueCommand`. Phases 2 and 3 can be built in parallel.
  4. Input events and buffer editing.
  5. Canvas regions, mouse, and focus.
  6. The Exo wrapper and `@tui-screen`.
  7. Hardening and diagnostics.
- **New `## Open questions`:**
  - which terminal size to report when several clients are attached;
  - which client's input reaches a worker;
  - where the chat verbs #1525 speaks get specified, since endor-tui says they are defined here but they are not;
  - whether the stale #166 and #216 should be closed as superseded.

Nothing else in the document changes except one Known Gaps cross-reference, which now points to Phase 7.

### Security Considerations

Design only. The ownership map writes down that cross-worker access goes through the Phase 6 Exo wrapper and never through region IDs.

### Scaling Considerations

Phase 1 adds a scrollback ceiling, pulled forward from hardening, so the daemon never stores unbounded worker output.

### Documentation Considerations

The design document is the deliverable.

### Testing Considerations

Phase 1 lists its acceptance tests: store unit tests, codec round-trips, dispatch, and the owner sweep, all under `cargo test -p endo`. The mermaid diagram passes a parse check.

### Compatibility Considerations

None. No code changes.

### Upgrade Considerations

None.

<!-- garden-job: design-endor-bus-tui-phase-breakdown -->

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END PR BODY -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-22T02:04:47Z
