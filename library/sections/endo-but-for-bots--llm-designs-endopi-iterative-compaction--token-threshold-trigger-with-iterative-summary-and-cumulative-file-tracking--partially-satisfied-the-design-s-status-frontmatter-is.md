---
section: token-threshold-trigger-with-iterative-summary-and-cumulative-file-tracking
source: endo-but-for-bots--llm-designs-endopi-iterative-compaction
topics: [agent-conventions]
status: current
title: "*Partially satisfied* — the design's Status frontmatter is"
parent: endo-but-for-bots--llm-designs-endopi-iterative-compaction--token-threshold-trigger-with-iterative-summary-and-cumulative-file-tracking
---

load-bearing

The §Status section is the design's *most consequential paragraph*.
It opens with the bald observation:

> *`packages/genie` already ships an iterative-compaction substrate
> that implements a sibling shape to Pi's.*

Cycle 121's family keystone §What Genie's existence tells us already
made this point: *the compaction gap has a working implementation*;
*Genie's observer / reflector pair is closer to a shipped iterative
compactor than `endopi-iterative-compaction`'s design anticipated*;
*the substrate now exists; the design's role shifts from "specify
the algorithm" to "harmonise with the observer/reflector pair and
route Lal/Fae transcripts through them"*.

This design *embodies that shift*. The Status block enumerates
Genie's shipped pieces:

- **Observer subagent** (`packages/genie/src/observer/index.js`) —
  compresses chat into prioritised observations
  (`memory/observations.md`) on a *token-threshold (default 30k)
  plus idle-timer trigger*. Runs as a background `PiAgent` with a
  focused tool set.
- **Reflector subagent** (`packages/genie/src/reflector/index.js`)
  — consolidates observations into long-term knowledge
  (`memory/reflections.md`, `memory/profile.md`) on a *40k-token
  threshold plus daily heartbeat trigger*; *prunes stale low-
  priority entries; merges related observations*.
- Both subagents are gated by `tool-gate.js` to ensure they
  actually call the memory-write tools they were dispatched for.

The §This satisfies clause names what remains:

> *the projection layer (run observer/reflector over Lal
> transcripts; surface their output back into Lal's transcript
> graph rather than to disk), plus the `keepRecentTokens` /
> `reserveTokens` knobs and the structured-summary format pi-mono
> uses.*

The *partially-satisfied* status pattern is structurally important:
it's the *honest-design-correction* discipline cycle 114's
familiar-unified-weblet-server.md exhibits, applied to a different
case. Where cycle 114 corrected a prospective implementation status,
this cycle corrects an *anticipated-algorithm-vs-shipped-substrate*
mismatch.
