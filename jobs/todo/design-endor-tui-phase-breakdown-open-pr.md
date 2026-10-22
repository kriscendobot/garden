---
arc: moonshots
role: designer
tier: mentor
fallback-tier: minion
requires: host=endolin-garden-ece02cb4
dispatch: automatic
---
Open the draft design PR for job `design-endor-tui-phase-breakdown` on endojs/endo-but-for-bots. The predecessor ran on oros-studio-garden-ce242c49, whose bot PAT gets a 403 on `createPullRequest` for endojs. It already pushed everything:

- head `design/endor-tui-phases` at `2f2b2e4cd`, a single commit touching only `designs/endor-tui.md`
- frozen base `llm-f02cd81`, which already exists and equals `llm` at `f02cd81b2`

Your only task: get a project checkout with `scripts/jobs/ensure-project-worktree.sh design-endor-tui-phase-breakdown-open-pr endojs/endo-but-for-bots design/endor-tui-phases`, cd into it, and run, with the body below saved to a file F:

    scripts/jobs/gardening/ensure-pr.sh design-endor-tui-phase-breakdown endojs/endo-but-for-bots design/endor-tui-phases llm-f02cd81 --draft --title "design(endor-tui): phase breakdown sequenced after Phase 1 (#1525)" --body-file F

Use the predecessor's job base, as shown, so the PR carries its `garden-job` marker. Then confirm the PR is draft and that its head and base are correct. Leave it draft. Name the PR URL in your report, so the completion machinery stages its design-panel gauntlet. Builds of Phase 2 onward wait on that gauntlet and on the maintainer's answer to the Phase 2 open question (CapTP client vs. manager-side verbs). In your `## Follow-ups`, name the build of endor-tui Phase 2 (chat data path) as gated on that answer.

----- PR BODY (everything between the markers) -----
Refs: designs/endor-tui.md (M11), designs/endor-bus-tui.md, #1525

## Description

Design step: this PR breaks the XL `designs/endor-tui.md` into eight phases, each one builder PR that merges on its own. Each phase has a size and its dependency edges. Phase 1 is the skeleton in flight in #1525.

- **New `## Ownership map`.** The client socket is bridged as `deliver` envelopes to the JS manager, which speaks CapTP (`socket.rs`). The map therefore puts chat and debugger **state** in the manager and the **terminal, layout and mode** in the `endor tui` client, which only holds a cache it rebuilds on reconnect.
- **`## Phased Implementation` re-cut** (table and mermaid graph in the doc):
  1. Skeleton and chat transcript: M, #1525.
  2. **Chat data path**: L, depends on 1. It replaces #1525's provisional payloads, which no daemon serves, with a path the daemon does serve. Every later phase that shows real state waits on it.
  3. Spaces and per-space themes: M, depends on 2.
  4. Value inspection and forms: L, depends on 2.
  5. XS debugger baseline: L, depends on 2 and on the open items in `daemon-xs-worker-debugger`, which are a host-exposed `attachDebugger` and `followBreaks`.
  6. Debugger richness: M, depends on 5.
  7. Durable breakpoints and controller claim: M, depends on 5.
  8. Polish and escape valves: M, depends on 3, 4 and 6.

  Phases 3, 4 and 5 can be built in parallel, and so can 6 and 7. Focus mode and the pending region moved into Phase 1, because #1525 already builds them.
- **New `## Open questions`:**
  - Should Phase 2 be a minimal Rust CapTP client over the existing socket (the path the `endo` CLI uses, and the recommendation here), or a manager-side adapter serving the bus-verb table? endor-tui says endor-bus-tui defines those chat verbs, but it does not.
  - Should the debugger follow the same path?
- Known Gaps entries now point to the phases that close them.

The phases are also recorded in the journal plan as records `endor-tui-phase-1` through `endor-tui-phase-8`, with these sizes and `depends_on` edges.

### Security Considerations

Design only. The ownership map states that the manager authorizes every chat and debugger call against the client's host capability, and that attaching to a worker the caller does not hold is refused.

### Scaling Considerations

None for the design itself.

### Documentation Considerations

The design document is the deliverable.

### Testing Considerations

Each phase from 2 to 7 lists acceptance tests. The mermaid diagram passes a parse check.

### Compatibility Considerations

None. No code changes. The edit does not touch the Status row that #1525 changes.

### Upgrade Considerations

None.

<!-- garden-job: design-endor-tui-phase-breakdown -->

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END PR BODY -----
