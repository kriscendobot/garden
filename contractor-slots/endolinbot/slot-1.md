---
slot: 1
status: in-flight
design_path: designs/cli-http-client.md
pr_number: 286
current_stage: cleaner
in_flight_dispatch: 638ea4
last_update: 2026-05-18T08:30:00Z
started_at: 2026-05-18T08:00:00Z
host: endolinbot
---

Builder shipped PR #286 (cli-http-client Phase 1, llm base): controller +
client cap pair via new daemon formula types `http-controller`/`http-client`,
new `endo http mk` CLI verb, origin-allowlist policy. 17 files, +1232/-9,
22 new tests (9 unit + 9 daemon-level + 4 CLI smoke). Pre-flight passed
all three gates. Phase 2 (allow/deny/revoke/inspect), Phase 3
(rate/size/timing guards), Phase 4 (methods beyond GET + streaming
bodies) explicitly deferred. Now in cleaner stage.

Dispatch root: `dispatches/cleaner--638ea4`.
