---
ts: 2026-06-16T20:54:12Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
worktree: dispatches/fixer--e9696a
refs:
  - entries/2026/06/16/204800Z-dispatch-fixer-e9696a.md
---

PR #435 inline r3423929733 (erights: "Please explain in this package's README.md the version thresholds for Hermes, Node.js, v8, JSC, SpiderMonkey, Chromium, Chrome, Safari, and Firefox"). Addressed.

## What landed

Commit `82b8fa90f` (`docs(immutable-arraybuffer): add version-threshold table for structuredClone / ArrayBuffer.transfer support per erights review`) on `build/immutable-arraybuffer-drop-the-pseudo-prototype`. Two files touched:

- `packages/immutable-arraybuffer/README.md`: new section *Platform support for `transferToImmutable`* with engine and runtime tables plus a *Feature-testing guidance* subsection. The Caveats list trimmed from a five-line inline summary to a one-line cross-link.
- `packages/immutable-arraybuffer/src/lib.js`: JSDoc above `optArrayBufferTransfer` (the comment erights pinned at line 83) now links to the README section instead of carrying the inline three-bullet list. The "Hermes, Node <= 16, some JSC" enumeration that triggered the original ask was the redundant block; it now lives in the README tables only.

Pre-push gates pass after `yarn install` (auto-fix paths applied two minor format/lint touches that re-staged silently; deterministic probes all pass).

## Version data per engine and runtime

### Engines

| Engine | structuredClone | ArrayBuffer.prototype.transfer | Verdict |
| --- | --- | --- | --- |
| V8 (Chromium) | 9.8 (Chrome 98, Feb 2022) | 11.4 (Chrome 114, May 2023) | both available |
| SpiderMonkey | Firefox 94 (Nov 2021) | Firefox 122 (Jan 2024) | both available |
| JavaScriptCore | Safari 15.4 (Mar 2022) | Safari 17.4 (Mar 2024) | both available |
| Hermes | not implemented | not implemented | deficient |

### Runtimes and browsers

| Target | structuredClone | ArrayBuffer.prototype.transfer | Path used |
| --- | --- | --- | --- |
| Node.js | 17.0.0 (Oct 2021) | 21.0.0 (Oct 2023) | preferred on Node 21+; structuredClone fallback on 17-20; deficient on <= 16 |
| Deno | 1.14 (Sep 2021) | 1.33 (May 2023) | preferred on Deno 1.33+ |
| Chrome / Edge | 98 (Feb 2022) | 114 (May 2023) | preferred on Chrome 114+; structuredClone fallback on 98-113 |
| Firefox | 94 (Nov 2021) | 122 (Jan 2024) | preferred on Firefox 122+; structuredClone fallback on 94-121 |
| Safari | 15.4 (Mar 2022) | 17.4 (Mar 2024) | preferred on Safari 17.4+; structuredClone fallback on 15.4-17.3 |
| React Native (Hermes) | not implemented | not implemented | deficient |

Node 22 (active LTS) and Node 24 (current) both take the preferred path. Node 18 and 20 reach the structured-clone fallback; both are past or near EOL.

## Dead-code verdict on the structuredClone fallback

The `else if (optStructuredClone)` branch in `src/lib.js` line 92 is **not dead code**. It is the live path for:

- Node.js 17 through 20 (still in the support window for Node 20 until April 2026; Node 18 EOL April 2025)
- Chrome / Edge 98 through 113 (Feb 2022 - May 2023)
- Firefox 94 through 121 (Nov 2021 - Jan 2024)
- Safari 15.4 through 17.3 (Mar 2022 - Feb 2024)

Each of those windows covers roughly two years of shipped browser versions that still satisfy this package's deployment baseline. The branch should remain.

The deficient bucket (where `optArrayBufferTransfer = undefined` and `transferToImmutable` is absent after shim install) is now narrow: React Native on Hermes and pre-Node-17 servers. The feature-test-required note in the README points at exactly those cases.

## Inline reply

Posted as comment `3423971932` in reply to `3418021461` (the parent of the ask, on `lib.js` line 83). URL: <https://github.com/endojs/endo-but-for-bots/pull/435#discussion_r3423971932>. Body cites the addressing SHA and links to the new README section.

## Next stage

Next recommended stage: **judge** (justice posture, summary-fix-eligible). erights's r3423929733 is the only unaddressed inline on this PR as of 20:54Z; the new section is small, scoped, and citation-anchored, so a code-panel re-run is likely to terminate cleanly. If the judge surfaces no further must-fix-loop dispositions, un-draft follows.

If the orchestrator chooses to wait for erights's follow-up review on this commit before re-judging, that is also reasonable: erights asked a specific question and the answer is now in the README. A reactji-acknowledgment or maintainer-side resolution on the thread would let the chain skip a panel cycle.

Self-improvement: nothing this time. The pre-push gates caught the format/lint drift silently after `yarn install`; the README section structure (two tables plus a feature-testing-guidance subsection) is small enough to live in one commit without changeset churn (no user-visible code surface changed). No new rule surfaced.
