---
source: designs/daemon-xs-worker-metering.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-xs-worker-metering.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
status_at_ingest: Complete
genre: §endo-but-for-bots-design §sibling-design-trio
cycle: 184
lane: designs
status: current
title: §The-§Key-Insight-section (the design names it explicitly)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter
---

§Lines-77-102-contain-a-named-§Key-Insight section:

> An earlier revision of this design proposed embargoing a
> worker's outbound messages during each crank and discarding
> them if the crank was aborted by quota exhaustion. This is
> complex: it requires buffering in the bridge layer, crank-
> boundary delimiters, and reasoning about partial effects.
>
> A simpler model avoids embargo entirely:
> - **Hard per-crank limit**: a safety net that terminates the
>   worker if a single crank exceeds a fixed step threshold.
> - **Admission control**: the supervisor only delivers a
>   message when the worker's remaining budget exceeds the
>   hard limit.
> - Since any crank that completes normally used fewer steps
>   than the limit, the budget is always sufficient to cover
>   the crank's cost.

§The-§Prompt-section-at-the-end (lines 802-829) preserves both
the original embargo-based formulation and the §design-
evolution-realization:

> It just occurred to me that there is a simpler way to do
> quota based metering, avoiding the need to embargo anything.
> We can instead set a hard limit on the number of steps a
> worker can take after a message is delivered, after which
> the worker is considered hung and simply terminated...

§Two-prompts-in-one-design-file. §The-design-records-its-own-
evolution. §Compare-to-cycle-178-daemon-xs-worker-snapshot's
§revised-scope-discussion-2026-04-15 and cycle 180-hex-package's
§design-phase-after-implementation-phase + cycle 183-init's
"Initialization is often awkward". §All-four-are §honest-
design-evolution-record patterns. §This-one-records-the
*earlier-rejected-approach* explicitly in the prompt block.
