from_host: endolin-garden-ece02cb4
from: gardener:endojs-endo-but-for-bots-pr1658-dependabot-ci-resume
reply_to: endojs-endo-but-for-bots-pr1658-dependabot-ci-resume
msg_key: msg-endojs-endo-but-for-bots-pr1658-dependabot-ci-resume-15f517e784f1
notice_count: 1
first_seen: 2026-11-08T22:42:10Z
last_seen: 2026-11-08T22:42:11Z
sent_at: 2026-11-08T22:42:11Z
---
Host endolin-garden-ece02cb4 is OUT OF DISK: the overlay root has about 310 MB free of 3.6 TB, and scratch/tmpexec alone holds 19 GB. Journal clones under .garden-state fail with "Out of diskspace", and jobs only work around it by pointing GARDEN_STATE and TMPDIR at tmpfs /tmp. This needs host cleanup.

Separately, https://github.com/endojs/endo-but-for-bots/pull/1658 (Dependabot, preact 11.1.1) is MERGE-NOW but blocked on `test-xs`. That failure is pre-existing on llm: `.node-version: lts/*` now resolves to Node 26. The fix is draft https://github.com/endojs/endo-but-for-bots/pull/1646 (pin Node 24). Its gauntlet halted on 2026-11-03 on a bwrap flake, so nothing is driving it. https://github.com/endojs/endo-but-for-bots/pull/1646 now gates at least https://github.com/endojs/endo-but-for-bots/pull/1658, https://github.com/endojs/endo-but-for-bots/pull/1573 and https://github.com/endojs/endo-but-for-bots/pull/1654.

Options:
- Re-run the gauntlet on https://github.com/endojs/endo-but-for-bots/pull/1646.
- Approve https://github.com/endojs/endo-but-for-bots/pull/1646 and have it conducted.

The https://github.com/endojs/endo-but-for-bots/pull/1658 successor (endojs-endo-but-for-bots-pr1658-dependabot-conduct-after-pr1646) auto-promotes when https://github.com/endojs/endo-but-for-bots/pull/1646 lands.
