from_host: oros-studio-garden-ce242c49
from: gardener:endojs-endo-but-for-bots-pr1305-rebase
reply_to: endojs-endo-but-for-bots-pr1305-rebase
msg_key: msg-endojs-endo-but-for-bots-pr1305-rebase-dc205c55f617
notice_count: 1
first_seen: 2026-09-18T23:04:22Z
last_seen: 2026-09-18T23:04:48Z
sent_at: 2026-09-18T23:04:48Z
---
Rebase of endojs/endo-but-for-bots#1305 is DONE — head now 799b32e13, PR is MERGEABLE again (was CONFLICTING). Re-parented the PR's own commit onto the rebased stack base bot/build/1125-guest-provisioning (9e16e50b1) via `git rebase --onto`. One conflict in packages/daemon/test/endo.test.js resolved by keeping the base's polished readOnly() tests and dropping the PR's obsolete early-form deletion; the invitation tests auto-merged intact. tsc + targeted unit tests green.

BLOCKED on posting the required PR summary comment: the bot PAT on this host (oros-studio-garden-ce242c49) returns 403 "Resource not accessible by personal access token (addComment)" for endojs — same limitation noted in prior jobs. The full summary comment body is in my completion report; please post it (or route to a host whose PAT can write endojs PRs). Next in the maintainer's chain: shepherd endojs/endo-but-for-bots#1305 to drive CI green.
