---
kind: result
role: botanist
host: endolin-garden2-5bcdff64
at: 2026-07-28T07:35:53Z
---
---
project: endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/562
verdict: REJECT
---

# dependabotany ledger: endo-but-for-bots PR 562 (happy-dom 15.11.7 -> 20.10.6) -- REJECT, superseded

Terminal verdict, so **no ledger row is opened** and no recheck schedule is
placed. Recorded here for the project's dependabotany history.

**Disposition executed:** structured verdict comment posted
(https://github.com/endojs/endo-but-for-bots/pull/562#issuecomment-5101282899),
then `gh pr close`. Verified `state=CLOSED`, `closedAt=2026-07-28T07:35:04Z`.

**Why REJECT and not MERGE-NOW.** On the merits the bump is MERGE-NOW-class: the
review found nothing against it. The vehicle is what failed. PR 869
(https://github.com/endojs/endo-but-for-bots/pull/869, opened 2026-07-26) moves
the same dependency in the same three `package.json` files against the same `llm`
base to the newer 20.11.0, from a current base with a 2026-07-26 green CI run.
PR 562 had not been touched since 2026-06-28 and its head sat on
https://github.com/endojs/endo-but-for-bots/commit/a1dcc7071f, about a month
behind `llm`, so its green CI attested to a base shape that no longer exists.
Both cannot land; the stale duplicate closes.

**The substantive finding, which transfers to 869.** happy-dom 15.11.7, the
version in the tree today, carries three open advisories (OSV, queried
2026-07-28): GHSA-37j7-fg3j-429f CRITICAL, VM context escape to remote code
execution, range `>=0 <20.0.0`; GHSA-6q6h-j7hj-3r64 HIGH, `ECMAScriptModuleCompiler`
interpolating unsanitized export names as executable code, range
`>=15.10.0 <20.8.8`; GHSA-w4gp-fjgq-3q4g HIGH, fetch `credentials: include`
sending page-origin cookies to the target origin, range `>=0 <20.8.9`. Both
20.10.6 and 20.11.0 query clean. The CRITICAL one is cleared only by a 20.x major
bump, so nothing inside 15.x would have sufficed. Exposure is dev-only
(`direct:development` in `packages/chat`, `packages/markmdown`,
`packages/space-file-explorer`), which lowers urgency without removing it.

**Transitive set** (54 added, 18 removed): headline `happy-dom` 15.11.7 to
20.10.6 (published 2026-06-17, MIT unchanged); newly introduced
`@types/whatwg-mimetype@3.0.2`, `buffer-image-size@0.6.4`, `undici-types@8.3.0`;
new `@types/node@26.0.1` resolution for happy-dom's `>=20.0.0`; new major
`entities@7.0.1` with 4.x retained for other consumers; `webidl-conversions@7.0.0`
removed. `ws` does **not** move (happy-dom's `^8.21.0` merges into the existing
`ws@8.21.0`), and `@types/ws@8.18.1` was already present. No version is 24 hours
fresh (newest is `@types/node@26.0.1` at 34 days). No license change; all
permissive, `entities` already BSD-2-Clause at 4.x. Named call-out:
`buffer-image-size@0.6.4` was published 2018-03-01 and is still `latest`, so an
unmaintained eight-year-old package enters the tree, dev-only and advisory-free.
`yarn npm audit --all --recursive` on the head tree returned zero hits on any
package the PR moves; its 175 advisory lines are the pre-existing dev-toolchain
backlog (axios via nx, `@vitest/browser`, babel).

**Install and source read.** `YARN_ENABLE_SCRIPTS=false corepack yarn install
--immutable` exited 0 and the lockfile is immutable-consistent. happy-dom 20.10.6
has no `install`/`preinstall`/`postinstall` script and no `bin`. `child_process`
appears in exactly one file, `lib/fetch/SyncFetch.js`, at
`ChildProcess.execFileSync(process.argv[0], ['-e', script])`, the long-standing
synchronous-fetch design that re-invokes node itself. `eval` and `new Function`
appear only in `lib/window/GlobalWindow.js` and `lib/window/BrowserWindow.js`,
the `window.eval` surface a DOM implementation must expose. No telemetry egress.
Regression evidence for GHSA-6q6h-j7hj-3r64: the fix is readable, not merely
claimed, as `VALID_VARIABLE_NAME_REGEXP` gating in
`src/module/ECMAScriptModuleCompiler.ts` around the `exportName`/`importName`
handling.

**Local verification** (real execution, not inference): the three consumer suites
run against the head tree with 20.10.6 installed passed 857 tests with zero
failures (`packages/markmdown` 15, `packages/space-file-explorer` 80,
`packages/chat` 762). So the 15.x to 20.x major does not break the consumers.

**CI rollup correction worth carrying forward.** All 22 check-runs at head
`615608b6014cf56d3c7df8d650d25a87e7b85bbc` are `success`, but the legacy
commit-status rollup at the same SHA reports `state: pending` with
`total_count: 0`. That is vacuous: the repository posts no legacy commit statuses
at all, so check-runs are the only real signal. PR 869's head shows the identical
vacuous `pending`, confirming a repository-wide characteristic rather than a
per-PR defect. Any gate that reads `/commits/<sha>/status` instead of
`/commits/<sha>/check-runs` will stall forever on every PR in this repo.

**Open follow-up, not mine to close.** PR 869 is `MERGEABLE` and `CLEAN` with
fully green CI, but `reviewDecision` is empty and it carries no reviews, so the
conductor spine's maintainer-approval gate will refuse it
(`merge blocked: no maintainer approval`). The CRITICAL advisory therefore stays
unrepaired in the tree until a journal maintainer approves 869. The full
diligence above was handed to the gardener holding job
`endojs-endo-but-for-bots-pr869-dependabot` so it is not redone.
