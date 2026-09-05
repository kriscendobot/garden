---
child-minion-town-eval-guestbook-tally-reap-count: 0
child-minion-town-eval-odometer-counter-host: endolin-garden2-5bcdff64
child-minion-town-eval-odometer-counter-reap-count: 0
child-minion-town-eval-namestore-durability-host: endolin-garden-ece02cb4
child-minion-town-eval-static-publish-host: endolin-garden2-5bcdff64
child-minion-town-eval-static-publish-reap-count: 0
order: serial
children: minion-town-eval-static-publish minion-town-eval-namestore-durability minion-town-eval-odometer-counter minion-town-eval-guestbook-tally minion-town-eval-sandbox-boundary minion-town-eval-site-lifecycle minion-town-eval-mail-pair minion-town-eval-error-probes
on-child-failure: continue
state: running
budget_tokens: 12000000
created_by: design-minion-town-eval-campaign
created_at: 2026-09-01T19:38:13Z
---

# orchestration minion-town-eval-campaign

Eight serial evaluations of the minion.town MCP daemon-guest tool surface
(`status`/`list`/`listSites`/`publish`/`upgrade`/`unpublish`/`adopt`/
`dismiss`/`resolve`/`send`/`listMessages`/`evaluate`/`writeText`/`readText`/
`has`/`remove`), each a fresh-agent, schemas-as-only-documentation exercise
with a checkable deliverable, mandatory verification (curl/Playwright/
second-guest MCP transcript), and a mandatory documentation-quality report
section.

Serial, deliberately: every child authenticates via the same
client-credentials test client, and the daemon keys the guest on the token's
issuer+subject — so all children share ONE guest, one pet-name directory,
and one mailbox. Parallel children would interleave `list`/mailbox/lifecycle
state and contaminate each other's fresh-agent premise. Serial also lets the
campaign carry a token budget (`budget_tokens` is serial-only).

`on-child-failure: continue`, deliberately: a failed evaluation is itself a
documentation finding the synthesis must see, and the converging step
(`minion-town-eval-synthesis`, parked `blocked_on` this record's base) is
promoted by the unblock watcher only when this orchestration writes its
outcome summary to `jobs/tada/minion-town-eval-campaign.md`. A `halt` policy
could instead finish this record as `halted`, which reads as a failed
blocker (`tada_failed`) and would hold the synthesis for a human — the
continue policy keeps the convergence automatic.

Proposed and reviewed via the campaign PR opened by job
`design-minion-town-eval-campaign` (maintainer directive, 2026-09-01);
merging that PR onto `journal2` is what armed this record.
