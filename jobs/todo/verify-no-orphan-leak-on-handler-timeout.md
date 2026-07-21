---
role: assayer
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-21T05:22:16Z -->

# assayer — verify the orphan-reap fix leaves ZERO orphans (the resume gate)

This is the **assurance the maintainer requires before the `xs2rust-endor-press`
schedule may resume**. Independently verify the fix from the sibling job
`fix-handler-reap-spawned-process-group`.

## What to prove
Construct a minimal claim-scoped handler that spawns a multi-process child tree
(a parent that forks sleepers / a stub daemon) and then **exceeds its handler
budget**. Confirm the reaper kills the **entire process group** — afterward there
must be **ZERO** descendants left reparented to `systemd --user` (no `endor-xst`,
`endor`, `node`, or `manager-node.js` survivors).

## Rigor
- Give explicit evidence: `ps`/process counts BEFORE (tree alive) and AFTER
  (group gone).
- Distinguish **landed** from **deployed**: the reaper runs from the deployed root
  via systemd. If the fix is on `main2` but **not yet deployed**, say so and do
  NOT declare the running fleet fixed — the deployed reaper is what a resumed
  press meets.
- If ANY orphan survives, or the fix is not effective on the path a resumed press
  would hit, **FAIL** (report `orchestration-failed: true`) so the serial
  orchestration HALTS and the schedule is NOT resumed.
