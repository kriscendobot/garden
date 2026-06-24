---
title: §Three-Options with Pros/Cons (no preferred)
source-slug: endo-but-for-bots--llm-designs-endoclaw-voice
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-voice.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-voice.md
total-lines: 69
ingest-cycle: 255
ingest-date: 2026-06-10
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-voice--voice-input-is-UI-concern-not-capability-and-three-Options-with-Pros-Cons-no-preferred-and-the-agent-cannot-distinguish-voice-from-typed
---

§Three-named-options each with a §Pros-line + §Cons-line. §No-preferred-option-named — the design lets the implementer choose based on the trade-offs.

- **Option A: Web Speech API (browser-native)** — Pros: zero deps + Chrome/Edge native + no server. Cons: requires internet + Chrome sends audio to Google + limited language support + no offline.
- **Option B: Local Whisper transcription** — Pros: fully offline + privacy-preserving + better accuracy. Cons: native binary or WASM + ~75MB model download + higher CPU.
- **Option C: Daemon-side transcription** — Pros: offloads compute from UI + works for remote/Docker. Cons: latency + requires daemon to bundle Whisper.

§Three-Options-with-Pros-Cons-no-preferred — §distinct-from-cycle-250's-Options-Considered-with-preferred (where one option was named preferred). §When-the-design-doesn't-prefer-one-option, §enumerate-them + §give-each-Pros-Cons + §the-implementer-chooses-based-on-deployment-context.

§First-explicit-observation in library of §three-Options-with-Pros-Cons-no-preferred as distinct-from-Options-Considered-with-preferred.

§Four-shapes-of-design-doc-alternatives-section in library now: §Alternatives-with-three-rejected (240) + §Alternatives-with-rejected+deferred (238) + §Options-with-preferred (250) + §three-Options-with-Pros-Cons-no-preferred (255). §Each-shape-IS-the-design's-stance-toward-the-options.

§Sibling-pattern-to-cycle-240's-two-viable-name-choices-with-Pro-Con (the verb-name choice for the read verb) — §two-cycles-with-Pros-Cons-without-named-preferred (240 + 255). §Different-counts-each-time (240 had two choices + 255 has three).
