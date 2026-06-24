---
section: pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal
source: endo-but-for-bots--llm-designs-formula-inspector
topics: [daemon, agent-conventions, tooling]
status: current
title: The §formula-references-as-clickable-links discipline
parent: endo-but-for-bots--llm-designs-formula-inspector--pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal
---

> *Render formula identifier references as clickable links
> that navigate to the referenced formula's inspector view.*

The §formula-graph-as-hypertext idiom: when a formula's
`worker` field references *another* formula, the UI surfaces
that as a clickable link. Clicking navigates to the referenced
formula's inspector. The §navigation-via-formula-identifiers
discipline means the user can *walk the formula graph* node by
node.

The §formula-graph-is-a-DAG observation: formula identifiers
reference *other* formulas; chasing references lets the user
*see the dependency structure* of any capability. Combined
with the §retention-path-reveal subsection below, this gives
a complete *navigability story* over the daemon's persistent
state.
