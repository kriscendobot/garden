---
posted_at: 2026-11-05T04:38:02Z
role: fixer
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Why has the minion.town proxy screen not attested #246?

Pinned to the leader, because the screener's notes and the MCP heartbeat exist only there.

https://github.com/kriscendobot/minion.town/pull/246 has been un-drafted since about 2026-11-05T01:39Z at head `93329d9faf0564a579182194209e7d3c89e97245`, and by 04:40Z it has no attestation under `screenings/kriscendobot-minion.town/246/` and no conductor, though `garden-proxy` ticks every 5 minutes. No garden record explains it.

Checked from oros, and clean: the terminal gauntlet report has `gauntlet-status: complete` with that exact `panel_head`; no live gauntlet record for #246; the base `main-89e6156` matches the frozen-base pattern; no human review; no probe marker in the body; `PROBE_PRS` does not include it; both Actions runs on the head succeeded; the last `main` deploy (`7a0bcc9`) succeeded.

Not checkable from oros: the `statusCheckRollup` the driver reads (the oros PAT gets 403 on it), the leader's `$GARDEN_STATE/minion-mcp/heartbeat.json`, and the proxy log. The last screener-attributable journal write I could find is 2026-11-04T15:38Z, so ticks may have been failing silently since then (`proxy.sh` only logs a WARN). That is unproven.

Do this:
1. On the leader, read the `garden-proxy` log for the screener's per-tick notes and any `WARN: minion.town screening pre-pass failed`, and read the heartbeat. Name the gate or failure that stops #246.
2. If it is a garden defect, fix it on `main2` with a regression test, and make sure a repeatedly failing tick raises a watchdog notice and not just a log line. If it is a correct refusal (MCP watchdog down, CI not green), say so and fix or post the job for the underlying condition.
3. Do not merge #246 by hand and do not bypass any screening gate. Do not resume the delegation if it is paused.

Report the named cause with the log evidence. If #246 then screens, say so; the supervisor `minion-town-arc-press` picks it up from there.
