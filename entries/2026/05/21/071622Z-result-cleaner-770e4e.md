---
ts: 2026-05-21T07:16:22Z
kind: result
role: cleaner
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/cleaner--7ac0c5/project
---

# Cleaner pass for PR #101 (feat(chat): voice input via Web Speech API)

Cleaner step of the gauntlet on PR #101 per kriskowal's directive, after fixer 7ceafb subsumed PR #102 (voice command parser design) into #101. Combined PR scope: voice input via Web Speech API source (chat-bar-component.js wiring, voice-input.js module, index.css mic-button styles) plus the design document `designs/chat-voice-command-parser.md`. Branch `feat/chat-voice-input`; head before cleaner `fc363c2ee`, after cleaner `ae961b350`.

Note: PR #101 was already out of draft when the cleaner arrived (one prior review on file). The dispatch directive treated this as a fresh cleaner pass per the maintainer override per `roles/cleaner/AGENT.md` § When to enter this role. The cleaner does not un-draft regardless.

## Findings

- Baseline coverage on the two source files the PR touches in `packages/chat`: `voice-input.js` 0% statements / 0% branches / 0% functions / 0% lines (no test exercised it); `chat-bar-component.js` also 0% (no test imports it). The chat package has no prior tests for the wiring component; voice-input was a wholly new untested module.
- The chat package's test suite uses happy-dom via `test/helpers/dom-setup.js`. That helper hoists window primordials onto globalThis (Node, NodeFilter, KeyboardEvent, Event, HTMLElement, CustomEvent) so source modules that read bare globals work in the test env. `MutationObserver` was missing from the hoist; `voice-input.js` reads it as a bare global (`new MutationObserver(...)` at startListening time), which silently threw under the existing helper (chipObserver never got assigned; the subsequent `chipObserver.observe(...)` threw and propagated up through handleClick, leaving the listener half-attached). The cleaner added `MutationObserver` to the hoist and to the cleanup pair so future component tests that touch MutationObserver-using source modules work out of the box.
- No dead code was found in `voice-input.js`. The module's exports are reachable from `chat-bar-component.js` (which calls `makeVoiceInput` and routes the returned `destroy` through the chat-bar's dispose chain), and every internal helper (hasChips, startListening, stopListening, handleClick, the three recognition event listeners, destroy) is reached by at least one of the new tests.
- The only branch that remains uncovered after the pass is the defensive `if (isListening) return;` guard at the top of `startListening` (voice-input.js:95). It is unreachable through the public click-toggle API because handleClick routes to stopListening when isListening is true; the guard exists for the case where startListening is invoked while a previous start is already pending. The cleaner left it in place rather than delete it; per `skills/coverage-driven-testing/SKILL.md` § Threshold for dead, defensive guards that protect re-entrancy do not meet the four-criterion dead-code threshold.

## Commits

- `ae961b350` `test(chat): cover voice-input.js end to end (#101)`
  - Adds `packages/chat/test/component/voice-input.test.js` (562 insertions, 22 tests). Each test runs serial because they install/uninstall `window.SpeechRecognition` on the shared happy-dom window.
  - Tests cover: feature detection (SR, webkitSR, absent), mic-button construction and attributes, lang default and override, click-to-start / click-to-stop, result event writes transcript, savedContent prefix preservation, multi-fragment concatenation, result-ignored-before-listen, empty-results, end-event stops + dispatches input event, error-event stops, start() throw swallow, stop() throw swallow, second-click-after-end is fresh start, refuse-to-start when chips already present, drop-result-when-chips-present, MutationObserver-driven stop on mid-session chip insertion, destroy removes button + stops + safe-when-not-listening, redundant-stop after end is no-op.
  - Also hoists `MutationObserver` onto globalThis in `packages/chat/test/helpers/dom-setup.js` so the source's bare `MutationObserver` reference resolves in the test env (with matching cleanup). Six-line diff to the helper.

## Coverage delta

`voice-input.js`: **0% → 100%** statements, **0% → 100%** lines, **0% → 100%** functions, **0% → 96.77%** branches. Only the defensive re-entrancy guard at line 95 remains uncovered.

Whole chat-package test count went from 424 to 446 (+22 from this cleaner pass). All pass locally.

## Regression evidence

Mutation test confirms the new tests are load-bearing: mutating `if (!isListening || hasChips()) return;` (the result-event guard) to `if (false) return;` failed 2 tests (`result events are ignored before listening starts` and `a result that arrives while a chip is present is dropped`). Reverting restored green. Per `skills/regression-evidence/SKILL.md`, the test surface is genuinely pinning behavior the source claims.

## Lint

`yarn lint:eslint test/component/voice-input.test.js test/helpers/dom-setup.js voice-input.js` is clean (0 errors). The remaining package-wide lint output is pre-existing warnings unrelated to this PR.

## CI status

Pushed to `feat/chat-voice-input` at `ae961b350`. CI was still converging at result-write time; the cleaner armed a Monitor (task `bb4davqo1`) that waits for the matrix to drain. Prior HEAD `fc363c2ee` had four documented pre-existing infra reds: `zizmor` (workflow YAML lints unrelated to chat), `lint` (a `makeClient not found` import error in `disconnect-error-display.test.js` outside the chat package), `cover (20.x)` and `cover (24.x)` (same `makeClient` import error in the cover job). The cleaner's commit does not touch any of those surfaces, so the same four are expected to remain red.

## Judge-ready signal

The flow's next-stage-owed per `skills/pr-creation-flow/SKILL.md` § The next-stage-owed heuristic is the **judge**. The cleaner pushed coverage commits, CI is converging (with only the documented pre-existing reds expected), the PR is the post-subsume combined-scope head (voice input source + voice command parser design). The judge picks the code panel per `roles/judge/AGENT.md` § Panel-kind discrimination (the PR is source-touching: `packages/chat/*.js`, `packages/chat/*.css`, plus the design document; the file list is mixed, so the code panel applies and the design content rides as supplementary context).

Self-improvement: nothing this time. The MutationObserver-hoist gap in `dom-setup.js` was straightforward and self-evident once surfaced (the helper hoists many other window primordials); the fix lands as part of the same commit rather than warranting a structural lesson up to the gardener.
