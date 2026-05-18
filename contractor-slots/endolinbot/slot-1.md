---
slot: 1
status: in-flight
design_path: designs/lal-transcript-memory-management.md
pr_number: null
current_stage: builder
in_flight_dispatch: 96b1b3
last_update: 2026-05-18T14:35:00Z
started_at: 2026-05-18T14:35:00Z
host: endolinbot
---

Slot 1 tenth pick after PR #129 surfaced as duplicate of the
formula-inspector slug pre-flight (builder lesson recorded: slug
checks should include literal verb names not just design slugs).

New pick: `lal-transcript-memory-management`. Substrate audit:
- `packages/lal/` exists with agent.js, types, etc.
- Predecessor design `lal-reply-chain-transcripts` already shipped
  TranscriptNode infrastructure.
- PR #123 is the fix for the predecessor design (broken transcript
  chains) — distinct from this design's durable persistence shape.

Scope: durable persistence of transcript tree so dismissed messages
still allow agent to walk the chain to root. Builder pre-flight is
the source of truth. Base: llm.

Dispatch root: `dispatches/builder--96b1b3`.
