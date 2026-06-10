---
title: "designs/endoclaw-voice.md — voice input is UI concern not capability + three Options with Pros/Cons (no preferred) + the agent cannot distinguish voice from typed"
source-slug: endo-but-for-bots--llm-designs-endoclaw-voice
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-voice.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-voice.md
total-lines: 69
ingest-cycle: 255
ingest-date: 2026-06-10
lane: designs
---

# Voice input is UI concern not capability + three Options with Pros/Cons (no preferred) + the agent cannot distinguish voice from typed

A §69-line **Not Started** design (Created 2026-03-03; Updated 2026-03-03). Parent: [endoclaw](endoclaw.md). Adds voice input to the Chat UI via three substrate options.

## §The load-bearing claim: voice input is UI not capability

§Voice-input-is-a-UI-concern-not-a-capability-concern. *This is a UI feature, not a capability — it does not grant the agent any new authority.*

§First-explicit-observation in library of §UI-vs-capability as named-design-axis. §When-a-feature-could-be-implemented-as-either-UI-or-capability, §the-feature's-classification-IS-the-design-decision + §UI-features-don't-grant-new-authority + §capability-features-do.

§The-agent-cannot-distinguish-voice-input-from-typed-input — §capability-by-invariance. §The-transcribed-text-enters-the-system-as-a-normal-message + §the-agent-just-sees-text. §When-a-new-input-modality-can-be-projected-to-an-existing-substrate-(text), §project-it-and-don't-give-the-agent-a-new-input-API.

§Sibling-pattern-to-cycle-248's-UI-only-no-daemon-API-changes — §three-cycles-with-UI-only-no-substrate-changes (248 drag-drop + 250 inventory-grouping + 255 voice-input). §The-UI-is-the-presentation-not-the-substrate.

## §Three-Options with Pros/Cons (no preferred)

§Three-named-options each with a §Pros-line + §Cons-line. §No-preferred-option-named — the design lets the implementer choose based on the trade-offs.

- **Option A: Web Speech API (browser-native)** — Pros: zero deps + Chrome/Edge native + no server. Cons: requires internet + Chrome sends audio to Google + limited language support + no offline.
- **Option B: Local Whisper transcription** — Pros: fully offline + privacy-preserving + better accuracy. Cons: native binary or WASM + ~75MB model download + higher CPU.
- **Option C: Daemon-side transcription** — Pros: offloads compute from UI + works for remote/Docker. Cons: latency + requires daemon to bundle Whisper.

§Three-Options-with-Pros-Cons-no-preferred — §distinct-from-cycle-250's-Options-Considered-with-preferred (where one option was named preferred). §When-the-design-doesn't-prefer-one-option, §enumerate-them + §give-each-Pros-Cons + §the-implementer-chooses-based-on-deployment-context.

§First-explicit-observation in library of §three-Options-with-Pros-Cons-no-preferred as distinct-from-Options-Considered-with-preferred.

§Four-shapes-of-design-doc-alternatives-section in library now: §Alternatives-with-three-rejected (240) + §Alternatives-with-rejected+deferred (238) + §Options-with-preferred (250) + §three-Options-with-Pros-Cons-no-preferred (255). §Each-shape-IS-the-design's-stance-toward-the-options.

§Sibling-pattern-to-cycle-240's-two-viable-name-choices-with-Pro-Con (the verb-name choice for the read verb) — §two-cycles-with-Pros-Cons-without-named-preferred (240 + 255). §Different-counts-each-time (240 had two choices + 255 has three).

## §Each option has its own privacy/network/CPU profile

§The-three-options-trade-off-on-three-named-axes: §privacy (whether-audio-leaves-the-machine) + §network (whether-internet-is-required) + §CPU/memory (whether-the-model-runs-locally). §Each-axis-is-implicit-in-the-Pros-and-Cons + §the-axes-aren't-tabulated-but-the-reader-can-reconstruct-them.

§Implicit-vs-explicit-axes-in-Pros-Cons-text — §when-the-Pros-Cons-text-implies-axes-but-doesn't-name-them, §the-reader-must-reconstruct + §a-tabulated-axis-table-would-make-the-comparison-more-rigorous. §This-design-chose-Pros-Cons-prose-not-axis-table.

