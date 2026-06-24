---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 101
upstream_mirror_repo: null
upstream_mirror_pr: null
created_at: 2026-05-21T07:53:54Z
last_appended_at: 2026-05-21T07:53:54Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#101

Created from the code-panel verdict (23 seats, in-band fallback) on the chat voice input PR (`feat/chat-voice-input`).
PR ships phase 1 (flat-text voice input via Web Speech API) of the four-phase `chat-voice-command-parser` design subsumed into the same branch.
Seven deferrals warrant revisit when the PR merges; one is design-doc-only and lands as an amendment to `designs/chat-voice-command-parser.md`, the rest are source-side work that lands on `packages/chat/`.

## Items

- [ ] **Name the swallowed `InvalidStateError` exception.**
  **Source juror(s)**: assessor.
  **Round**: 1.
  **Recommended action**: open a follow-up PR adding a leading comment at `packages/chat/voice-input.js:113` naming the `InvalidStateError` DOMException being swallowed by the catch block (the legitimate "recognition not started" race the design's phase-1 acknowledges).
  The bare catch reads as defensive without context; the comment names which DOMException class is the legitimate ignore and why.

- [ ] **Replace `(window).SpeechRecognition` `any` casts with a typedef.**
  **Source juror(s)**: typist.
  **Round**: 1.
  **Recommended action**: open a follow-up PR introducing a `SpeechRecognitionCtor` JSDoc typedef in `packages/chat/voice-input.js` so the four downstream `any` casts on the `(window).SpeechRecognition` constructor can drop.
  Web Speech API has no standard `lib.dom` typing; the typedef captures the shape locally so the rest of the module stays typed.

- [ ] **Double-destroy idempotency test.**
  **Source juror(s)**: prover.
  **Round**: 1.
  **Recommended action**: open a follow-up PR adding a `voice-input.test.js` case that calls `destroy()` twice and asserts the second call is a no-op (no throw, no second `stop()` on the recognition object).
  The current test file's chat-bar dispose wiring relies on idempotency implicitly; an explicit test pins the contract.

- [ ] **Phase-4 privacy doc.**
  **Source juror(s)**: archivist.
  **Round**: 1.
  **Recommended action**: when phase 4 of the design lands (`designs/chat-voice-command-parser.md` phase-4 cutover), amend the design to document which browser Web Speech implementations are on-device vs cloud-routed.
  Chromium's Web Speech API historically routes through Google's servers; Safari's WebKit implementation routes through Siri.
  The user-facing privacy posture differs and should be explicit in the design before phase 4 ships.

- [ ] **Adversarial phase-2 escape-semantics test.**
  **Source juror(s)**: saboteur.
  **Round**: 1.
  **Recommended action**: when phase 2 of the design lands (the parse-monad state machine), add an adversarial test for the `quote` escape semantics. The design's phase-2 specifies a `parseQuote` continuation that consumes tokens until a closing quote; the adversarial test exercises unbalanced quotes, quoted whitespace, and quote-in-quote sequences.
  Belongs on the phase-2 PR, not on this one.

- [ ] **Hostile-browser loop bound.**
  **Source juror(s)**: saboteur.
  **Round**: 1.
  **Recommended action**: open a follow-up PR adding `Math.min(results.length, 100)` (or a defensible constant) at `packages/chat/voice-input.js:142` so a hostile or runaway Web Speech implementation that emits an unbounded results array cannot pin the chat thread's main loop.
  The standard's `SpeechRecognitionResultList` is browser-controlled; defensive bounding is cheap and the constant is documentable.

- [ ] **Phase-4 cutover test plan in the design.**
  **Source juror(s)**: prover.
  **Round**: 1.
  **Recommended action**: amend `designs/chat-voice-command-parser.md` phase 4 to specify the cutover test plan: which phase-1 behaviors must still pass after the migration off the flat-text path, which new behaviors phase 4 adds, and what the rollback criterion is.
  Phase 4 is the migration of `voice-input.js` off the phase-1 flat-text path onto the parse-monad pipeline; a written cutover test plan reduces the risk of behavior regression at the cutover commit.
