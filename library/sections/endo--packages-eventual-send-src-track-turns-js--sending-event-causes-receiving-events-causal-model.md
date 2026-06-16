---
title: The trackTurns JSDoc causal model — each call to trackTurns is itself a sending event in some turn at some event-within-turn, and each subsequent call to the returned TurnStarterFns is a receiving event that begins a new turn; the sending event *caused* each of the receiving events. The early-return guard for ENABLED / globalThis / globalThis.assert as the *inert-fallback* discipline. The `Caused by:` chain that links the new sending-event to the prior turn's prior-error. The TurnStarterFn typedef as the type-level closure of the model
source: packages/eventual-send/src/track-turns.js
source_repo: endojs/endo
source_branch: master
source_commit: 86d983a0fbd1c16089953eecabaec28e85defed5
source_date: 2025-05-12
source_authors: [Mark S. Miller]
source_lines: "78-117 (trackTurns JSDoc + body + TurnStarterFn typedef)"
topics: [eventual-send, errors, capability-theory]
status: current
kind: index
section_count: 6
---

Sections:

- [Abstract](endo--packages-eventual-send-src-track-turns-js--sending-event-causes-receiving-events-causal-model--abstract.md)
- [Body](endo--packages-eventual-send-src-track-turns-js--sending-event-causes-receiving-events-causal-model--body.md)
- [Connection to the wider library](endo--packages-eventual-send-src-track-turns-js--sending-event-causes-receiving-events-causal-model--connection-to-the-wider-library.md)
- [Translation block (comment idiom → contemporary practice)](endo--packages-eventual-send-src-track-turns-js--sending-event-causes-receiving-events-causal-model--translation-block-comment-idiom-contemporary-practice.md)
- [See also](endo--packages-eventual-send-src-track-turns-js--sending-event-causes-receiving-events-causal-model--see-also.md)
- [Common confusions](endo--packages-eventual-send-src-track-turns-js--sending-event-causes-receiving-events-causal-model--common-confusions.md)
