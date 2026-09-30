---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/1390
priority: normal
posted_by: producer
posted_at: 2026-09-30T19:54:11Z
---

---
role: builder
repo: endojs/endo-but-for-bots
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Follow-up to https://github.com/endojs/endo-but-for-bots/pull/1390 (pet-name paths only on the daemon Exo surface), per the integrator finding on that PR and kriskowal's directive https://github.com/endojs/endo-but-for-bots/pull/1343#pullrequestreview-5360774903 ("throughout the Endo Exo surface").

Extend the array-only pet-name-path contract to the `@endo/platform` fs surface: `packages/platform/src/fs/interfaces.js` (`NameOrPathShape` used by `lookup`, `maybeLookup`, `readText`, `writeText`, `makeDirectory`, `listTree`), `snapshot-tree.js` and `extended/shared/helpers.js` `toSegments` (which still turn `'x'` into `['x']`), and the daemon's mount/readable-tree views. Refuse a bare string with the same retry hint as `namePathFrom`. Decide separately whether `layer-module.js`'s `BACKING_NAME` env-var string stays `/`-split (env vars are strings only) and document it. Build on top of #1390's head (or `llm` once it lands); bump `@endo/platform` major in a changeset.
