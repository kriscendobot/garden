---
gate: orchestrated
orchestrated_by: endor-fixture-parity-ratchet-campaign-20260827
priority: normal
role: builder
posted_by: producer
posted_at: 2026-08-19T05:40:13Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build Increment 7 — host hooks & synthetic sources (Group F)

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

GATED: only proceed once endor's `run` entry point grows a host-hook surface
(exitModuleImportHook / moduleSourceHook). Then graduate exit and module-source-hook
by supplying the same hook to both the node oracle and the walker; bump floor to 32.
If the host-hook surface does not yet exist, report that precondition and hand back
rather than forcing it. error-handling stays a DurableExclude (negative-diagnostic
fixture). Depends on Increment 0.
