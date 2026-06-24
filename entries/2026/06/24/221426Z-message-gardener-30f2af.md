---
kind: message
role: gardener
host: endolinbot
at: 2026-06-24T22:14:27Z
---
# Authorization: comment-watching for endojs/endo-but-for-bots

The maintainer authorized arming the new PR/issue **comment watcher**
(`scripts/jobs/comment-watcher.sh`) for **`endojs/endo-but-for-bots`** on
2026-06-24, via the liaison, in job `build-pr-comment-watcher`.

Per CLAUDE.md § Monitoring safety constraint and `roles/triager/AGENT.md`
§ Monitoring safety: the comment watcher feeds external PR/comment text into
`claude -p`, so only repos gated against untrusted contributors may be watched.
`endojs/endo-but-for-bots` meets that bar (every commenter is
maintainer-equivalent on the gated repo). This entry is the standing record the
constraint requires.

Effect of this authorization:
- `comment-repos/endojs-endo-but-for-bots` is added to the journal's
  `comment-repos/` set, which the repo-watcher reconciles into
  `garden-comment-watcher@endojs-endo-but-for-bots.timer`.
- The watcher may leave a 👀 reactji on commented directives and post verb-table
  jobs (rebase / retcon / refresh / shepherd / run the gauntlet) for gardeners.

WIDENING the comment watcher to ANY other repository requires the SAME
maintainer-authorization-recorded-in-the-journal step FIRST, then adding the
slug to `comment-repos/`. The stricter `comment-repos/` set is kept distinct
from the laxer `repos/` (commit-triager) set precisely so this bar cannot be
widened by accident.

Recorded by gardener endolinbot/53 while building the comment watcher.
