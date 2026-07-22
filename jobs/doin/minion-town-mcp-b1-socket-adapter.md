---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=high at=2026-07-22T16:10:06Z -->

# B1: socket adapter and both interfaces

Repository: kriscendobot/minion.town.

After B0, implement B1 from designs/mcp-daemon-guest-tools.md §7. Build src/endo/guest-control.ts with GuestControl and the single facet-composition grant site, plus src/endo/root-host-socket.ts implementing RootHost. Wire connectRealRootControl and remove its Gate-2 daemon-control stub. Reuse the B0 CapTP client and follow the existing root-host-memory fake pattern.

Validation required: unit tests using in-memory fakes, plus a CI-runnable integration helper that checks out endojs/endo-but-for-bots at B0 pinned commit, starts endo run-daemon on a temporary ENDO_SOCK, and proves provide -> write -> read -> restart -> read. Report executed evidence. B0 and B1 are one PR/branch as the design directs.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 22
  worker_kind: cleric
  claimed_at: 2026-07-22T16:10:12Z
