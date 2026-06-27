---
title: "endoclaw-voice — Voice input in the Chat UI via three substrate options"
source-slug: endo-but-for-bots--llm-designs-endoclaw-voice
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-voice.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-voice.md
total-lines: 69
status: Not Started (2026-03-03)
ingest-cycle: 255
ingest-date: 2026-06-10
lane: designs
---

# endoclaw-voice.md

A 69-line **Not Started** design for adding voice input to the Chat UI via three substrate options (Web Speech API + local Whisper + daemon-side transcription). Parent: endoclaw. Classified as a UI feature, not a capability — voice input does not grant the agent any new authority.

## Key design moves

- **§Voice-input-is-a-UI-concern-not-a-capability-concern** — the load-bearing classification.
- **§UI-vs-capability** as named-design-axis (first-explicit-observation in library).
- **§The agent cannot distinguish voice input from typed input** — capability-by-invariance.
- **§Three Options with Pros/Cons (no preferred)** — distinct from cycle 250's Options-Considered-with-preferred.
- **§The agent never receives raw audio — only text** as capability boundary discipline.
- **§Capability-boundary IS the projection to existing substrate**.
- **§Three explicitly named non-changes** (no new capabilities + no new formula types + no new daemon changes) as evidence of UI-only claim.
- **§Endo-Idiom section with two paragraphs** (no N-named-disciplines) — recurring section with varying shape.
- **§Explicit non-dependency in Depends-On** (recurring with cycle 253).

## Section files

- [§voice-input-is-UI-concern-not-capability + §three-Options-with-Pros-Cons-no-preferred + §the-agent-cannot-distinguish-voice-from-typed](../sections/endo-but-for-bots--llm-designs-endoclaw-voice--voice-input-is-UI-concern-not-capability-and-three-Options-with-Pros-Cons-no-preferred-and-the-agent-cannot-distinguish-voice-from-typed.md) — full 69-line design ingest.

## Ingest scope

Cycle 255 (designs-lane after cycle 254's chat-lane): full 69-line design ingest. §First-explicit-observation of four patterns: §UI-vs-capability as named-design-axis + §three-Options-with-Pros-Cons-no-preferred as distinct-from-Options-Considered-with-preferred + §capability-boundary-IS-the-projection-to-existing-substrate + §three-explicitly-named-non-changes-as-evidence-of-UI-only-claim.
