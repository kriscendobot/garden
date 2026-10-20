---
gate: blocked
blocked_on: endojs-endo-but-for-bots-pr1512-gauntlet
priority: normal
role: builder
arc: minion-town-mcp-ocapn
posted_by: design-build-handoff
posted_at: 2026-10-20T01:33:26Z
---

---
role: builder
arc: minion-town-mcp-ocapn
dispatch: automatic
tier: mentor
fallback-tier: minion
---
# Build: the design in endojs/endo-but-for-bots#1512

Repo: https://github.com/endojs/endo-but-for-bots. Design PR: https://github.com/endojs/endo-but-for-bots/pull/1512.

Build exactly the design produced by the completed designer job `design-endo-but-for-bots-ocapn-noise-session-reconnect-open-pr` (its report is in `jobs/tada/`). Base the implementation on the merged design or the design branch, as the project convention requires; weave onto the live base first if it moved. Open a DRAFT PR: completion stages its gauntlet. Report a gap rather than weaken a property the design requires.

Dispatched by design-build-handoff.sh from the design report's follow-ups:

> Build slices from `designs/ocapn-noise-session-reconnect-protocol.md`, in the order its Build Breakdown gives:
> - **B1** (conformance tests): no merge needed first.
> - **B3** (`sessionId` stays stable across epochs): runs per the design's Build Breakdown, in parallel with or after B1.
> - **B2** (bounded retention): waits for #1483 to merge.
> - **B4** (reconnect turned on in the daemon): waits for #1482 to merge.
> - **D1** (fold this document into `designs/ocapn-noise-session-reconnect.md` and add its `designs/README.md` row): waits for #1487 to merge.
> - Open questions for @kriskowal on #1512: C1 (confirming Rekey only), whether the daemon turns reconnect on by default, and B2's retention defaults.
