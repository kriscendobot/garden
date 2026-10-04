---
child-minion-town-shell-to-js-20261004-part3-host: endolin-garden2-5bcdff64
child-minion-town-shell-to-js-20261004-part3-reap-count: 0
child-minion-town-shell-to-js-20261004-part2-host: endolin-garden-ece02cb4
child-minion-town-shell-to-js-20261004-part2-reap-count: 0
child-minion-town-shell-to-js-20261004-part1-host: endolin-garden2-5bcdff64
child-minion-town-shell-to-js-20261004-part1-reap-count: 0
order: serial
children: minion-town-shell-to-js-20261004-part1 minion-town-shell-to-js-20261004-part2 minion-town-shell-to-js-20261004-part3
on-child-failure: halt
state: running
created_by: gardener
created_at: 2026-10-04T17:34:47Z
---

Follow-up requested by kriskowal on https://github.com/kriscendobot/minion.town/pull/150#pullrequestreview-5407344186: convert minion.town's shell scripts (37 tracked .sh, ~4.3k lines, mostly deploy/aws/scripts) to JavaScript and adopt JavaScript for all Minion Town scripts going forward. Serial: part1 policy+guard+common helper+small scripts, part2 deploy-* bulk, part3 large/host-side scripts + retire common.sh.
