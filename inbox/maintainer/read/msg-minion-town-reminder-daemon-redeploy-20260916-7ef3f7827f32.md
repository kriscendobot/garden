from_host: endolin-garden-ece02cb4
from: gardener:minion-town-reminder-daemon-redeploy-20260916
reply_to: minion-town-reminder-daemon-redeploy-20260916
msg_key: msg-minion-town-reminder-daemon-redeploy-20260916-7ef3f7827f32
notice_count: 1
first_seen: 2026-09-16T05:52:44Z
last_seen: 2026-09-16T05:52:46Z
sent_at: 2026-09-16T05:52:46Z
---
AUTHORIZED REDEPLOY HALTED — state-revival dry-run failed; no live redeploy attempted.

Re-verification on 2026-09-16:

- Live `/opt/endo/ENDO_COMMIT` is still `f66505034aaa54ac46294347b2bf0e14655b088a`; `endo-daemon` is active and its socket is present.
- `packages/daemon/src/client.js` and `mail.js` remain byte-identical between `f6650503` and `0eb88836` and match the live files (SHA-256 `0859aeab…` and `6ef7c33b…`). `0eb88836` is still the expected 1317-commit forward move.
- A quiescent, restorable live-state snapshot was captured before the experiment at `/var/lib/endo-daemon/snapshots/state-pre-0eb88836-20260916T0548Z.tar.gz` (1.5 MiB compressed, 830 members, SHA-256 `c08fa79ffc6e035a3a9a420106dbc008abf8d79c5856b0b9f500d1b6c1f9aba1`). The live daemon restarted successfully at the old pin.

Dry-run result against a copy of that snapshot:

- Built the exact `0eb88836d6e823ec45409a665efcc4f96d7fd09c` runtime on the ARM64 target and started it with isolated state/cache/socket paths. The copied SQLite database opened, the existing node id `9b03f5b4…` loaded, and all 3635 formula rows deserialized.
- Revival then failed while seeding the new formula graph: `Error: Invalid formula identifier "[undefined]"`, from `graph.js:onFormulaAdded` via `manager.js:seedFormulaGraphFromPersistence`. The new `0eb88836` graph treats `formula.registry` as a required dependency of every `host` formula, but both persisted `host` rows are schema-v2 records with no `registry` property (their keys end at the older `hostHandle/handle/.../pins` shape).
- The throw occurred before the isolated daemon created its socket. Therefore no persisted names, guests, or formulas became accessible through `endo list`; the pre-existing live root list (61 names, including 14 guest names) could not be compared on the dry-run daemon. The dry-run service exited status 1.

Per authorization, I stopped here. I did not bump either pin, swap `/opt/endo`, touch the live state, remove the reminder shim, or attempt a migration. The production daemon remains active at `f6650503` with its live socket present. Isolated evidence remains at `/opt/endo-revival-dry-run-20260916` and `/var/lib/endo-daemon/revival-dry-run-20260916`; the failed transient unit is `endo-revival-dry-run-20260916.service`.

The next step needs an explicitly designed and reviewed compatibility migration/default for legacy `host.registry`; I have not improvised one.
