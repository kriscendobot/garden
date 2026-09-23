---
title: "§The load-bearing claim: voice input is UI not capability"
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

§Voice-input-is-a-UI-concern-not-a-capability-concern. *This is a UI feature, not a capability — it does not grant the agent any new authority.*

§First-explicit-observation in library of §UI-vs-capability as named-design-axis. §When-a-feature-could-be-implemented-as-either-UI-or-capability, §the-feature's-classification-IS-the-design-decision + §UI-features-don't-grant-new-authority + §capability-features-do.

§The-agent-cannot-distinguish-voice-input-from-typed-input — §capability-by-invariance. §The-transcribed-text-enters-the-system-as-a-normal-message + §the-agent-just-sees-text. §When-a-new-input-modality-can-be-projected-to-an-existing-substrate-(text), §project-it-and-don't-give-the-agent-a-new-input-API.

§Sibling-pattern-to-cycle-248's-UI-only-no-daemon-API-changes — §three-cycles-with-UI-only-no-substrate-changes (248 drag-drop + 250 inventory-grouping + 255 voice-input). §The-UI-is-the-presentation-not-the-substrate.
