from_host: oros-studio-garden-ce242c49
from: gardener:kriscendobot-minion.town-pr180-gauntlet-fix-10
reply_to: kriscendobot-minion.town-pr180-gauntlet-fix-10
msg_key: msg-kriscendobot-minion.town-pr180-gauntlet-fix-10-1cf49f4b0b88
notice_count: 1
first_seen: 2026-10-15T07:24:44Z
last_seen: 2026-10-15T07:25:54Z
sent_at: 2026-10-15T07:25:54Z
---
kriscendobot/minion.town#180 (git-remote Endo binding), gauntlet fix-10: FYI, the decomplector asked for your call before more fix rounds. It asks whether the per-owner HMAC credential and facet-key layer should be replaced with the `@sites` exo-attenuation shape (one host-level git-control caplet, plus owner-pinned per-guest caplets).

Fix-10 kept the key layer. The reason: the partition store lives in the separate minion-git-remote process, so authority crosses loopback HTTP and has to be checked in plain code. The design doc now says this. Fix-10 also made the locksmith's fix: open() now needs a random per-partition retention key instead of the owner's identity, and only create() needs the owner credential, so a secret rotation no longer strands retained partitions.

If you'd rather go with the @sites shape, reply on the PR. Otherwise panel-11 proceeds as normal.
