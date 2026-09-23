---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-09-20T20:12:35Z
---
# Dependabotany — endojs/endo-but-for-bots PR 1320

project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/1320

- Package: `execa` 9.6.1 → 10.0.1
- Head reviewed: `d2ec5257b7e6ac3533b4941e1c9c3e9a27c9c7a4`
- Verdict: REJECT (incompatible)
- Disposition: closed 2026-09-20T20:12:03Z
- Reason: the project supports Node `^20.17.0 || >=22.9.0`, while `execa` 10.0.1 requires Node `>=22`; the upgrade excludes the supported Node 20.17.0 floor.
- Review scope: declaration-only preflight, as the live declarations matched the watcher's terminal incompatibility proof. The full lockfile/source/advisory/test review was intentionally not run.
- Verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1320#issuecomment-5752361653

Terminal: no embargo row or recheck schedule is needed.