§Sibling-pattern-to-cycle-248's-Considerations-sections — §two-different-shapes-of-axis-enumeration-in-the-chat-UI-cluster: §cycle-248 five-Considerations-sections + §cycle-255 Pros-Cons-prose-per-option. §The-author-uses-different-shapes-for-different-design-densities.

## §The-agent-never-receives-raw-audio — capability boundary discipline

§The-Endo-Idiom-section explicitly names the boundary: *For Options B and C, the audio capture and transcription machinery lives outside the capability boundary. The agent never receives raw audio — only text.*

§The-capability-boundary-is-the-text-message + §audio-crosses-the-substrate-not-the-capability + §the-agent's-API-stays-the-same-regardless-of-input-modality.

§First-explicit-observation in library of §capability-boundary-IS-the-projection-to-existing-substrate as named architectural discipline.

§Sibling-pattern-to-cycle-244's-no-ambient-scheduling and cycle-253's-graceful-degradation-across-substrates — §three-cycles-with-named-capability-boundary-discipline (244 forbid-ambient + 253 degrade-across-substrate + 255 project-new-modality-to-existing-substrate). §Three-different-shapes-of-substrate-boundary-discipline.

## §No-new-capabilities-formula-types-or-daemon-changes-needed-for-Option-A

§The-Endo-Idiom-paragraph: *No new capabilities, formula types, or daemon changes are needed for Option A.* §Three-explicitly-named-non-changes (no new capabilities + no new formula types + no new daemon changes).

§Three-named-non-changes-IS-the-evidence-of-the-UI-only-claim. §When-a-design-claims-to-be-UI-only, §enumerate-the-substrate-elements-that-don't-change + §the-enumeration-IS-the-evidence.

§Thirteen-cycles-on-no-new-abstractions discipline now (211 + 214 + 222 + 232 + 236 + 238 + 240 + 242 + 244 + 246 + 248 + 250 + 255). §Three-cycles-with-explicit-list-of-substrate-elements-that-don't-change (248 + 250 + 255).

§First-explicit-observation in library of §three-explicitly-named-non-changes-as-evidence-of-UI-only-claim.

## §The Endo Idiom section distinguishes UI from capability

§The-Endo-Idiom-section has two paragraphs:

1. §First-paragraph: *Voice input is a UI concern, not a capability concern. The transcribed text enters the system as a normal message — the agent cannot distinguish voice input from typed input. No new capabilities, formula types, or daemon changes are needed for Option A.*
2. §Second-paragraph: *For Options B and C, the audio capture and transcription machinery lives outside the capability boundary. The agent never receives raw audio — only text.*

§Two-paragraphs-instead-of-N-named-disciplines — §the-Endo-Idiom-section's-shape-IS-not-padded-to-named-disciplines. §Three-cycles-with-Endo-Idiom-section-with-N-named-disciplines (232 five-disciplines + 246 four-disciplines + 255 two-paragraphs-no-discipline-headings). §The-shape-varies-with-the-design's-complexity-and-the-author's-judgment.

## §Standalone — no other EndoClaw designs required

§The-Depends-On-section: four-bullet-list with §the-fourth-bullet-as-explicit-non-dependency: *No other EndoClaw designs required*.

§Two-cycles-with-explicit-non-dependency-in-Depends-On (253 *No other designs required; standalone capability* + 255 *No other EndoClaw designs required*). §When-a-cluster-member-doesn't-depend-on-other-cluster-members, §explicitly-say-so + §the-explicit-non-dependency-IS-the-completeness-signal.

§The-three-substrate-dependencies-are-conditional-on-option-choice: §Chat UI for A + §Familiar Electron for B + §daemon worker for C. §Conditional-dependencies-IS-an-honest-record — different options have different dep profiles.

## §Borrowable patterns

**Tier-1 (highest borrowing value):**

