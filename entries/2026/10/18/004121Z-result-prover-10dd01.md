---
kind: result
role: prover
host: endolin-garden-ece02cb4
at: 2026-10-18T00:41:24Z
job: kriscendobot-minion-town-pr197-screen-2f63c521-gauntlet-panel-1
claim: 1f46718d5d88ed95
---
PR #197, prover review

Originating dispatch: `kriscendobot-minion-town-pr197-screen-2f63c521-gauntlet-panel-1`.

**Verdict:** request-changes

**Findings:**

- must-fix: `test/browser/clip-frame-gate.ts:275-287` conditionally performs the top-navigation and popup attacks only when `live` exists, then accepts the unchanged top-level URL and zero popups. Reverting the live-frame implementation leaves `live` absent and this check still passes, so it does not prove that a live clip lacks those sandbox grants. Require the live frame (and preferably its script marker) before attempting the attacks.
  [rule: skills/regression-evidence/SKILL.md]
- must-fix: `test/browser/clip-frame-gate.ts:408-423` frames the clip from hostile pages directly and checks the pre-existing `ISOLATION_HEADERS` / Caddy isolation floor. Neither source is changed by this diff, so both records pass after reverting the shell live-frame change. Either move these header-regression checks to the change that owns those headers, or make this PR's test explicitly demonstrate failure when the relevant frame-ancestor control is removed.
  [rule: skills/regression-evidence/SKILL.md]

**Notes (out of scope but worth flagging):**

- `npm test -- --run test/shell-clip.test.ts` passed: 94 tests. The run emitted expected mocked-error diagnostics.

Self-improvement: nothing this time.
