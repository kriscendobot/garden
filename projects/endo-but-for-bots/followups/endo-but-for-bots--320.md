---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 320
created_at: 2026-05-22T22:48:00Z
last_appended_at: 2026-05-22T22:48:00Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#320

Created from the barrister code-panel verdict (15 seats, in-band fallback) on `feat(familiar): consolidate daemon stop/purge via CapTP control helper (#231 G8)`. The PR consolidates `runEndoCommand(['stop'|'purge'])` onto a single CapTP-driven `daemon-control.cjs` helper. Three `follow-up` items deferred for revisit at merge time; the PR body's #231 G8 framing already lists "drop `endo-cli.cjs` from production runtime path" as a separate follow-up beyond this PR's scope.

## Items

- [ ] **No automated regression test for `daemon-control.js`'s verb-dispatch surface.**
  **Source juror(s)**: prover, corner-prober.
  **Round**: 1.
  **Recommended action**: open a follow-up test PR adding a unit test (under `packages/familiar/test/`) that exercises (a) bogus verb (`node packages/familiar/daemon-control.js bogus`) exits non-zero with stderr containing "unknown verb"; (b) missing verb exits non-zero. Deferred per PR body's G16 packaged-smoke deferral; the unit-level shape is cheap and would close the regression-evidence gap without waiting on G16.

- [ ] **No automated regression test for `runDaemonControl`'s timer-clear-on-settle (captures cleaner-12a8b9 fix).**
  **Source juror(s)**: prover, saboteur, corner-prober.
  **Round**: 1.
  **Recommended action**: open a follow-up test PR mocking `child_process.spawn`; after the mocked child closes with code 0, assert no stranded `setTimeout` handle keeps the event loop alive. Pins the timer-leak fix (commit b95d00637) as a regression guard so any future refactor of `runDaemonControl` cannot reintroduce the leak.

- [ ] **Reconcile `runDaemonControl('restart')` with the in-process JS `restartDaemon()` shape once `endo-cli.cjs` drops from production runtime path.**
  **Source juror(s)**: assessor.
  **Round**: 1.
  **Recommended action**: as part of #231 G8's deferred "drop `endo-cli.cjs` from production runtime path" PR, decide whether `restartDaemon()` on `daemon-manager.js:285` (in-process `stop` + `start`) should fold into `runDaemonControl('restart')` (subprocess delegation to `@endo/daemon`'s `restart` export). One restart surface per layer is the goal; today both exist and only the in-process one has a caller. Proposed-rule note in the panel body: "when a helper exposes a verb and the calling site has an in-process equivalent, document the divergence or fold one into the other".
