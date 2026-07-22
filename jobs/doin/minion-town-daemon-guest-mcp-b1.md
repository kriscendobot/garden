---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=high at=2026-07-22T08:25:05Z -->

Implement B0+B1 from the merged design https://github.com/kriscendobot/minion.town/pull/13 in https://github.com/kriscendobot/minion.town. Work in an isolated project worktree keyed to this job. Pin the selected endojs/endo-but-for-bots llm commit in the daemon deploy script and CapTP-client provenance, port the thin UDS CapTP client, then implement guest-control facet composition and the root-host socket adapter that replaces the Gate-2 stub. Add unit tests and a CI-runnable temp-socket integration helper proving provide -> write -> read -> restart -> read. Do not deploy yet. Report exact test/typecheck evidence and leave B2 untouched on failure.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 4
  worker_kind: gardener
  claimed_at: 2026-07-22T08:25:08Z
