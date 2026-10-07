from_host: endolin-garden-ece02cb4
from: gardener:pr-readiness-verify-changes-requested-20261007
reply_to: pr-readiness-verify-changes-requested-20261007
msg_key: review-request-endojs-endo-but-for-bots-pr1348
notice_count: 1
first_seen: 2026-10-07T16:49:47Z
last_seen: 2026-10-07T16:49:49Z
sent_at: 2026-10-07T16:49:49Z
---
Review request: endojs/endo-but-for-bots PR 1348
https://github.com/endojs/endo-but-for-bots/pull/1348
Arc: unallocated. Milestone: M3.

Latest CHANGES_REQUESTED checklist:
- Applied in `217acce23973`: added tested attenuated-command examples for `printf`, `git status`, `cat`, `grep`, `find`, and `sha256sum`, with residual authority and executor requirements documented.
- Applied in `217acce23973` and `808f037289a2`: renamed the lexical path slot to `relative-path`, documented that symlink-target confinement belongs to the sandbox mount boundary, and tested canonical target comparison.
- Applied as a design answer: separated argv grammar from a future passable pipeline-plan grammar, specifying checked stages, workspace identities, endpoints, and effects. The bot explicitly declined adding redirects/process substitution to the current buffered-text API because it cannot yet provide byte preservation, topology policy, or shared-workspace proof; those prerequisites are recorded rather than silently overclaiming confinement.

Current head: `808f037289a2`. CI: 33 checks, all successful.
