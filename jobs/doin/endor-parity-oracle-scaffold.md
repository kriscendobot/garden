---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-19T05:43:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build Increment 0 — parity oracle & scoreboard scaffold

Design: `designs/endor-fixture-parity-ratchet.md` (garden main2) — read it first;
it defines the ratchet mechanism, the emulate-vs-refactor decisions, and the
per-increment acceptance gates this child must satisfy.

Repo: endojs/endo-but-for-bots. Work against the PR head branch
`feat/endor-run-entry-point-deps` (or `llm` if it has landed). Manifest:
`rust/endo/tests/compartment_mapper_fixture_parity.rs`.

Local-build gotcha: endor needs the gitignored Moddable `xs/` sources and empty
`xsnap/src/*_bootstrap.js` / `ses_boot.js` stubs copied from a sibling worktree at
the same commit — never commit them. Fixtures stay under
`packages/compartment-mapper/test`; the top-level `test/fixtures` hoist is OUT OF
SCOPE. Graduation is atomic: land the capability + commit the node-reference golden
+ flip the fixtures Exclude->Exercise + bump the exercised floor in ONE change, and
keep the drift guard green.

Deliver the ratchet substrate every later increment consumes (§4 of the design):
- `rust/endo/tools/gen-parity-golden.mjs`: a harness-free node script that imports
  `@endo/compartment-mapper` directly and serializes a stable, structural
  compartment map (compartment ids, per-compartment module specifiers, parser
  language per module) to `fixtures-<name>/expected-compartment-map.json`.
- Upgrade the walker's exercised assertion from a compartment COUNT to a structural
  diff against the committed golden.
- Split `Exclude { reason }` into `PendingExclude { capability }` and
  `DurableExclude { reason }`; reclassify the seven durable excludes named in §3
  (retained, shortest-path, shortest-path-cycle, policy,
  strictly-inconsistent-directories, strictly-inconsistent-packages, noble) and
  error-handling.
- Add the ratcheting exercised FLOOR assertion (start at 7) and a scoreboard that
  prints `exercised / pending / durable`.
No fixtures graduate in this increment. Gate: suite green; golden regeneration
deterministic.

<!-- garden-reaped: 1 -->

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-19T05:53:19Z
