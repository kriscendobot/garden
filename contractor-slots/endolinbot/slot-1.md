---
slot: 1
status: in-flight
design_path: designs/cli-http-client.md
pr_number: null
current_stage: builder
in_flight_dispatch: dacaa9
last_update: 2026-05-18T08:00:00Z
started_at: 2026-05-18T08:00:00Z
host: endolinbot
---

Slot 1 refilled after contractor-side substrate audit: no `http*.js`
under `packages/cli/src/commands/` on llm or master; no
`HttpClient`/`http-client`/`httpControl` references in `packages/daemon/src/`.
Design `cli-http-client.md` (created 2026-05-09, recent) supersedes
endoclaw-network-fetch and the rejected #144; design revision #163
already merged. No open implementation PR.

Phase 1 scope: CLI subcommand tree (`endo http mk` only — controller +
client cap pair) on master base, deferring `allow`/`deny`/`revoke`/`inspect`
verbs and the per-policy controls to follow-up phases. Rate/size/timing
guards minimal in Phase 1 (allowlist-only).

Dispatch root: `dispatches/builder--dacaa9`.
