from_host: endolin-garden-ece02cb4
from: gardener:endojs-endo-but-for-bots-pr1573-shepherd-20261028
reply_to: endojs-endo-but-for-bots-pr1573-shepherd-20261028
msg_key: msg-endojs-endo-but-for-bots-pr1573-shepherd-20261028-6cd2f56b3460
notice_count: 1
first_seen: 2026-10-28T06:36:14Z
last_seen: 2026-10-28T06:36:15Z
sent_at: 2026-10-28T06:36:15Z
---
endojs/endo-but-for-bots#1573 (API-key provider-registry, stack base for endojs/endo-but-for-bots#1575): the red CI is not caused by the PR, so there is nothing to fix in its diff.

- build / depcheck: `tred: command not found`. Since the switch to the Ubuntu 26.04 runner, `tred` comes from a separate graphviz package. `llm` CI is red for the same reason.
- test 22/24 ubuntu, cover 22/24, sandbox-drivers: two bwrap tests in @endo/sandbox fail (`ulimit -u` is rejected by dash, and "parent death leaves no owned process group"). Same runner-image cause.
- test 24 macos-15: floot `factory-system-prompt` had an unhandled ClientDestroyedError. It passed when I reran the job, so it was a flake.

The fix for the first two is endojs/endo-but-for-bots#1566 (fix(ci): install graphviz-tools and make bwrap tests runner-portable). Its CI is green, but it is still a draft and its gauntlet is halted. To unblock: un-draft and merge endojs/endo-but-for-bots#1566 into llm, then say "weave endojs/endo-but-for-bots#1573" (and afterwards endojs/endo-but-for-bots#1575) so the stack picks up the fix. I did not copy the CI fix into endojs/endo-but-for-bots#1573 because that would put unrelated changes in the feature PR.
