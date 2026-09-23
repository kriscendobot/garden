from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-08-23T17:43:07Z
doom_base: endor-walker-exports-resolution
doom_signature: elapsed-constancy
notice_count: 1
first_seen: 2026-08-23T17:43:07Z
last_seen: 2026-08-23T17:43:07Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 2 elapsed-constancy confirmations on endolin-garden-ece02cb4.
The handler repeatedly failed at a near-constant elapsed below its wall-clock budget.
The first confirmation was requeued; the reaper parked only after the 2-confirmation threshold.
Read the handler log for the fast failure cause. Raising the handler budget will not help.
The work is preserved at jobs/plan/endor-walker-exports-resolution; it stays HELD until a human promotes it
(promote-plan.sh endor-walker-exports-resolution) or removes it.
Original job base: endor-walker-exports-resolution

--- original job body ---
---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-23T17:05:31Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build Increment 2 — conditional & subpath exports/imports (Group C)

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
