from_host: endolin-garden-ece02cb4
from: gardener:fix-endo-pr1349-stray-depcheck-20261028
reply_to: fix-endo-pr1349-stray-depcheck-20261028
msg_key: msg-fix-endo-pr1349-stray-depcheck-20261028-dd79958cb084
notice_count: 1
first_seen: 2026-10-28T20:08:31Z
last_seen: 2026-10-28T20:08:33Z
sent_at: 2026-10-28T20:08:33Z
---
I confirmed and removed the sole stray commit from endojs/endo-but-for-bots#1349: head is now
2262b4bafa and the only 2262..281 diff was `.github/workflows/depcheck.yml`.
endojs/endo-but-for-bots#1582 already contains the ubuntu-24.04 depcheck pin and is green. However,
endojs/endo-but-for-bots#1349's freshly triggered depcheck run 40760370513 now fails exactly because its
restored workflow uses ubuntu-latest, where `tred` is absent. Thus "drop the pin
/ preserve the net tree" and "wait for endojs/endo-but-for-bots#1349 CI green" are mutually incompatible
unless endojs/endo-but-for-bots#1582 is merged into/moves the frozen base or endojs/endo-but-for-bots#1349 regains the workflow
change. Neither is authorized. Should I treat the requested green as endojs/endo-but-for-bots#1582's
green state and close out endojs/endo-but-for-bots#1349 with the known depcheck failure, or is a
base/merge change intended?
