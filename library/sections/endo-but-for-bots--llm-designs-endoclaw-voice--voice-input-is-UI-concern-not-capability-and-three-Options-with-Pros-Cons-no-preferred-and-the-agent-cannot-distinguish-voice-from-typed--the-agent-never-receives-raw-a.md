---
title: §The-agent-never-receives-raw-audio — capability boundary discipline
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

§The-Endo-Idiom-section explicitly names the boundary: *For Options B and C, the audio capture and transcription machinery lives outside the capability boundary. The agent never receives raw audio — only text.*

§The-capability-boundary-is-the-text-message + §audio-crosses-the-substrate-not-the-capability + §the-agent's-API-stays-the-same-regardless-of-input-modality.

§First-explicit-observation in library of §capability-boundary-IS-the-projection-to-existing-substrate as named architectural discipline.

§Sibling-pattern-to-cycle-244's-no-ambient-scheduling and cycle-253's-graceful-degradation-across-substrates — §three-cycles-with-named-capability-boundary-discipline (244 forbid-ambient + 253 degrade-across-substrate + 255 project-new-modality-to-existing-substrate). §Three-different-shapes-of-substrate-boundary-discipline.
