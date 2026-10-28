from_host: endolin-garden-ece02cb4
from: gardener:endojs-endo-but-for-bots-pr1349-ferry-restage-20261028
reply_to: endojs-endo-but-for-bots-pr1349-ferry-restage-20261028
msg_key: msg-endojs-endo-but-for-bots-pr1349-ferry-restage-20261028-018bed2a350d
notice_count: 1
first_seen: 2026-10-28T05:03:03Z
last_seen: 2026-10-28T05:03:04Z
sent_at: 2026-10-28T05:03:04Z
---
I did not restage the ferry for endojs/endo-but-for-bots#1349. The directive `jobs/ferry/endojs-endo-but-for-bots-pr1349.md` still pins the old head `b122ff91ef` and is unchanged, so `scripts/ferry.sh` will refuse it (the head moved).

Where it stands:
- Gauntlet `endojs-endo-but-for-bots-pr1349-gauntlet-20261028-fe74338e` is complete. Panel round 2 decided "pass" at head `1e19cde89b`, which is the current head. CI is green there (15/15).
- That panel review (https://github.com/endojs/endo-but-for-bots/pull/1349#pullrequestreview-5677937470) still has an open integrator **must-fix**. endojs/endo-but-for-bots#1349 carries the XS lockdown-compartment commits that endojs/endo-but-for-bots#1425 also makes, and endojs/endo-but-for-bots#1425 is still an open draft with no review. The integrator wants that reconciled, or endojs/endo-but-for-bots#1349 put back into draft behind endojs/endo-but-for-bots#1425. Fix-1 rewrote the body to "Overlaps: endojs/endo-but-for-bots#1425; whichever lands second drops the duplicate", but the integrator still flags it. The restage job required this item to be closed.
- The `ci.yml` body claim (the other integrator item) is fixed.
- Also open, but not blocking: changeset-auditor request-changes on sentence-per-line in `.changeset/ses-xs-lockdown-compartment-intrinsics.md`, and should-fix items to autosquash the fixups and split the CI changes into their own PR.

Your call. Options:
(a) Accept the overlap. Say "restage the ferry for endojs/endo-but-for-bots#1349 at 1e19cde8" and a gardener will pin it.
(b) Drop the XS slice from endojs/endo-but-for-bots#1349 so endojs/endo-but-for-bots#1425 owns it, then re-gauntlet.
(c) Land endojs/endo-but-for-bots#1425 first, then weave endojs/endo-but-for-bots#1349.
