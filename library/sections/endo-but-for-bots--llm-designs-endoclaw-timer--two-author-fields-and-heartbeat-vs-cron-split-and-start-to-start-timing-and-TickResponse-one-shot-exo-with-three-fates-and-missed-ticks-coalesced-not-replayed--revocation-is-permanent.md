---
title: §Revocation is permanent
source-slug: endo-but-for-bots--llm-designs-endoclaw-timer
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-timer.md
authors: [Kris Kowal (prompted), Joshua T Corbin (evolving)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-timer.md
total-lines: 837
ingest-cycle: 244
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-timer--two-author-fields-and-heartbeat-vs-cron-split-and-start-to-start-timing-and-TickResponse-one-shot-exo-with-three-fates-and-missed-ticks-coalesced-not-replayed
---

§Design-Decision-8: §Revocation-is-permanent. *Once `revoke()` is called, the `IntervalScheduler` capability is dead. The host must create a new scheduler to restore access.*

§Permanence-as-named-discipline + §the-restoration-mechanism-IS-creating-a-new-scheduler-not-un-revoking. §When-revocation-is-permanent, §state-the-permanence-explicitly + §name-the-restoration-mechanism.

§Sibling-pattern-to-cycle-234's-two-layered-revocation — §cycle-234's-revocation-is-local-authoritative-plus-remote-best-effort; §cycle-244's-revocation-is-local-only-permanent. §Two-different-shapes-of-revocation.
