---
gate: go-ahead
priority: normal
posted_by: producer
posted_at: 2026-08-13T14:35:07Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: the garden itself (journal board operation)

# Launch the Ironhorse test262 campaign resume-3 (21 children, js-08..js-28)

PRECONDITIONS (verify BOTH before launching — parked go-ahead for exactly this reason):

1. orchestrate.sh fix is DEPLOYED on the leader. Confirm the deployed root
   /home/kris/garden2/scripts/jobs/orchestrate.sh contains GARDEN_ORCH_GONE_RECHECK
   (the gone-recheck guard from main2 commit 9393c3ce6d). If absent, the deploy has not
   landed — drive it (liaison deploy-on-upgrade Monitor, or a sysop deploy op in a quiet
   window: scripts/jobs/send-host-op.sh endolin-garden2-5bcdff64 op=deploy
   authorized_by=kriskowal) and wait. Do NOT launch on an undeployed watcher; launching
   resume-3 keeps the fleet busy and blocks the deploy, so confirm the deploy FIRST.

2. Budget figure chosen by the maintainer. See maintainer message 20260813T143405Z.
   Bases: mechanism-consistent (top-level child ledgers, what campaign-spend.sh enforces)
   = cumulative 1,329,482 -> remaining 750,518; honest total incl. gauntlet sub-jobs
   = 3,307,979 -> already OVER the 2,080,000 budget. Use the approved figure (recommend
   750,518 to continue this window; or pause until Fri 2026-08-15 21:00 Pacific reset).

LAUNCH (once both hold), from a synced journal, with the chosen <REMAINING>:

    scripts/jobs/post-orchestration.sh --serial --on-child-failure halt \
      --budget-tokens <REMAINING> \
      ironhorse-test262-implementation-completion-resume-3 \
      ironhorse-js-08-async-generators-for-await ironhorse-js-09-proxy-mop \
      ironhorse-js-10-arrays-species ironhorse-js-11-strings ironhorse-js-12-regexp \
      ironhorse-js-13-numeric-date-json ironhorse-js-14-binary-data-atomics \
      ironhorse-js-15-collections ironhorse-js-16-modules ironhorse-js-17-resource-management \
      ironhorse-js-18-realms-eval-annexb ironhorse-js-19-intl-core ironhorse-js-20-intl-formatters \
      ironhorse-js-21-intl-datetime-segmenter ironhorse-js-22-temporal-core \
      ironhorse-js-23-temporal-plain ironhorse-js-24-temporal-zoned \
      ironhorse-js-25-temporal-integration ironhorse-js-26-residual-gap-closure \
      ironhorse-js-27-full-suite-report-refresh ironhorse-js-28-issue-summary

All 21 children are already staged in jobs/plan/ with gate: orchestrated (verified
2026-08-13, no drift) — do NOT re-recover them. post-orchestration.sh retags them into the
new campaign epoch; the serial orchestrate watcher (now fixed) promotes them one at a time.
