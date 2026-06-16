---
source: designs/endoclaw.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/endoclaw.md
section_kind: design
ingested: 2026-06-06
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
  - Joshua T Corbin (edited)
topics:
  - daemon
  - capability-security
status_at_ingest: Reference
genre: §endo-but-for-bots-design §parity-comparison-as-design-document
cycle: 196
lane: designs
status: current
title: §Editor-attribution (Kris-Kowal-prompted + Joshua-T-Corbin-edited)
parent: endo-but-for-bots--llm-designs-endoclaw--parity-comparison-as-design-document-genre-with-thirteen-feature-categories-and-named-architectural-difference
---

§The-metadata-has-two-authors. §Kris-Kowal-(prompted) generated
the initial document; §Joshua-T-Corbin-(edited) added
substantive editorial revisions visible in the source as
§§"> Josh:" quote blocks.

§Five-§Josh-quote-blocks appear inline:

1. **Browser**: "Only need a full-fat browser to evade
   countermeasures like Anubis... To get started, all we
   need is a pair of `web_fetch` and `web_search` tools..."
2. **Smart-home**: "if we're going to even sketch a thing
   on the roadmap, start with Home Assistant rather than any
   one of the vendor platforms..."
3. **Agent-Management**: "I'm really not convinced that the
   claw notion of session is 1:1 with our chat spaces"
4. **Persistence**: "whatever else we do internally, message
   history (sessions) should get stored as Pi-compatible
   jsonl files..."
5. **Soul/Identity**: "insufficient, the claw's soul,
   identity, memory file(s) need to be part of its mutable
   workspace so that it can 'evolve'..."
6. **Security**: "other claws like LocalGPT, PicoClaw, and
   IronClaw at least implement system level sandboxing..."
7. **Voice-and-Media**: three separate `> Josh:` quotes
   linking external resources and noting attachment-not-just-
   images-eh.

§The-§inline-editorial-disagreement is preserved-not-resolved
in the design. §The-§"insufficient" comment names a
disagreement: Kris named SOUL.md as available; Josh says the
agent's identity/memory file needs to be in mutable workspace
for self-modification.

§Compare-to-cycle-178-snapshot's §revised-scope-discussion-
2026-04-15 and cycle 192-engo's §honest-design-evolution.
§Cycle-196-endoclaw-preserves-the-iteration as §inline-co-
author-quotes rather than as §a-section-named-revised-scope.

§Tier-1-borrowing: §inline-co-author-quote-blocks (`> Josh:`
prefix) as §record-of-editorial-disagreement-without-
flattening. §Future-readers-see-both-perspectives.
