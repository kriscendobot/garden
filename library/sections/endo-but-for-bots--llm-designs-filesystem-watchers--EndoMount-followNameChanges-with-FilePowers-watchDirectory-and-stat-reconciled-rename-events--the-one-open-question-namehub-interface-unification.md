---
section: EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
source: endo-but-for-bots--llm-designs-filesystem-watchers
topics: [daemon, persistence, tooling]
status: current
title: The §one-open-question — §NameHub-interface-unification
parent: endo-but-for-bots--llm-designs-filesystem-watchers--EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
---

§Open Questions has *only one* genuinely open question (rare
for designs this size): should `EndoMount` adopt the broader
`NameHubInterface`?

> *This is a larger refactor than the watcher addition and
> crosses into mount identity semantics. This design stays
> focused on parity for `followNameChanges`. A sibling design
> has been dispatched to address hub-interface unification on
> its own; cross-link here once that design lands.*

The §sibling-design-already-dispatched observation: the
related question already has *another design* handling it.
§don't-let-this-design-grow.

The §cross-link-here-once-that-design-lands placeholder: the
design *names where future cross-references will live*. The
§future-cross-reference-as-TODO-anchor pattern.
