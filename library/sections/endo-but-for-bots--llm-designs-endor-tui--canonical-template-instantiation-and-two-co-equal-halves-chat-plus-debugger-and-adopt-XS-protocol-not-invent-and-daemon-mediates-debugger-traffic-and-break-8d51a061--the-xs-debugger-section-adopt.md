---
title: §The XS Debugger section — adopt-but-replace discipline named at the protocol layer
source-slug: endo-but-for-bots--llm-designs-endor-tui
section-slug: canonical-template-instantiation-and-two-co-equal-halves-chat-plus-debugger-and-adopt-XS-protocol-not-invent-and-daemon-mediates-debugger-traffic-and-breakpoints-are-daemon-durable
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endor-tui.md
source-repo: endojs/endo-but-for-bots
source-path: designs/endor-tui.md
source-author: Kris Kowal (prompted)
total-lines: 887
ingest-cycle: 269
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
parent: endo-but-for-bots--llm-designs-endor-tui--canonical-template-instantiation-and-two-co-equal-halves-chat-plus-debugger-and-adopt-XS-protocol-not-invent-and-daemon-mediates-debugger-traffic-and-breakpoints-are-daemon-durable
---

Lines 456-668 carry a §XS-Debugger section detailed enough to be a sub-design.

### §`mxDebug` protocol named explicitly
The Moddable XS native debugger protocol. §the-protocol-IS-named-by-its-implementation-marker — §sibling-pattern to cycle 254's no-shim's named-shim-module discipline; §the-protocol-name-IS-the-stable-vocabulary + §the-tool-name-IS-not.

### §Daemon-mediated debugger traffic — capability boundary
Design Decision 5 names the architecture: §daemon-mediates-debugger-traffic + §TUI-speaks-only-bus-verbs. §The-daemon-IS-the-mediator + §the-TUI-IS-the-presentation; §the-direct-TUI-to-worker-debugger-socket-IS-rejected-because-it-bypasses-capability-based-access-control.

§First-explicit-observation in library: **§the-debugger-mediation-discipline — §daemon-mediates-debugger-traffic-because-it-can-enforce-capability-based-access-control + §TUI-speaks-only-bus-verbs**.

§The-capability-based-access-control-discipline names: *"a guest cannot attach to another guest's worker"*. §the-discipline-IS-an-instance-of-the-broader-capability-systems-isolation-discipline + §the-daemon-IS-the-policy-enforcement-point.

### §Daemon-durable breakpoints
Design Decision 6: §breakpoints-survive-TUI-restarts + §the-agent-can-stop-at-configured-breakpoints-even-with-no-TUI-attached. §the-breakpoint-IS-the-design's-named-persistence-anchor + §the-agent-blocks-at-the-breakpoint-rather-than-continuing-through-it.

§First-explicit-observation in library: **§daemon-durable-breakpoints-as-named-persistence-discipline — §a-developer's-mental-model-of-"I-set-a-breakpoint-here"-must-survive-process-restarts + §the-breakpoint-IS-the-named-persistence-anchor**.

### §Debugger opt-in per worker
Design Decision 7: §workers-launched-without-the-debug-flag-show-a-greyed-out-state. §the-opt-in-discipline-prevents-surprise-pauses-in-production; §the-greyed-out-state-IS-the-visible-evidence-of-the-non-debuggability + §the-developer-knows-which-workers-can-be-paused.

§First-explicit-observation in library: **§debugger-opt-in-per-worker-with-greyed-out-state-as-evidence-of-non-debuggability**.
