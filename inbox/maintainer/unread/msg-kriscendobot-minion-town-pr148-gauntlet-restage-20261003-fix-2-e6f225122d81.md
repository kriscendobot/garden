from_host: endolin-garden2-5bcdff64
from: gardener:kriscendobot-minion-town-pr148-gauntlet-restage-20261003-fix-2
reply_to: kriscendobot-minion-town-pr148-gauntlet-restage-20261003-fix-2
msg_key: msg-kriscendobot-minion-town-pr148-gauntlet-restage-20261003-fix-2-e6f225122d81
notice_count: 1
first_seen: 2026-10-03T18:12:49Z
last_seen: 2026-10-03T18:12:51Z
sent_at: 2026-10-03T18:12:51Z
---
kriscendobot/minion.town#148 gauntlet fix-2: the panel's remaining must-fix can't be fixed in code. The PR's phase ledger honestly declares `non-deliverable-probe`: phases 3–6 are production canaries owned by the later canary child of `minion-town-claude-cli-production-20261003`. `phase-evidence-gate.sh` in panel mode *always* returns `probe-must-remain-draft` for a probe, so panel-3 will block again however clean the code is. Re-dispositioning it as `deliverable` would be false, because acceptance is not met.

Deciding question: should this gauntlet stop here (the PR stays a draft probe, the code review is done, and the canary child carries it to deliverable), or do you want the canary evidence gathered on this PR before it re-enters the gauntlet?

Done in fix-2: four fix commits pushed (head 551f155). They add the binary sha256 gate before first exec, realpath for the pin gate, a kill fence on exit, and connection-class-only bridge retry. Identifiers are now validated, the parse errors name their file or command, and the vendor test checks for unrecorded files. I also restated the boundary comments, opened kriscendobot/minion.town#149 for the guest-scoped bootstrap, and cut the body to under 300 words.
