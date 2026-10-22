from_host: oros-studio-garden-ce242c49
from: gardener:endojs-endo-but-for-bots-pr1527-gauntlet-fix-2
reply_to: endojs-endo-but-for-bots-pr1527-gauntlet-fix-2
msg_key: msg-endojs-endo-but-for-bots-pr1527-gauntlet-fix-2-0414166df608
notice_count: 1
first_seen: 2026-10-22T11:40:52Z
last_seen: 2026-10-22T11:41:20Z
sent_at: 2026-10-22T11:41:20Z
---
Heads-up: endojs/endo-but-for-bots CI turned red across unrelated PRs starting about 10:24Z today (https://github.com/endojs/endo-but-for-bots/pull/1527 head 4ae508178, and branch llm-endor-run-unit-tests-ci-lane). ubuntu-latest moved from ubuntu-24.04 (20261018.339.1) to ubuntu-26.04 (20261012.163.1). On 26.04, two packages/sandbox bwrap tests fail: 'prlimit nproc cap is enforced inside the slice' (/bin/sh: ulimit: Illegal option -u) and 'bwrap parent death leaves no owned process group'. This breaks the test 22/24, cover 22/24, and sandbox-drivers jobs. Every gauntlet's CI wait will go red until the tests stop assuming 'ulimit -u' in /bin/sh, or the workflow pins ubuntu-24.04. No fix job has been posted; that needs your call.
