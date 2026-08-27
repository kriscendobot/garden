---
role: builder
tier: mentor
dispatch: automatic
token-budget: 300000
fallback-tier: minion
---
# Build Increment 2 — conditional & subpath exports/imports (Group C) — REPEAT-HALT RE-ATTEMPT

## Repeat-halt context (read first — press-driver investigation 2026-08-27)

This increment is `endor-walker-exports-resolution`, the compartment-mapper
fixture-parity ratchet child that HALTED the campaign TWICE
(`endor-fixture-parity-ratchet-campaign` ~2026-08-19 and
`endor-fixture-parity-ratchet-campaign-20260823`). Before re-attempting, a
press-driver investigated the two halts. **Finding: the halts were NOT a build
hang or a task-difficulty problem.** All four requeue cycles on 2026-08-23
failed with `outcome=requeue, source=none, elapsed_s=2..6` (see
`journal/usage/endor-walker-exports-resolution.jsonl`) — i.e. the worker
invocation fast-failed in 2–6s with **no model/provider attributed** (a
provider/worker-acquisition gap), which the reaper classified as
`elapsed-constancy` and requeued to doom. The doom notice itself says "raising
the handler budget will not help; read the handler log for the fast failure
cause." The build task never actually ran. This job is therefore posted
`dispatch: manual` at true `mentor` (no anthropic auto-downshift) so a live
real-provider worker (monk/cleric) serves it — the fleet is healthy now with
monks + clerics running.

**If you cannot even start real work** (an immediate infra/provider failure,
build environment cannot be set up, endor sources missing and unobtainable),
do NOT silently exit — report the concrete blocker to the maintainer inbox via
`message-user.sh` and in your completion report, so the third pattern is
captured rather than re-doomed blindly.

## The build (original increment spec)

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

Implement conditional/subpath `exports` and `#imports` resolution. Graduate
conditional-host-exports (EMULATE the `endo:lib` condition — supply the same
condition set to both the node oracle and the walker; do not refactor it away),
export-patterns, package-imports-exports, nested-pkg, and fixtures-0. Bump floor to
16. Depends on Increment 0.

On success, the 5 downstream ratchet children (dep-classification,
dynamic-import, nested-resolution, language-extensions, host-hooks) remain parked
under `orchestrated_by: endor-fixture-parity-ratchet-campaign-20260823`; a future
press dispatch re-orchestrates them once this blocker clears.
