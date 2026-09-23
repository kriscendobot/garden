---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-23T17:49:06Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Build the re-export deprecation policy automation (garden-internal)

Implement the automation specified in the now-APPROVED design
`designs/reexport-deprecation-policy-gauntlet.md` on `main2` (incorporated at
commit 7c712dafbef; @kriskowal resolved all 5 open questions in PR #95 — read
the `## Decisions (resolved 2026-09-23 by @kriskowal)` section as authoritative).

This is a GARDEN-INTERNAL build: the skill, probe, jury seat and role norms all
live in THIS repo. Per the garden's "No PR workflows for the garden's own repo"
convention, land the work DIRECTLY on `main2` (commit explicit pathspecs, push
with a rebase CAS loop) — do NOT open a garden PR and do NOT stage a gauntlet.

Build these artifacts, each obeying the Decisions:

1. `skills/re-export-deprecation-policy/SKILL.md` — the single policy home:
   the `export … from` forms, what a compliant `@deprecated` shim looks like,
   the exemptions, and the `reexport-policy-exempt` first-five-lines file marker.
   **Decision 4 (garden-universal + carry your own tooling):** the garden does
   NOT `npm install` or rebuild at run time, so this skill must BUNDLE/vendor the
   Babel parser (e.g. a self-contained `@babel/parser` UMD bundle checked into the
   skill dir) plus a small parse helper the probe/seat call. Solve the "how does
   the garden run Babel with no dependency fetch" gap here — that is the explicit
   assignment.

2. `scripts/jobs/gardening/pre-push-gates/probes/no-plain-reexport.sh` — the
   deterministic (no-LLM) author-time probe in the existing probe shape
   (`no-inline-import-jsdoc.sh`). **Decision 3 detector pipeline:** (a) cheap
   heuristic grep for `export` as a bare word on ADDED diff lines, gating (b) a
   Babel full-parse that takes the set difference of qualified re-exports
   (after − before) so only NEWLY-introduced qualified re-exports are flagged.
   Flag each new plain `export … from` not immediately preceded by a `@deprecated`
   JSDoc block (Decision 2). Honor the `reexport-policy-exempt` marker.
   **Decision 1:** barrels/`index.js` are NOT exempt — flag them too.
   **Decision 5:** SKIP type-only re-exports (`export type { … } from`,
   `export type * from`, `.d.ts` declaration files). Non-auto-fixable; FAILS the
   push gate. This same script is the seat's deterministic pre-pass.

3. `roles/jurors/reexport-auditor/AGENT.md` +
   `scripts/jobs/gardening/seat-gate-reexport-auditor.sh` — a cost-gated code-panel
   jury seat modelled EXACTLY on `seat-gate-orthographer.sh`: the gate runs the
   probe (stage a/b) as its pre-pass and spends a `claude -p` only when there is a
   candidate; the low-tier responder then FILES THE COMPLAINT for the jury
   (Decision 3 stage c) — adjudicating plain-vs-value-adding and deprecation
   adequacy. Add `reexport-auditor` to `GARDEN_CODE_SEATS` in `panel.sh`.

4. Author-facing norm lines in `roles/builder/AGENT.md`, `roles/fixer/AGENT.md`,
   and `roles/web-builder/AGENT.md` (provenance style, per the design), and a
   one-line pointer in `skills/pre-push-gates/SKILL.md`.

5. Tests per the design's `## Test plan`: probe unit fixtures (finding / clean
   deprecated shim / each `export … from` form / exempt marker / string-literal
   non-match / removed-line non-match / barrel flagged / type-only skipped) and a
   `seat-gate-reexport-auditor.sh` test driving the three gate branches with
   stubbed `claude`.

Definition of done: all artifacts land on `main2`, the probe and seat-gate tests
pass locally, and your report names the commit SHAs.

<!-- garden-reaped: 0 -->
