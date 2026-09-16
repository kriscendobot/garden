---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Design a compatibility migration (or default) for legacy `host.registry` so the
minion.town @endo/reminder daemon can be revived onto `0eb88836`. The prior job
explicitly declined to improvise one; this design is that decision, made
deliberately.

THE FAILURE (job minion-town-reminder-daemon-redeploy-20260916, 2026-09-16, under
the maintainer's state-revival dry-run gate — the live daemon was NEVER touched):

- Live pin `/opt/endo/ENDO_COMMIT` = `f66505034aaa54ac46294347b2bf0e14655b088a`,
  daemon active, socket present. Target `0eb88836d6e823ec45409a665efcc4f96d7fd09c`
  is 1317 commits forward.
- The WIRE claim holds: `packages/daemon/src/client.js` (SHA-256 `0859aeab...`)
  and `mail.js` (`6ef7c33b...`) are byte-identical at both pins and match live.
- But wire compatibility is not state compatibility. Dry-run against a COPY of a
  captured snapshot: the SQLite database opened, node id `9b03f5b4...` loaded,
  and all 3635 formula rows deserialized — then revival threw
  `Error: Invalid formula identifier "[undefined]"` from `graph.js:onFormulaAdded`
  via `manager.js:seedFormulaGraphFromPersistence`.
- ROOT CAUSE: `0eb88836`'s graph treats `formula.registry` as a REQUIRED
  dependency of every `host` formula, but both persisted `host` rows are
  schema-v2 records with NO `registry` property (their keys end at the older
  `hostHandle/handle/.../pins` shape).
- The throw happened before the isolated daemon created its socket, so no
  persisted names/guests/formulas became reachable and the pre-existing live root
  list (61 names, incl. 14 guest names) could not be compared.

EVIDENCE YOU CAN USE (already on the box, do not recreate):
- Restorable pre-experiment snapshot:
  `/var/lib/endo-daemon/snapshots/state-pre-0eb88836-20260916T0548Z.tar.gz`
  (1.5 MiB, 830 members, SHA-256
  `c08fa79ffc6e035a3a9a420106dbc008abf8d79c5856b0b9f500d1b6c1f9aba1`).
- Isolated dry-run artifacts: `/opt/endo-revival-dry-run-20260916` and
  `/var/lib/endo-daemon/revival-dry-run-20260916`; failed transient unit
  `endo-revival-dry-run-20260916.service`.
- Design context: `designs/endo-reminder-minion-town.md` §§7-8.

DESIGN QUESTIONS TO SETTLE:
1. Is the right fix a DEFAULT for a missing `registry` on a legacy host formula,
   or an explicit one-shot MIGRATION that rewrites schema-v2 host rows forward?
   Weigh which is safer against a production store and which the Endo daemon's
   own design intends.
2. Is this actually an Endo-side bug — should `0eb88836` tolerate a host formula
   with no registry rather than throwing? If so, say whether the durable fix
   belongs upstream in the daemon with only a stopgap locally, and note that
   upstream interaction on agoric/agoric-sdk is forbidden but endojs work is not.
3. What does revival need to prove before anyone touches production? At minimum
   the dry-run must get far enough to create a socket and reproduce the live root
   list of 61 names including 14 guest names.
4. Rollback: what exactly restores the daemon if the migration is applied and
   proves wrong?

Deliver the design. Do NOT implement it, and do NOT touch the live daemon or its
persisted state — it remains active at `f6650503` and must stay that way until a
reviewed migration exists.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-16T23:07:45Z
