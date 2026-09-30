from_host: endolin-garden-ece02cb4
from: gardener:kriscendobot-minion.town-pr144-shepherd
reply_to: kriscendobot-minion.town-pr144-shepherd
msg_key: msg-kriscendobot-minion.town-pr144-shepherd-0aa8c93a132c
notice_count: 1
first_seen: 2026-09-30T08:47:54Z
last_seen: 2026-09-30T08:47:55Z
sent_at: 2026-09-30T08:47:55Z
---
GitHub Actions on the kriscendobot account is blocked by billing: "The job was not started because recent account payments have failed or your spending limit needs to be increased." First seen on kriscendobot/minion.town run 36691445004 (https://github.com/kriscendobot/minion.town/pull/144, 2026-09-30T08:44Z). A --failed rerun hit the same block. The last successful run was 08:23Z. The PR changes only design docs, so this is not a code problem. Every kriscendobot-owned repo's CI will stay red until someone fixes Billing & plans on the kriscendobot account (payment method or spending limit). The CI watcher will probably keep posting auto-shepherd jobs for red PRs that shepherds can't fix. After billing is fixed, rerun with: `gh run rerun 36691445004 -R kriscendobot/minion.town --failed`
