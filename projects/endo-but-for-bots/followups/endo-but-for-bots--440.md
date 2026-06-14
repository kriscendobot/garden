---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 440
upstream_mirror_repo: null
upstream_mirror_pr: null
created_at: 2026-06-14T09:50:00Z
last_appended_at: 2026-06-14T09:50:00Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#440

Created from the barrister code-panel verdict (23 seats, in-band fallback) on `feat(daemon,cli,chat): drop @info name hub for formula-inspector design (#439)` (branch `feat/formula-inspector`, base `llm`). The PR implements the merged formula-inspector design in three cuts: daemon host-only `getFormula(identifier)` (cut 1), `endo inspect` CLI verb (cut 2), and Value-modal Formula back face in `@endo/chat` (cut 3, four commits including 35 new unit + component tests and 6 Playwright e2e stubs marked `test.fixme`). Five deferrals warrant revisit when the PR merges.

## Items

- [ ] **e2e Playwright harness for the formula inspector.**
  **Source juror(s)**: prover, fast-checker.
  **Round**: 1.
  **Recommended action**: open a follow-up implementation PR landing `window.__testHarness` (the synthetic `EndoHost` + formula-fixture injection surface) so the 6 `test.fixme`'d cases in `packages/chat/test/e2e/formula-inspector.spec.ts` can drop the fixme markers and run live.
  The contracts the stubs encode (F flips, gear icon opens on back, keypair private-key suppression, Escape consistency, Backspace pop, focus management) are correct and load-bearing; the harness is what is missing.

- [ ] **Promise-formula streaming view.**
  **Source juror(s)**: integrator, scribe.
  **Round**: 1.
  **Recommended action**: open a follow-up implementation PR once `daemon-message-streaming.md` ships the streaming substrate.
  The current promise back face renders the static `store` reference only; the dynamic "View next value" affordance and the error-tracing "View trace" hook are stubs in the registry, flagged in the PR body's *Cut 3 Departures from design* section.

- [ ] **`pet-inspector` on-disk migration and `InspectorHubInterface` / `InspectorInterface` full removal.**
  **Source juror(s)**: archivist, releaser.
  **Round**: 1.
  **Recommended action**: open a follow-up PR (gated on a daemon-side data migration design) that retires the `pet-inspector` formula type, drops `EndoInspector` / `KnownEndoInspectors` from `packages/daemon/src/types.d.ts`, removes `makePetStoreInspector`, and removes the `inspectorId` allocation chain on the host formula.
  This PR intentionally defers the removal to keep the surface change focused; the `@deprecated` notes in `types.d.ts` (`f01499f1a`) name the removal target as no earlier than `@endo/daemon@4.0.0`.

- [ ] **Chat-package animation register.**
  **Source juror(s)**: ergonomist (cross-panel), stylist.
  **Round**: 1.
  **Recommended action**: once a chat-level animation register lands (CSS variable namespace + reduced-motion policy + per-component opt-in), refactor the card-flip animation in `packages/chat/index.css` (`--card-flip-duration`, `--card-flip-easing` at `:root` scope) to consume the register's variables.
  Flagged in the PR body's *Cut 3 Departures from design* section as the design's documented contingency.

- [ ] **JSON-mode pretty-print stability test on `endo inspect --json`.**
  **Source juror(s)**: scribe, copyeditor (cross-panel).
  **Round**: 1.
  **Recommended action**: open a follow-up implementation PR adding one stability test for `endo inspect counter --json` that pins the key order of the `FormulaRecord` JSON output (`type`, `number`, `properties`) so downstream scripts can parse via `jq` without ordering surprises across daemon revisions.
  Lightweight; the current `inspect-formula.js` demo asserts a regex match against specific substrings but does not pin shape stability.
