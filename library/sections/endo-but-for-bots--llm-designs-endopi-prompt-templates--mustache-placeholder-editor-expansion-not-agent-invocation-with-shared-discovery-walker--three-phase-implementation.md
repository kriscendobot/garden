---
section: mustache-placeholder-editor-expansion-not-agent-invocation-with-shared-discovery-walker
source: endo-but-for-bots--llm-designs-endopi-prompt-templates
topics: [agent-conventions]
status: current
title: Three-phase implementation
parent: endo-but-for-bots--llm-designs-endopi-prompt-templates--mustache-placeholder-editor-expansion-not-agent-invocation-with-shared-discovery-walker
---

The §Phased implementation lists three phases:

1. **Loader + discovery.** Scan paths, parse, return
   `PromptTemplate[]`.
2. **Slash-command registration.** Templates appear in
   autocomplete.
3. **Variable substitution + argument prompts.** Form UI for
   missing variables.

The §three-phase-shape is *minimal-then-add-features*. Phase 1 is
*infrastructure* (load files); phase 2 is *UI integration*
(autocomplete); phase 3 is *substitution + form UI*. Each phase
ships independently.