- §Voice-input-is-a-UI-concern-not-a-capability-concern — the load-bearing classification.
- §UI-vs-capability as named-design-axis (first-explicit-observation in library).
- §The-agent-cannot-distinguish-voice-input-from-typed-input as capability-by-invariance.
- §When-a-new-input-modality-can-be-projected-to-an-existing-substrate, §project-it-and-don't-give-the-agent-a-new-input-API.
- §Three-Options-with-Pros-Cons-no-preferred — distinct from Options-Considered-with-preferred.
- §The-agent-never-receives-raw-audio — only text (capability boundary).
- §Capability-boundary-IS-the-projection-to-existing-substrate.
- §Three-explicitly-named-non-changes-as-evidence-of-UI-only-claim.

**Tier-2 (design-doc shape patterns):**

- §Four-shapes-of-design-doc-alternatives-section in library (Alternatives-with-three-rejected + Alternatives-with-rejected+deferred + Options-with-preferred + three-Options-with-Pros-Cons-no-preferred).
- §Two-paragraphs-instead-of-N-named-disciplines in Endo-Idiom section.
- §Three-cycles-with-Endo-Idiom-section-with-varying-shape (232 + 246 + 255).
- §Conditional-dependencies-IS-an-honest-record (different options have different dep profiles).
- §Implicit-vs-explicit-axes-in-Pros-Cons-text (Pros/Cons prose vs axis table).

**Tier-3 (named comparisons):**

- §Three-cycles-with-UI-only-no-substrate-changes (248 + 250 + 255).
- §Three-cycles-with-named-capability-boundary-discipline (244 forbid-ambient + 253 degrade-across-substrate + 255 project-new-modality-to-existing-substrate).
- §Two-cycles-with-Pros-Cons-without-named-preferred (240 + 255).
- §Two-cycles-with-explicit-non-dependency-in-Depends-On (253 + 255).
- §Three-cycles-with-explicit-list-of-substrate-elements-that-don't-change (248 + 250 + 255).
- §Thirteen-cycles-on-no-new-abstractions discipline now.

## §Synthesis target — slot machine library

For a slot machine library:

- §Voice-input-IS-a-game-UI-concern-not-a-game-capability-concern.
- §UI-vs-capability as named-design-axis for §game-feature-classification.
- §The-game-rule-cannot-distinguish-voice-input-from-typed-input as capability-by-invariance.
- §Project-new-input-modality-to-existing-substrate for §gestural-game-controls-projected-as-existing-game-action-API.
- §Three-Options-with-Pros-Cons-no-preferred for §game-feature-options-where-deployment-context-decides.
- §The-game-rule-never-receives-raw-audio for §game-rule-capability-boundary.
- §Three-explicitly-named-non-changes-as-evidence-of-UI-only-claim for §narrow-game-feature-evidence.

## §Library meta-counters

- §Library-reaches-761-sections at cycle 255 (designs-lane endoclaw-voice).
- §Eighty-eighth-consecutive designs-chat alternation cycle (cycles 166-250 + 252-255; cycle 251 was out-of-band papers).
- §Thirteen-cycles-on-no-new-abstractions discipline (211 + 214 + 222 + 232 + 236 + 238 + 240 + 242 + 244 + 246 + 248 + 250 + 255).
- §Three-cycles-with-UI-only-no-substrate-changes (248 + 250 + 255).
- §Three-cycles-with-named-capability-boundary-discipline (244 + 253 + 255).
- §Three-cycles-with-Endo-Idiom-section-with-varying-shape (232 five-disciplines + 246 four-disciplines + 255 two-paragraphs-no-discipline-headings).
- §Three-cycles-with-explicit-list-of-substrate-elements-that-don't-change (248 + 250 + 255).
- §Four-shapes-of-design-doc-alternatives-section in library (Alternatives-with-three-rejected 240 + Alternatives-with-rejected+deferred 238 + Options-with-preferred 250 + three-Options-with-Pros-Cons-no-preferred 255).
- §Two-cycles-with-Pros-Cons-without-named-preferred (240 + 255).
- §Two-cycles-with-explicit-non-dependency-in-Depends-On (253 + 255).
- §First-explicit-observation of four patterns: §UI-vs-capability as named-design-axis + §three-Options-with-Pros-Cons-no-preferred as distinct-from-Options-Considered-with-preferred + §capability-boundary-IS-the-projection-to-existing-substrate + §three-explicitly-named-non-changes-as-evidence-of-UI-only-claim.

(Kris Kowal (prompted) authored)
