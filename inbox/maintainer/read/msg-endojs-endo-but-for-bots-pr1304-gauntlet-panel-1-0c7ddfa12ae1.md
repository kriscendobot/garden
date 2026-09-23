from_host: oros-studio-garden-ce242c49
from: gardener:endojs-endo-but-for-bots-pr1304-gauntlet-panel-1
reply_to: endojs-endo-but-for-bots-pr1304-gauntlet-panel-1
msg_key: msg-endojs-endo-but-for-bots-pr1304-gauntlet-panel-1-0c7ddfa12ae1
notice_count: 1
first_seen: 2026-09-17T23:49:48Z
last_seen: 2026-09-17T23:49:52Z
sent_at: 2026-09-17T23:49:52Z
---
Panel round 1 for endojs/endo-but-for-bots#1304 ran cleanly and returned **must-fix** (16/31 seats requested changes), but the verdict could NOT be posted from this host (oros-studio-garden-ce242c49).

Blocker: the bot PAT (kriscendobot) here lacks Pull-requests write on endojs. `gh pr review`, `gh pr comment`, and even a reaction POST all return HTTP 403 "Resource not accessible by personal access token" (addPullRequestReview / addComment). Git push works; only the API write surface is denied. (Same host previously seen lacking checks:read.)

I am completing this stage as panel-error so the gauntlet driver re-posts the round under its bounded stage-retry budget — ideally landing on a host whose bot PAT has PR write. If oros-studio-garden-ce242c49 is the only/main host, the retries will exhaust; the durable fix is to grant the kriscendobot fine-grained PAT "Pull requests: read and write" on endojs (org approval may be required).

Verdict summary (so it is not lost) — must-fix items on endojs/endo-but-for-bots#1304 (feat(daemon): read-only directory attenuation, head 672ed33 vs base llm-387ea66):
- directory.js:761-770 readOnly() mints an eval formula with pin=undefined and never stores it under a pet name -> sweepUnreachable() collects it and its worker on next daemon restart, falsifying the changeset's "durable identity stable across restart" claim. Follow host.js:1478-1489 ephemeral-eval idiom.
- readOnly() passes specifiedWorkerId=undefined -> a fresh worker per call, no memoization -> unbounded worker leak on repeated calls.
- types.d.ts:1012 declares readOnly?() optional but interfaces.js:231-235 guards it unconditionally and all conformers/callers use it directly -> drop the ? or add .optional() to the guard.
- New shallow EndoDirectory.readOnly() collides in name with the recursive EndoMount.readOnly(); opposite recursion contracts, changeset never mentions the mount surface.
- types.d.ts:985 uses a Unicode ellipsis in doc prose -> ASCII '...'.
