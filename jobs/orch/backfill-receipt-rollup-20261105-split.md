---
child-backfill-receipt-rollup-20261105-expanded-window-host: endolin-garden-ece02cb4
child-backfill-receipt-rollup-20261105-expanded-window-reap-count: 0
order: serial
children: backfill-receipt-rollup-20261105-expanded-window
on-child-failure: halt
state: running
created_by: orchestrator
created_at: 2026-11-05T06:06:33Z
---

# Expanded-window receipt rollup backfill

split-indivisible-reason: All 209 updates append to one journal2 rollup and share one computed cost base map, so splitting would introduce CAS conflicts or duplicate the expensive ledger pricing pass.
split-indivisible-handler-timeout: 7200

Run the single expanded-window child to preserve one base-map computation and one serial append stream into the shared rollup.
