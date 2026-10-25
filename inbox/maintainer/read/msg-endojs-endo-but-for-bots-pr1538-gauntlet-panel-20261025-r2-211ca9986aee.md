from_host: endolin-garden-ece02cb4
from: gardener:endojs-endo-but-for-bots-pr1538-gauntlet-panel-20261025-r2
reply_to: endojs-endo-but-for-bots-pr1538-gauntlet-panel-20261025-r2
msg_key: msg-endojs-endo-but-for-bots-pr1538-gauntlet-panel-20261025-r2-211ca9986aee
notice_count: 1
first_seen: 2026-10-25T17:40:45Z
last_seen: 2026-10-25T17:40:47Z
sent_at: 2026-10-25T17:40:47Z
---
endojs/endo-but-for-bots#1538 (provideGitClone, head 1509ed043e): renewed panel review https://github.com/endojs/endo-but-for-bots/pull/1538#pullrequestreview-5644388916

Every must-fix from the prior round (review 5643260299) is resolved:
- the unbounded `await sandboxInitPid` in bwrap `killSliceNow`
- the "inside the destination" JSDoc
- the swallowed `catch {}` and the orphaned staging in `manager.js`
- the changeset not covering the widened exported types

One must-fix remains, and it is a design decision for you, not a fix (decomplector, category f, raised on repeated rounds):

Is a destination mount shared with CONCURRENT writers a supported `provideGitClone` target?

- If YES: the design should say so, citing your decision. The staging, move-without-replace, entry-identity, and restart-sweep mechanism stays, and the fix round only handles the should-fixes.
- If NO: drop that mechanism and use a simpler shape. Options include cloning in place and cleaning up on failure, the daemon holding the mount exclusively (it mints the mount), or a daemon-private directory that becomes the mount.

Main should-fixes, either way:
- the XS host fails only after the network clone (`renameNoReplace` throws there)
- the POSIX-only `renameNoReplace` has no Windows guard
- the origin-name restore is skipped when the store write partly applies
- `destMount`/`destPath` should be spelled out
- `@endo/floot` has no changeset
- unsquashed fixup! commits

I have not posted a fix round, because another hardening round is the pattern the decomplector flagged. Reply YES or NO (plus any constraints) and I'll route the fixer accordingly.
