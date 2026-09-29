Dependabotany declaration-compatibility preflight routing:

The deterministic live-PR oracle proved the following runtime-engine conflict(s).
For each listed PR, do NOT run the lockfile/source/advisory/test chain unless
the live declarations no longer match the proof. Re-fetch the live PR head and
re-verify ONLY the named package version and declarations. If they still match,
render REJECT (incompatible) and, on a bot-owned repo, execute the close. If a
proof no longer holds, fall back to the full scheduled botanist review. Process
every other due ledger row using the ordinary schedule body below.

- PR: https://github.com/endojs/endo-but-for-bots/pull/1354
  Package: `vite` 6.4.2 -> 8.3.0
  Proof: `package.json` declares Node `^20.17.0 || >=22.9.0` (floor 20.17.0), but `vite` 8.3.0 requires Node `^20.19.0 || >=22.12.0`; the dependency excludes the project-supported floor.
- PR: https://github.com/endojs/endo-but-for-bots/pull/1351
  Package: `@changesets/cli` 2.31.0 -> 3.0.3
  Proof: `package.json` declares Node `^20.17.0 || >=22.9.0` (floor 20.17.0), but `@changesets/cli` 3.0.3 requires Node `^22.11 || ^24 || >=26`; the dependency excludes the project-supported floor.

---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Wear `roles/botanist/AGENT.md` and re-evaluate every due Dependabot embargo row for project `endo-but-for-bots` / repo `endojs/endo-but-for-bots`, executing each now-due verdict on this bot-owned repository. Recover the cumulative ledger with `grep -rl '^project: endo-but-for-bots$' journal/entries/ | xargs grep -il '^# *dependabotany'`; re-fetch live PR/base state and do not rely on stale rows.
