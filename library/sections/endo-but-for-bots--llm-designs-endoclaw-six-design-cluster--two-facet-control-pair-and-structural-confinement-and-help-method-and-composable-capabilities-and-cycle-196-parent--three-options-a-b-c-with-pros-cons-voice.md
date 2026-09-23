---
title: §Three-options-A-B-C with pros-cons (voice)
source-slug: endo-but-for-bots--llm-designs-endoclaw-six-design-cluster
section-id: two-facet-control-pair-and-structural-confinement-and-help-method-and-composable-capabilities-and-cycle-196-parent
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-{network-fetch,notifications,proactive-messages,webhooks,voice,browser}.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-{network-fetch,notifications,proactive-messages,webhooks,voice,browser}.md
total-lines: 439 (69 + 55 + 74 + 79 + 69 + 93)
status: Not Started (all six; created and updated 2026-03-03; Parent: endoclaw)
ingest-cycle: 226
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-six-design-cluster--two-facet-control-pair-and-structural-confinement-and-help-method-and-composable-capabilities-and-cycle-196-parent
---

The voice design names §three-implementation-options with §pros-and-cons-per-option:

| Option | Source | Pros | Cons |
|--------|--------|------|------|
| A: Web Speech API | browser-native | Zero deps; Chrome+Edge; no server | Requires internet; limited languages |
| B: Local Whisper | Familiar | Fully offline; privacy-preserving; better accuracy | Native binary or WASM; ~75MB model; CPU |
| C: Daemon transcription | daemon worker | Offloads compute; works remote/Docker | Latency; daemon bundles Whisper |

§Borrowable-pattern: §when-an-implementation-has-multiple-viable-paths, §name-the-options + §pros-cons-per-option + §let-the-reader-pick. §Different-from-cycle-218's §two-CapTP-transports-with-stretch-goal-marking; cycle-226's voice §names-three-options-without-a-default + §the-options-are-not-mutually-exclusive (they could ship in stages or coexist).

§Sibling to cycle 208 familiar-bundled-agents' §The-Powers-Problem-with-three-option-analysis. §Two-cycles-with-three-named-implementation-options + pros-cons-per-option.
