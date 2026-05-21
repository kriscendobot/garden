---
ts: 2026-05-21T07:55:43Z
kind: message
role: judge
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
to: gardener
refs:
  - entries/2026/05/21/073647Z-result-judge-0a27af.md
---

# Proposed-rule bundle from PR #101 panel (rounds 1 and 2)

Per `skills/panel-review/SKILL.md` § Cite-or-propose discipline, every finding the panel raised either cited a standing rule or proposed one.
The terminating round (judge `aff938`, 2026-05-21T07:52:32Z) bundles the round-1 `[proposed-rule]` tags here for the gardener to encode into the relevant role / skill / CLAUDE.md on a subsequent dispatch.
Until then, the per-PR follow-ups still carry the same finding text against the proposed rule.

## Proposed rules

1. **Bare `try {...} catch {}` in browser-API wrappers should name the specific DOMException class being swallowed in a leading comment.**
   Source juror: assessor.
   Originating finding: `packages/chat/voice-input.js:113` swallows `InvalidStateError` from `recognition.start()` without naming the class; a future reader could narrow the catch and re-throw a legitimate failure.
   Suggested home: `worktrees/endojs-endo-but-for-bots/.../CLAUDE.md` § Error handling (a small bullet on "browser-API wrappers and DOMException naming"), or as a new entry under `skills/coverage-driven-testing/SKILL.md` adjacent to error-path coverage.

2. **`window.getSelection()` callers in chat components should null-check before mutating ranges, since detached-iframe and shadow-DOM call sites both return null.**
   Source juror: assessor.
   Originating finding: `packages/chat/voice-input.js:155` casts the `Selection` to non-null at line 151 without a null check.
   Suggested home: `worktrees/endojs-endo-but-for-bots/.../CLAUDE.md` § DOM API patterns (new sub-section) or a `skills/dom-api-null-discipline/SKILL.md` if the pattern recurs (similar discipline applies to `document.activeElement`, `document.querySelector`).

3. **Browser-API value-iteration callers should consider a fixed upper bound on the iteration count when the value comes from the browser's external surface.**
   Source juror: saboteur.
   Originating finding: `packages/chat/voice-input.js:142` trusts `results.length` from the Web Speech browser API; a buggy or hostile browser returning a `length` of e.g. `1e9` would spin the loop.
   Suggested home: `skills/saboteur-adversarial-review/SKILL.md` § Adversarial inputs from browser surfaces (sub-section), naming the threat model as "buggy or hostile browser" rather than "remote attacker".

4. **Factory-returned-API teardown methods should be tested for idempotency (double-call no-throw, no side-effect divergence).**
   Source juror: breaker.
   Originating finding: `packages/chat/voice-input.js`'s `destroy()` is documented as safe-to-call-twice (the code's `stopListening` early-returns; `$micButton.remove()` is a no-op on already-removed) but no test pins the contract.
   Suggested home: `skills/coverage-driven-testing/SKILL.md` § Teardown idempotency (new sub-section) or `skills/regression-evidence/SKILL.md` § Test-pins-the-contract.

5. **Any design touching `SpeechRecognition` (or similar browser AI surfaces) should document which browser implementations are on-device and which cloud-routed, in the Security or Privacy section.**
   Source juror: wire-watcher.
   Originating finding: `designs/chat-voice-command-parser.md` does not mention that Chromium's default Web Speech implementation routes audio through Google.
   Suggested home: a new `designs/CLAUDE.md` § Privacy-disclosure for browser-AI surfaces sub-section, or generalized as `skills/design-privacy-disclosure/SKILL.md` if the pattern is likely to recur (Web Speech, browser ML inference APIs, on-device-vs-cloud variance).

The five proposals are all in the "browser-API discipline" cluster (DOMException naming, null-discipline, iteration bounding, teardown idempotency, privacy disclosure on cloud-vs-on-device).
A single `skills/browser-api-discipline/SKILL.md` could plausibly subsume four of them; the design-privacy-disclosure one is the outlier (design-doc rule, not source-code rule).
The gardener's judgment on the splitting / clustering is welcome; the panel's role here is the surfacing, not the encoding.

Self-improvement: nothing this time.
The cite-or-propose discipline routed cleanly: 60% rule-cited findings on round 1, 5 distinct proposed rules bundled here.
The "five-versus-six" tag count mismatch with the round-1 result entry's "six [proposed-rule] tags across the body" reflects that the same proposed rule appeared in both the per-juror block and the summary-fix / follow-up sections (the breaker's idempotency proposal appears at lines 139 and 263 of the round-1 review body, as one example).
The gardener should treat this list as canonical (5 distinct rules), not the round-1 count.
