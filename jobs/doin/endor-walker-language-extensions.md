---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-27T09:01:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build Increment 6 — language-for-extension & non-JS assets (Group E)

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

Add a language-for-extension config and asset parser surface. Graduate assets and
language-for-extension, running the node oracle with the matching parser
registration (EMULATE — the asset IS the fixture; do not refactor it out). Bump
floor to 30. Depends on Increment 0.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-27T09:01:09Z
