---
kind: message
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-28T07:27:53Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/561

# Dependabotany ledger: endojs/endo-but-for-bots -- PR 561 REJECT (superseded), closed

Botany review of <https://github.com/endojs/endo-but-for-bots/pull/561>
(`chore: bump eslint-plugin-unicorn from 56.0.1 to 72.0.0`, base `llm`, head
`1f9345e95290a7b09e7fe4ac98d9851ee0788b0d`), run by job
`endojs-endo-but-for-bots-pr561-dependabot`, posted automatically by the
dependabot-PR watcher. Appends to the `endojs/endo-but-for-bots` dependabotany
ledger. Recover the cumulative posture with:

```sh
grep -rl '^project: endo-but-for-bots$' journal/entries/ | xargs grep -l '^# Dependabotany'
```

## Verdict

**REJECT (superseded), executed: pull request CLOSED 2026-07-28T07:25:43Z.**

This is a **terminal** verdict, so it adds **no** open embargoed row, no
precise one-shot, and no daily-heartbeat obligation.

## Open embargoed rows after this entry

Unchanged from the preceding ledger entry
(`entries/2026/07/28/011419Z-message-gardener-3e5edb.md`): exactly one row.

| PR | Verdict | Maturity floor | Precise recheck | Base |
|---|---|---|---|---|
| <https://github.com/endojs/endo-but-for-bots/pull/868> | **EMBARGO-2026-08-02** | 2026-08-02T16:39:39Z | `dependabotany-recheck-endo-but-for-bots-pr868` at 2026-08-02T17:15:00Z | `llm` |

The daily backstop `schedules/dependabotany-recheck-endo-but-for-bots.md`
remains required (the set is non-empty). Nothing to retire.

## Why REJECT rather than EMBARGO

Pull request 561 is a **stale duplicate** of
<https://github.com/endojs/endo-but-for-bots/pull/868>, which the peer job
`endojs-endo-but-for-bots-pr868-dependabot` reviewed and embargoed six hours
earlier. Both bump `eslint-plugin-unicorn` 56.0.1 to 72.0.0 on base `llm`.

Dependabot opened 561 on 2026-06-28 targeting 68.0.0 (branch
`dependabot/npm_and_yarn/eslint-plugin-unicorn-68.0.0`), retitled and rebased
it to 72.0.0 on 2026-07-24, then on 2026-07-26 opened a fresh 868 on a
correctly-named `...-72.0.0` branch for the same bump **without closing 561**.
The stale branch name is what made the duplication easy to miss.

Evidence the two are the same upgrade: both diffs carry identical git blob
index lines on both changed manifests (`package.json` `c710f3dcf5` to
`430534c540`; `packages/eslint-plugin/package.json` `7b9b5b512c` to
`83adaf4ffa`), so the pre-image and post-image blobs are the same objects. The
lockfile diffs differ in exactly two entries, and 561 carries the **older**
resolution in both (`baseline-browser-mapping` 2.11.1 against 2.11.4;
`globals` folded onto the existing entry against a new `globals@17.8.0`).

561 is also 99 commits behind `llm` (`ahead=1 behind=99` against `llm` head
`7f8c08d74f`) with CI last run 2026-07-24. 868 is four weeks fresher.

Leaving both open would have cost a second full review and a second lint fix
for one dependency, and put two competing `yarn.lock` mutations for the same
package in front of the merge queue.

## Independent grounds that also blocked MERGE-NOW

Recorded because they matter if 868 is ever closed and 561 is reopened:

1. **`lint` red for a real reason.** Reproduced locally at head `1f9345e9`:
   `yarn lint` exits 1 with exactly 7 `unicorn/numeric-separators-style`
   errors, matching CI position for position:
   `packages/ocapn/test/codecs/passable.test.js` 317:27 and 327:27,
   `packages/random/src/random.js` 10:18, `packages/random/test/random.test.js`
   130:5, 130:31, 131:5, 131:31. Same root cause the 868 review found and
   confirmed here independently: v72 added `fractionGroupLength` defaulting to
   `Infinity` (no fractional grouping), where v56 grouped the fractional part
   at `groupLength: 3`, so every pre-existing fractional separator is now an
   invalid group. Rule configured at
   `packages/eslint-plugin/src/configs/shared.js:568` without
   `fractionGroupLength`. The fix belongs on 868 (job
   `endojs-endo-but-for-bots-pr868-lint-fix`), not here.
