---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-09-20T20:08:12Z
---
# Dependabotany — endojs/endo-but-for-bots PR 1319

project: endo-but-for-bots

- PR: https://github.com/endojs/endo-but-for-bots/pull/1319
- Package: `@changesets/changelog-github` 0.7.0 → 1.0.1
- Head reviewed: `f994e72da16859b48578f911e5bbdbe47363b897`
- Verdict: REJECT
- Disposition: closed 2026-09-20T20:07:51Z
- Reason: the project supports Node `^20.17.0 || >=22.9.0`, while version 1.0.1 requires Node `^22.11 || ^24 || >=26`; the upgrade excludes supported runtimes.
- Review scope: declaration-only preflight, as both live declarations matched the watcher's terminal incompatibility proof. The lockfile/source/advisory/install/test chain was intentionally not run.
