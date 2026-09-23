---
section: pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal
source: endo-but-for-bots--llm-designs-formula-inspector
topics: [daemon, agent-conventions, tooling]
status: current
title: The §retention-path-reveal facility
parent: endo-but-for-bots--llm-designs-formula-inspector--pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal
---

> *Provide a facility for revealing every retention path in
> the formula graph for identified formulas.*

The §retention-path-reveal subsection ties this design to the
cycle 49's retention-path-notation cluster
(`endo-but-for-bots--llm-designs-retention-path-notation`).
Each pet-named capability has *one or more retention paths* —
the chains of named references from a persistent root that
keep it alive in the persistent store.

The §why-retention-paths-matter discipline: removing the
*last* retention path GCs the formula. Showing retention
paths in the inspector tells the user *exactly which removals
will lose the capability*. Cycle 49's retention-path-notation
gives the *textual encoding* for paths; this design surfaces
the *visual rendering* in the inspector UI.