2. **Maturity window unsatisfied.** On its own merits 561 would have been
   EMBARGO-2026-07-31, floor set by `electron-to-chromium@1.5.396` published
   2026-07-24T02:02:49Z plus 7 days, not by the headline
   (`eslint-plugin-unicorn@72.0.0` published 2026-07-14T23:13:47Z, matured
   2026-07-21).

## Transitive set and clearance (561's own set, checked independently of 868)

26 resolutions added, 9 dropped. All 26 added versions queried individually
against <https://api.osv.dev/v1/query>: **zero advisories**, none withdrawn or
deprecated. Licenses permissive throughout (MIT, Apache-2.0, ISC,
BSD-2-Clause, CC0-1.0, CC-BY-4.0); no license regression.

Called out by the novelty rule: `quote-js-string@0.1.0` is a first-ever release
(package created 2026-07-02, one version); `identifier-regex@1.1.0` and
`is-identifier@1.1.0` are 23 days old with three versions each. All 13 newly
introduced packages are `sindresorhus`-owned or ESLint-org-owned direct
dependencies of `eslint-plugin-unicorn`, so their arrival is explained by the
upgrade. Nothing in the set was published within 24 hours of review.

Installed with scripts disabled
(`YARN_ENABLE_SCRIPTS=false corepack yarn install --immutable --mode=skip-build`),
exit 0; `--immutable` passing also confirms lockfile self-consistency. All 26
moved packages resolved in the install store and their scripts inspected: **no
`preinstall` / `install` / `postinstall` hook anywhere in the set**. One
`prepare` (`web-worker@1.5.0`, `tsup`) which does not run for registry
tarballs.

Source scan of all 26 for `child_process`, `node:http`/`node:https`, `fetch`,
`XMLHttpRequest`, `eval`, `new Function`, base64 decode, credential env reads,
and filesystem writes: 10 matches, every one explained (6 in
`eslint-plugin-unicorn` rule sources whose subject IS the matched primitive, 1
in a `caniuse-lite` browser-support data file, 1 in a `detect-indent` `.d.ts`
doc example, 2 in `web-worker` decoding a `data:` URL worker body). No network
call site, no process spawn, no filesystem write, no dynamic code construction.

`test (24.x, macos-15)` red was classified a **flake**, not a regression:
`@endo/familiar` reported 27 tests passed then `Exiting due to SIGINT` with
`Failed to exit when running test/encodePassable.test.js`, the known macos-15
hung-worker class. `test (22.x, macos-15)` passed on the same head, and
`eslint-plugin-unicorn` is not loaded at test runtime.

## Wiring

- Verdict comment: <https://github.com/endojs/endo-but-for-bots/pull/561#issuecomment-5101202862>
- Close: 2026-07-28T07:25:43Z, state CLOSED (verified via `gh pr view`).
- No schedule created or deleted by this entry.

## Sibling duplicates still open

The same 2026-06-28 against 2026-07-26 supersession affects two more pull
requests. Peers currently hold both jobs and have been messaged on the bus:

| Stale (2026-06-28) | Live (2026-07-26) | Dependency | Same target? |
|---|---|---|---|
| <https://github.com/endojs/endo-but-for-bots/pull/560> | <https://github.com/endojs/endo-but-for-bots/pull/870> | openai | yes, both 4.104.0 to 6.48.0 |
| <https://github.com/endojs/endo-but-for-bots/pull/562> | <https://github.com/endojs/endo-but-for-bots/pull/869> | happy-dom | no, 20.10.6 against 20.11.0 |
