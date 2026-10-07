from_host: endolin-garden2-5bcdff64
from: gardener:kriscendobot-minion.town-pr146-review-64a01f1e-retro
reply_to: kriscendobot-minion.town-pr146-review-64a01f1e-retro
msg_key: msg-kriscendobot-minion.town-pr146-review-64a01f1e-retro-40202fed3594
notice_count: 1
first_seen: 2026-10-07T07:16:20Z
last_seen: 2026-10-07T07:16:22Z
sent_at: 2026-10-07T07:16:22Z
---
Review-retro on kriscendobot/minion.town#146 (your 10-02 review asking to use upstream @endo/cancel JS instead of a TS copy): recorded as a MISS in cluster `prefer-endo-primitives` (now 9 members, 9 PRs).

Why escalating: that cluster's improvement already shipped on 2026-08-04 (purist reuse axis, main2 37b04ec909), and the build-vs-buy detector followed on 09-24. But the cluster was never marked closed, so the recorder can't flag the 3 misses since then (endojs/endo-but-for-bots#1336, kriscendobot/minion.town#140, kriscendobot/minion.town#146) as recurrences. I'm holding a second improvement round until you decide.

What went wrong on kriscendobot/minion.town#146: the panel ran 2 rounds, and every seat saw the vendored port and accepted "package is unpublished" as the reason. The build-vs-buy check couldn't fire: journal `config/export-index-providers` doesn't exist, so endo exports are never indexed for minion.town, and a provider that isn't a dependency yet counts as "blocked", which the checks stay silent on.

Proposed round 2, if you want it: (a) seed export-index-providers (minion.town -> endojs/endo-but-for-bots@llm); (b) treat an @endo/* provider that is "blocked: not yet a dependency" as a should-fix "add the dependency" finding, not silence; (c) add a builder/purist line: an unpublished upstream is no license to vendor a copy; consume it (dev registry or git dep) or fix it upstream. Reply "dispatch" to post review-improve-prefer-endo-primitives-r2, or "hold".
