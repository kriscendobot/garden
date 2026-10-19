---
arc: minion-town-mcp-ocapn
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Build job on endojs/endo-but-for-bots, `designs/ocapn-noise-session-reconnect.md` Phase 5 (crossed-hellos). Add the designator-comparison tiebreaker, tested with a fault injector that forces simultaneous loss detection. Open it as a stacked draft PR on the Phase 3 Rekey branch (`build/ocapn-noise-session-reconnect-rekey`, PR #1481), reusing the Phase 2 session queue (PR #1478). It is independent of the queued Phase 4 Resume job.
