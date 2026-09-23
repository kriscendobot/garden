---
ts: 2026-06-17T23:22:00Z
kind: result
role: barrister
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/06/17/232115Z-message-barrister-d0e483.md
---

## Barrister result: PR #452 — iroh heartbeat + Option A peer-formula revocation

**PR**: endojs/endo-but-for-bots#452
**Head**: b7d23855e (kriskowal-iroh-heartbeat)
**Panel kind**: code-panel
**Panel execution**: in-band-fallback (Agent tool not available in dispatch)
**Panel round**: 1 (first round; no prior verdict)

### Panel composition

All 26 code-panel seats fired plus 2 cross-panel design seats (copyeditor, pedant) triggered by `.claude/skills/endo/skill.md` markdown additions. Panel-hints output recorded verbatim in dispatch context.

Seats: assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober (always-on core 9); scribe, releaser (always-fire 2); benchmarker, breaker, changeset-auditor, curator, fast-checker, gateway, migrator, pruner, surfacer (path-triggered 9); engine-realist, locksmith, purist, spec-keeper, warden, wire-watcher (content-triggered 6); copyeditor, pedant (cross-panel 2).

### Verdict counts

- **must-fix-loop**: 2
- **summary-fix**: 3
- **follow-up**: 2
- **acknowledge**: 3
- **drop**: 0

### Must-fix items (for fixer brief)

1. `packages/daemon/src/networks/iroh-heartbeat.js` and `packages/daemon/src/networks/iroh.js`: `harden` is called but never imported. Add `import harden from '@endo/harden'` to both files. [rule: CLAUDE.md § harden() is mandatory]

2. `packages/daemon/src/networks/iroh-heartbeat.js: sendBeat()`: uses `connection.sendDatagram(...)` (property access at call time) instead of the destructured `sendDatagram` local. Change to `sendDatagram(new Uint8Array([0]))`. [rule: CLAUDE.md § Hardened JavaScript (SES) Conventions]

### Summary-fix items (post-fixer, single dispatch)

1. `iroh-heartbeat.test.js: 'emits heartbeat datagrams on the interval'`: change `delay(95)` to `delay(250)` for CI reliability.
2. `iroh-heartbeat.js: pump()` rejection handler: add `log('iroh heartbeat readDatagram ended')` to the empty rejection callback.
3. `iroh-heartbeat.js` module comment and `iroh-network-design.md`: replace `sec. 10.1` with `section 10.1`.

### Review URL

https://github.com/endojs/endo-but-for-bots/pull/452#pullrequestreview-2889793483

### Follow-up ledger

Created: `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--452.md`

Two items parked: (1) verify `readDatagram` rejects on QUIC connection close in the `@number0/iroh` binding; (2) injectable timer factories for deterministic testing.

### Proposed-rule message

Written to: `entries/2026/06/17/232115Z-message-barrister-d0e483.md` (addressed to gardener). Seven proposed rules.

### Recommended next stage

**next: fixer** (must-fix-loop = 2 > 0)

The fixer should address the two must-fix items. After the fixer's result lands, the orchestrator should dispatch the **justice** (not the barrister) for the re-run, briefed with this verdict and the fixer's response.

Self-improvement: The barrister should verify `harden` imports at the top of every diff review before running the full panel — the missing import is a recurring finding category that a pre-panel grep would catch deterministically. Propose adding a pre-panel grep step to the barrister's operating norm: `git diff $BASE...HEAD -U0 | grep -E '^\+.*harden\(' | while read line; do check import; done`.
