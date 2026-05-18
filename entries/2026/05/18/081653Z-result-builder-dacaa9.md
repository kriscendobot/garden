---
ts: 2026-05-18T08:16:53Z
kind: result
role: builder
repo: endojs/endo-but-for-bots
project: endo
worktree: dispatches/builder--dacaa9
---

PR opened: https://github.com/endojs/endo-but-for-bots/pull/286 (DRAFT, base `llm`, head `feat/cli-http-client-mk-phase-1`).

Implemented Phase 1 of `designs/cli-http-client.md`: the `endo http mk <controller-name> <client-name> --origin <url> ...` CLI verb, plus the daemon substrate it sits on (the `http-controller` and `http-client` formula types, the `EndoHost.makeHttpClient` mint, the paired controller + client exo surface, and the policy-gated `request()` method).
The design's metadata flipped from `Proposed` to `In Progress`; a new `## Status` section near the top of the design enumerates what Phase 1 lands and what is explicitly deferred (the `allow` / `deny` / `revoke` / `inspect` verbs to Phase 2, the rate / size / timing guards plus per-request cancellation to Phase 3, methods beyond GET-class plus response streaming to Phase 4, the trust-on-first-bind policy mode to its own addendum).

All three pre-flight gates passed: the open-PR slug search returned no current implementation PR (PR #144 is closed, PR #163 is design-only merged), the design's Status field was `Proposed`, and a fresh grep across `packages/cli/src/` and `packages/daemon/src/` for the candidate symbols confirmed the contractor's audit finding that the substrate is unshipped.

Affected files (17 total, +1232 / -9):

- `designs/cli-http-client.md` — status flip + new Status section listing Phase 1 deliverables and Phase 2-4 deferrals.
- `designs/README.md` — summary table row sync (status + updated date + Phase 1 annotation).
- `packages/daemon/src/formula-type.js` and `test/formula-type.test.js` — add `http-controller` and `http-client` to the registered-types set.
- `packages/daemon/src/types.d.ts` — formula types, deferred-task params, `EndoHost.makeHttpClient`, `DaemonCore.formulateHttpClient`, `FormulaValueTypes` entries for the two exo surfaces.
- `packages/daemon/src/interfaces.js` — `HttpControllerInterface` (`inspect`, `help`) and `HttpClientInterface` (`request`, `allowedOrigins`, `help`); host-interface row for `makeHttpClient`.
- `packages/daemon/src/http-client.js` (new) — `parseAllowedOrigin` / `parseAllowedOrigins` (URL parse + http(s)-scheme filter + dedup), `makeHttpController` (immutable allowlist), `makeHttpClient` (policy-gated request through `redirect: 'manual'`).
- `packages/daemon/src/daemon.js` — formula-maker cases for both types, `formulateHttpClient` (allocates two formula numbers, persists controller first then client, runs deferred pet-store tasks under the formula-graph lock), wiring into `makeHostMaker`.
- `packages/daemon/src/host.js` — `makeHttpClientCmd` (validates pet names, registers both, calls `formulateHttpClient`).
- `packages/daemon/src/help.md` and `src/help-text-data.js` — `EndoHttpController` and `EndoHttpClient` help sections (markdown source plus the auto-generated data file).
- `packages/cli/src/endo.js` — `http` parent subcommand and `http mk` action; added to the grouped help under a new "Network" section.
- `packages/cli/src/commands/http-mk.js` (new) — thin wrapper that calls `E(agent).makeHttpClient(...)`.
- `packages/daemon/test/http-client-unit.test.js` (new, 9 tests) — origin parsing, scheme filter, dedup, the controller-bears-policy invariant, a fetch-spy regression demonstrating the policy gate stops fetch from running for disallowed origins.
- `packages/daemon/test/http-client.test.js` (new, 9 tests) — end-to-end through a real local HTTP server: mk registers both pet names, controller / client invariant (method-name disjointness), allowed-origin success with header + body round-trip, disallowed-origin rejection, configuration-time validation, empty-allowlist + same-name rejections.
- `packages/cli/test/http-mk-command.test.js` (new, 4 tests) — `--help` surfaces, end-to-end `endo http mk` registers both pet names visible in `endo list`.
- `.changeset/cli-http-mk-phase-1.md` — `@endo/daemon` minor, `@endo/cli` minor.

Tests: 14 new tests added, all 14 + the regression-adjacent suites I re-ran (`formula-type.test.js`, `help-text.test.js`, `helpdown.test.js`, `graph.test.js`, `graph-refcount.test.js`, plus the `mount external directory` family on `endo.test.js`) pass.
`yarn lint:eslint` on both packages: 0 errors (warnings are pre-existing).
`yarn lint:types` on both packages: 0 errors (the `@libp2p/utils/src/adaptive-timeout.js` import error in `node_modules/@libp2p/kad-dht` is pre-existing on `llm` HEAD, verified by stashing my changes).

CI status at PR-open time: no checks reported on the branch yet (GitHub Actions typically takes a few minutes to enqueue after the push); the PR is correctly in DRAFT state against `llm`.

Self-improvement: the helpdown generator (`packages/daemon/scripts/generate-help-text-data.mjs`) emits its output without Prettier formatting, so the diff against an existing data file looks much larger than the actual content delta until the file is run through `yarn run prettier --write`.
The first time I ran the generator the diff stat was +147 / -245; after Prettier the diff was +21 / -2.
Worth a row on a builder-side gotchas page (`skills/pre-pr-checklist/SKILL.md` § Common churn?) that says: when help.md changes, run the generator then run Prettier before staging.
I will route this as a `message` entry to liaison rather than landing the skill change myself (the dispatch root's `garden/` is detached).
