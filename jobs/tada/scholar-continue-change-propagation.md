# scholar-continue-change-propagation — complete

Continued the maintainer-endorsed change-propagation curation. Grounded every claim in
source; flagged what could not be grounded; cited everything.

## Sources ingested (2, both unmerged PR branches, flagged with lifecycle notes)
- endo-but-for-bots--pkg-pubsub-readme — @endo/pubsub README, PR #513, commit d15e34cb, 4 sections.
- endo-but-for-bots--llm-designs-notifier-pubsub-migration — design, PR #507 rev 5, commit 8c2a46be, 8 sections.

## Honesty flags
- Corrected: makeCancelKit is NOT an @endo/pubsub export (dropped per review; home is @endo/cancel).
- Flagged: factory-name divergence between #513 (makeChangeTopic/{publisher,subscribe}) and #507 (makeChangesPubSub/{sink,makeSpring,finish,fail}).
- Preserved intact: the propagator partial-grounding flag (FRB two-way bindings in-corpus; Sussman/Radul external).

## Concepts deepened
endo-pubsub (cancel-kit correction, rev-5 adapter set, 15-row section table), sliding-window-topic
(folded the landed research-frb-endo-exo-collections findings + the design future-evolution source;
makeWindowTopic flagged as proposed), change-propagation (section table + through-lines; flag untouched).

## Indexes
sources/README.md (+2 rows), topics/change-propagation.md (+13), topics/streams.md (+8),
keywords.md (fixed 3 stale "not in library" entries; +~20 grep entry points). Generator-maintained
sections/README.md left to its generator.

## Directions 3 & 4
gtor already fully ingested (no remainder). Through-lines deepened in place via the new sources.

## Pending upstream
Follow-on job scholar-reingest-pubsub-on-stabilize posted (re-ingest + reconcile names on #513/#507/@endo/cancel stabilization).

Bulletin synthesis delivered to maintainer (20260625T150946Z-9ec67f). All library writes on origin/journal2 (commit b4eaa529).

Self-improvement: the library corpus uses em-dashes pervasively despite skills/em-dash-style; matched corpus voice for consistency but the skill and the library have drifted — a reconciliation call for the liaison, not landed here.
