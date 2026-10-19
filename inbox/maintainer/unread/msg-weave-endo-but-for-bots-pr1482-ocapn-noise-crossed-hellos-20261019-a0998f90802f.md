from_host: endolin-garden-ece02cb4
from: gardener:weave-endo-but-for-bots-pr1482-ocapn-noise-crossed-hellos-20261019
reply_to: weave-endo-but-for-bots-pr1482-ocapn-noise-crossed-hellos-20261019
msg_key: msg-weave-endo-but-for-bots-pr1482-ocapn-noise-crossed-hellos-20261019-a0998f90802f
notice_count: 1
first_seen: 2026-10-19T22:50:25Z
last_seen: 2026-10-19T22:50:27Z
sent_at: 2026-10-19T22:50:27Z
---
weave endojs/endo-but-for-bots#1482 (crossed-hellos) onto Rekey head bd4aa1f93: HALTED, nothing pushed. The PR, its head and its base are unchanged.

endojs/endo-but-for-bots#1482 is NOT just behind. The Rekey branch moved 14 commits past the endojs/endo-but-for-bots#1482 base (llm-frozen build/ocapn-noise-session-reconnect-rekey-4d8b59b). Commit 86271c3bbe ("accept a retried resume at the epoch just attached") and endojs/endo-but-for-bots#1482's straggler rule rewrite the same resume-acceptance block in network.js, and they contradict each other:

- Rekey: if a peer dials at epoch == attached, it is a retry after a lost reply, so ACCEPT it. Epochs below attached, or above attached+1, get a refusal. The test 'a lost resume reply is retried at the same epoch' expects both sides to end at epoch 1.
- endojs/endo-but-for-bots#1482: if a peer dials at epoch <= attached, it is a straggler (the losing half of crossed hellos), so DROP it silently. Epochs above attached are accepted as is.

At epoch == attached the two rules give opposite answers. Taking either one breaks the other PR's tests or behavior. Making both work needs a new protocol rule. For example: accept a same-epoch dial only when this side attached that epoch as the answerer and prefersOwnDial() is false. That is design work across two separately reviewed PRs, which a weave should not invent. 15 more endojs/endo-but-for-bots#1482 commits touch the same block. Smaller conflicts: suspend() and lastDialError in network.js, and the read-limit vs connect-delay hooks in _loss-injector.js.

Decision needed: (a) post a fixer job on endojs/endo-but-for-bots#1482 to compose the two rules (with the same-epoch-as-answerer distinction or similar), then re-weave; (b) endojs/endo-but-for-bots#1482's drop rule supersedes the Rekey retry fix (change/remove that Rekey test); or (c) leave endojs/endo-but-for-bots#1482 on its current pinned base until endojs/endo-but-for-bots#1481 merges.
