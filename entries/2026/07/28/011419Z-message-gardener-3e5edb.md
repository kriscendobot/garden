---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-28T01:14:21Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/868

# Dependabotany ledger: endojs/endo-but-for-bots -- PR #868 embargoed to 2026-08-02

Botany review of <https://github.com/endojs/endo-but-for-bots/pull/868>
(`chore: bump eslint-plugin-unicorn from 56.0.1 to 72.0.0`, base `llm`, head
`f8cf6acf688cff25033412355d2047609d2e9cc2`), run by job
`endojs-endo-but-for-bots-pr868-dependabot`, posted automatically by the
dependabot-PR watcher. Appends to the `endojs/endo-but-for-bots` dependabotany
ledger seeded at `entries/2026/05/13/000050Z-message-steward-e08492.md`.
Recover the cumulative posture with:

```sh
grep -rl '^project: endo-but-for-bots$' journal/entries/ | xargs grep -l '^# Dependabotany'
```

The ledger's open embargoed set was **empty** before this entry (drained
2026-07-01, `entries/2026/07/01/143843Z-message-botanist-5e2868.md`, which
retired the daily heartbeat). This entry reopens the set with one row and
re-creates the heartbeat idempotently.

## Open embargoed rows

| PR | Verdict | Maturity floor | Precise recheck | Base |
|---|---|---|---|---|
| [868](https://github.com/endojs/endo-but-for-bots/pull/868) | **EMBARGO-2026-08-02** | 2026-08-02T16:39:39Z | `dependabotany-recheck-endo-but-for-bots-pr868` at 2026-08-02T17:15:00Z | `llm` |

## Why the floor is 2026-08-02T16:39:39Z

Not the headline package. `eslint-plugin-unicorn@72.0.0` published
2026-07-14T23:13:47Z, so its own floor passed on 2026-07-21T23:13:47Z. The
floor is set by the freshest **moved transitive** version in the lockfile,
`globals@17.8.0` published 2026-07-26T16:39:39Z (3h 26m before the pull request
was opened), plus 7 days. `baseline-browser-mapping@2.11.4` (2026-07-26T15:10:43Z)
is nearly as fresh. Three more sit inside the window:
`@eslint/css-tree@4.0.5`, `electron-to-chromium@1.5.396`, `browserslist@4.28.7`.

## Second, independent bar to MERGE-NOW: red `lint`

The `lint` check fails with 7 real `unicorn/numeric-separators-style` errors
(2 in `packages/ocapn/test/codecs/passable.test.js`, 1 in
`packages/random/src/random.js`, 4 in `packages/random/test/random.test.js`).
Every other check passes, 21 of 22.

Root cause, confirmed by reading both rule sources: v56.0.1 grouped a float's
fractional part left-to-right at the configured `groupLength: 3`; v72.0.0 added
a separate `fractionGroupLength` option defaulting to `Infinity`, meaning no
fractional grouping at all, so every pre-existing fractional separator in the
repository is now an invalid group. The repository configures the rule at
`packages/eslint-plugin/src/configs/shared.js` around line 568 without setting
`fractionGroupLength`.

Escalated as fixer job `endojs-endo-but-for-bots-pr868-lint-fix`, which carries
the preferred one-line fix (add `fractionGroupLength: 3` to the `number`
options, restoring v56 behaviour and leaving all 7 literals as written) plus a
required changeset, because `eslint-plugin-unicorn` is a runtime `dependencies`
entry of the published `@endo/eslint-plugin@2.6.0` rather than a devDependency.

## Transitive set and clearance

27 versions moved: 13 packages newly introduced, 9 gained an additional entry
at a new version, 4 moved in place, 4 entries dropped. Every one of the 27 was
queried individually against <https://api.osv.dev/v1/query>: **zero
advisories**, none withdrawn or deprecated. Licenses permissive throughout
(MIT, Apache-2.0, ISC, BSD-2-Clause, CC0-1.0, CC-BY-4.0), no regression.

`quote-js-string@0.1.0` is a first-ever release; `identifier-regex@1.1.0` and
`is-identifier@1.1.0` are only three weeks old. All three, and in fact all 13
new packages, are `sindresorhus`-owned or ESLint-org-owned and consumed by
`eslint-plugin-unicorn` itself, so their appearance is explained by the upgrade.

Installed with scripts disabled
(`YARN_ENABLE_SCRIPTS=false yarn install --immutable --mode=skip-build`), which
completed clean. No `preinstall` / `install` / `postinstall` hook anywhere in
the moved set; the two `prepare` hooks (`web-worker`, `globals`) do not run for
registry tarballs. Source read of the headline package and all 13 new packages
found no `child_process`, no `node:http`/`node:https`, no `fetch` call site, no
filesystem write, no `eval` or `new Function`, and no credential-shaped
environment read. The only `fetch`/`XMLHttpRequest` strings in
`eslint-plugin-unicorn` are rule names and descriptions.

## Wiring

- Verdict comment: <https://github.com/endojs/endo-but-for-bots/pull/868#issuecomment-5098723542>
- Precise one-shot: `schedules/dependabotany-recheck-endo-but-for-bots-pr868.md`,
  fires once at 2026-08-02T17:15:00Z (floor ceiled to the hour plus a 15 minute
  epsilon) and self-deletes.
- Daily backstop: `schedules/dependabotany-recheck-endo-but-for-bots.md`,
  re-created since the set is no longer empty.
- Fixer job: `endojs-endo-but-for-bots-pr868-lint-fix`.

A terminal verdict on the recheck removes row 868 and, if the set is then
empty, the daily heartbeat may be retired again.
