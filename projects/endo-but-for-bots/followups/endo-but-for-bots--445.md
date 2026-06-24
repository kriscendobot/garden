---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 445
created_at: 2026-06-22T03:43:50Z
last_appended_at: 2026-06-22T03:43:50Z
status: parked
---

# Follow-ups for endo-but-for-bots#445

## Items

- [ ] `agent.js` — inbox recovery on `provideGuest` failure is implicit; add a comment documenting that "lazy revival on next UI access" is the intended recovery path.
  **Source juror(s)**: assessor
  **Round**: 1
  **Recommended action**: add an inline comment to `startAllInboxes` and to the `agents.delete(id)` + `throw` path in `getAgent`

- [ ] `providers/anthropic-streaming.js:26-32` — `id?` optional on `tool_calls` typedef has an implicit downstream invariant (synthesized id); document it inline.
  **Source juror(s)**: typist
  **Round**: 1
  **Recommended action**: add a one-line JSDoc comment on the `id?` field noting the missing-id synthesis path

- [ ] `floot-component.js` — capability-path resolution failures (wrong pet-name in profilePath) fail silently; surface as visible UI error state.
  **Source juror(s)**: integrator
  **Round**: 1
  **Recommended action**: add a try/catch around the factory-resolution flow and render an error message in the component root

- [ ] `ROADMAP.md` — add a link from `README.md` to `ROADMAP.md`.
  **Source juror(s)**: archivist
  **Round**: 1
  **Recommended action**: add a "## Roadmap" section at the end of README.md with a relative link to ROADMAP.md

- [ ] `package.json` — no `test` script; the STT load-test is manual.
  **Source juror(s)**: packager
  **Round**: 1
  **Recommended action**: add a lightweight `can-load` AVA test that imports the caplet module and verifies the `make` export is callable; no subprocess dependencies needed for this test

- [ ] Browser end-to-end (mic capture → transcript → reply → spoken audio with barge-in) is manually tested only.
  **Source juror(s)**: prover
  **Round**: 1
  **Recommended action**: track as a follow-up issue in the upstream repo after landing; link from ROADMAP.md

- [ ] `packages/fae/src/tool-makers.js` — if `@endo/fae` gains a public export for this module, a changeset entry is needed before upstream landing.
  **Source juror(s)**: changeset-auditor
  **Round**: 1
  **Recommended action**: verify whether tool-makers.js is exported in the package's `exports` field; add changeset if so before upstream PR

- [ ] `buffered-channel.js` — "concurrent consumers safe" comment overclaims; the single-consumer contract should be stated.
  **Source juror(s)**: saboteur
  **Round**: 1
  **Recommended action**: revise the comment to state "intended for single-consumer use; concurrent consumers would race on the cursor"

- [ ] `agent.js` `runTurn` — a failed provider call leaves a dangling user node in the conversation tree with no matching assistant response.
  **Source juror(s)**: breaker
  **Round**: 1
  **Recommended action**: track in ROADMAP.md; long-term fix is to either prune the dangling user node on failure or annotate it as a failed turn

- [ ] `SECURITY.md` — pre-publication document; needs org-level review before upstream landing.
  **Source juror(s)**: releaser
  **Round**: 1
  **Recommended action**: add a note at the top of SECURITY.md stating it is pre-publication and subject to update; verify with endojs security team before upstreaming
