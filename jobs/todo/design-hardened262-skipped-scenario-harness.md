---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# design: wire the skipped @endo/hardened262 test262 scenarios (script-mode + Compartment axes)

Source: kriskowal question on endojs/endo-but-for-bots#1070
(https://github.com/endojs/endo-but-for-bots/pull/1070#issuecomment-5447955080)
— "Are we missing harness components to actually test all these cases where the
tests are skipped?"

Repo: endojs/endo-but-for-bots, branch `llm`, package `packages/hardened262`.

## Context (already established)

`packages/hardened262/scripts/test.js` expands every case into a cross product of
`agent × mode(sloppy|strict|module) × lockdown × compartment`. Today
`agentRunsScenario` (scripts/test.js) wires **only** `module` and
`lockdownModule`; every other scenario is generated, enumerated by `--list`, and
reported as an explicit `skip` (1595 skipped lines across the current baseline).
So the ~2 new cases in #1070 pass in `module`/`lockdownModule` and skip everywhere
else — as does the whole corpus.

The gap is **not uniform** — it differs by axis and agent:

1. **Compartment axis (all agents) — genuinely unbuilt.** No agent reads
   `test.compartment` to execute anything: neither `scripts/node-helper.js` nor
   `scripts/agents/xs.js` has a code path that evaluates the subject inside a
   `new Compartment(...)`. Needs a real new harness component (install harness
   includes as compartment globals/endowments; evaluate subject there; SES-shim
   Compartment on node, native Compartment on XS).

2. **sloppy / strict-script modes on `sesNode` — unbuilt.** `node-helper.js`
   executes the subject exclusively via `await import()`, and the package is
   `type: module`, so every subject loads with ES-module (hence strict) semantics.
   `sesNode` therefore has no *script* execution path; a "sloppy" scenario routed
   through it would silently run as a module. Needs a script-eval path (indirect
   `(0, eval)` of the subject source in global scope, honoring the injected strict
   pragma), parallel to how the xs agent already runs scripts.

3. **sloppy / strict-script modes on `xs` — component already exists; only the
   switch is off.** `agents/xs.js` passes `-m` only for `module`; sloppy runs as a
   bare script and strict runs the strict-pragma'd `contents` as a script. These
   skip solely because `agentRunsScenario` gates them — flip per-agent + regenerate
   baselines.

## Deliverable

A short design (bare-to-`main2` unless it carries open questions) that specifies:

- the Compartment execution component for both node and xs agents (endowment/global
  wiring, raw/includes/async handling parity with the existing script path);
- the `sesNode` script-eval path so sloppy/strict-script become faithful there;
- how `agentRunsScenario` should widen — per-agent vs. global — given that xs can
  already run sloppy/strict but sesNode cannot until (2) lands, so a global flip
  would mislabel module execution as sloppy on sesNode;
- the baseline-regeneration and review-evidence plan (the change is a baseline
  ratchet: many currently-`skipped` lines move to `passed`/`failed`, reviewable as
  line diffs);
- sequencing into buildable follow-ups.

Part of the test262 coverage ratchet (kriscendobot/garden issue #51).
