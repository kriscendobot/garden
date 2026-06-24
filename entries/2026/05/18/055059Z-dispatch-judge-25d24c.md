---
kind: dispatch
role: judge
host: endolinbot
posture: liaison
short_id: 25d24c
dispatch_root: dispatches/judge--25d24c
repo: endojs/endo-but-for-bots
branch: chore/drop-node-20-ci
pr_number: 280
slot: 2
panel: code
---

Judge stage for slot 2 (adopted PR #280, chore CI drop Node 18+20).
Steward shipped builder + fixer (cherry-picked endojs/endo#3084 commit
`010cc15fe`); CI 21/21 green on head `d652c2221`, mergeable CLEAN, 0
reviews. Next-stage-owed: judge. Two-file diff (~25 lines) of CI
matrix lanes — judge picks the code panel by file-list (config files
are source-touching surface) but the seat findings should be light.
