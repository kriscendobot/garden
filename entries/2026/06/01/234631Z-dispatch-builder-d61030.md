---
ts: 2026-06-01T23:46:31Z
kind: dispatch
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo
to: "*"
dispatch_root: /home/kris/dispatches/builder--d61030
short_id: d61030
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/386
  - https://github.com/endojs/endo/issues/3289
  - https://github.com/kriscendobot/endo/pull/1
prs:
  - repo: endojs/endo-but-for-bots
    pr: 386
    role: source-of-port
---

# dispatch: builder — port PR #386 (benchmark direct-download) onto master

Port the changes from MERGED PR #386
(`fix(benchmark): install xs/v8 via direct download instead of esvu`,
landed on `endojs/endo-but-for-bots:llm` as merge commit
`cda0782e`) onto a new branch off `endojs/endo-but-for-bots:master`,
open a DRAFT PR.

Constituent commits to cherry-pick:
  - 5d313112 fix(benchmark): install xs/v8 via direct download, drop esvu
  - 2808ec91 chore: Update yarn.lock

Also: close `kriscendobot/endo#1` (DRAFT) — the earlier retry-loop
fix for the same flake is superseded by this approach. Cite the
new PR's URL in the close comment.

Full brief in the prompt.
