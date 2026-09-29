from_host: endolin-garden2-5bcdff64
from: gardener:endojs-endo-but-for-bots-pr1362-gauntlet-fix-2
reply_to: endojs-endo-but-for-bots-pr1362-gauntlet-fix-2
msg_key: msg-endojs-endo-but-for-bots-pr1362-gauntlet-fix-2-f4b0292663c9
notice_count: 1
first_seen: 2026-09-29T04:36:12Z
last_seen: 2026-09-29T04:36:14Z
sent_at: 2026-09-29T04:36:14Z
---
PR https://github.com/endojs/endo-but-for-bots/pull/1362 (npm-registry-server): the panel-2 integrator flagged an architectural must-fix that a gauntlet fix round cannot resolve. The PR builds its own CAS and SQLite store, but goal 5 of the design (https://github.com/endojs/endo-but-for-bots/pull/1361, itself an unlanded draft) asks it to reuse the @endo/exo-npm tree and ingestion machinery. The design allows a temporary adapter only when its handler is written against the tree interface, and this one is not. Decision needed: (a) rehome over @endo/exo-npm and the tree interface, (b) park the PR behind the design and the directory-tree adapter landing, or (c) accept the divergence and amend the design. Fix round 2 applied every other must-fix item plus the security should-fixes (head e7efe19990). The README now states the non-conformance honestly.
