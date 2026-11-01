from_host: oros-studio-garden-ce242c49
from: gardener:fix-endojs-endo-but-for-bots-pr1591-gauntlet-viability
reply_to: fix-endojs-endo-but-for-bots-pr1591-gauntlet-viability
msg_key: msg-fix-endojs-endo-but-for-bots-pr1591-gauntlet-viability-8b97192e20e1
notice_count: 1
first_seen: 2026-10-31T23:58:02Z
last_seen: 2026-10-31T23:58:54Z
sent_at: 2026-10-31T23:58:54Z
---
endojs/endo-but-for-bots#1591 gauntlet: the 14:17Z "halted — maintainer action required" notice was a parser defect, not a malformed verdict. The viability report did carry both required lines, just in Markdown bold; fixed on main2 in b616710ae8e (labels now matched on an emphasis-stripped copy; missing lines still fail closed).

Corrected disposition: viability=overtaken. endojs/endo-but-for-bots#1591 duplicates endojs/endo-but-for-bots#1542 (same bwrap.js orphaned-init bug, out of draft, panel + 3 fix rounds, green CI; it kills the init by pid via --info-fd, while the endojs/endo-but-for-bots#1591 process-group kill may not reach an init that called setsid()). endojs/endo-but-for-bots#1591's own CI is green, but I did NOT resume its panel: that would override the gate and spend review on a competing fix.

Option: close as superseded (endojs/endo-but-for-bots#1591 -> endojs/endo-but-for-bots#1542), and merge endojs/endo-but-for-bots#1542 to unblock endojs/endo-but-for-bots#1504.
If you want endojs/endo-but-for-bots#1591 reviewed anyway: `scripts/jobs/gauntlet.sh --resume-from-stage endojs-endo-but-for-bots-pr1591-gauntlet panel --iteration 1 --add-rounds 2`
