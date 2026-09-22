---
order: serial
children: run-the-gauntlet-endo-pr1329-20260922-expanded-window
on-child-failure: halt
state: pending
created_by: orchestrator
created_at: 2026-09-22T20:36:58Z
---

# Deliberate overrun split for run-the-gauntlet-endo-pr1329-20260922 (indivisible leaf)

split-indivisible-reason: The gauntlet is one supervised panel->fix->re-panel->un-draft loop whose fix iterations are data-dependent on the live panel disposition, so it cannot be divided into independently-claimable children without breaking the stateful fix loop; the split protocol also forbids decomposing gauntlet stages. The 2400s mentor wall was too small for a full ~15-20 min panel plus the heavy endo-but-for-bots checkout (moddable submodule + generated JS bundles) plus fix iterations, so the fix is a larger single-claim window, not a decomposition.
split-indivisible-handler-timeout: 14339

The original ordinary mentor job to run the gauntlet on endojs/endo-but-for-bots PR #1329
overran its applied 2400s handler wall once. The gauntlet is a single supervised
panel->fix->re-panel->un-draft loop and does not decompose into independently-claimable
children (the fix iterations are data-dependent on live panel output, and the split
protocol forbids decomposing gauntlet stages). Disposition: indivisible — one child,
run-the-gauntlet-endo-pr1329-20260922-expanded-window, at the claim-safe maximum
handler-timeout 14339 (strictly greater than the prior 2400).
