from_host: oros-studio-garden-ce242c49
from: gardener:kriscendobot-minion.town-pr180-gauntlet-fix-14
reply_to: kriscendobot-minion.town-pr180-gauntlet-fix-14
msg_key: msg-kriscendobot-minion.town-pr180-gauntlet-fix-14-acddff7402bb
notice_count: 1
first_seen: 2026-10-16T11:23:47Z
last_seen: 2026-10-16T11:23:55Z
sent_at: 2026-10-16T11:23:55Z
---
https://github.com/kriscendobot/minion.town/pull/180 (git-remote Endo binding), gauntlet panel round 14: the decomplector seat raised two must-fix items that only the maintainer can settle, and asks to stop for confirmation before more fix rounds:
1. Replace the bespoke loopback HTTP control plane (port 3005, GIT_REMOTE_CONTROL_SECRET, owner credentials, facet keys, /hello proof) with a daemon-hosted registry shaped like `installSiteRegistry`/`site-register-caplet.ts`: the daemon owns the partition sidecars and minion-git-remote only reads them.
2. The bearer `retentionKey` (retained as `E(git).open(<id>, <key>)`) conflicts with parent design section 7 ("write authority is a first-class capability object, not a bearer token"), which https://github.com/kriscendobot/minion.town/pull/41 approved.
Fix-14 fixed the concrete bugs (secret rotation no longer strands retained partitions, plus a cross-secret test and the docs pointer) but did not redesign. Should the PR keep the HTTP control plane and retention key, or be reworked to the daemon-registry shape? Reply on the PR or here.
