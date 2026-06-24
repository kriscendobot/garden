---
title: §thisDiesIfThatDies + onCancel for lifetime
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

```js
context.onCancel(() => {
  // Disarm all active timeouts and deadlines
  for (const [, handle] of activeTimeouts) clearTimeout(handle);
  // ...
});

context.thisDiesIfThatDies(agentId);
```

§Two-named-lifetime-mechanisms: §context.onCancel-for-cleanup-on-cancellation + §context.thisDiesIfThatDies-for-lifetime-linkage. §When-the-scheduler-is-cancelled, §clean-up-timeouts; §when-the-agent-is-cancelled, §the-scheduler-is-cancelled-too.

§Two-cycles-with-thisDiesIfThatDies-named-lifetime-linkage (cycles 236 daemon-make-archive + 244 endoclaw-timer). §Cycle-236-used-thisDiesIfThatDies-for-scratch-state-tied-to-session; §cycle-244-uses-it-for-scheduler-tied-to-agent. §Two-different-substrates-but-the-same-named-mechanism.

§Sibling-to-cycle-242's-no-help()-in-this-layer — §two-cycles-with-explicit-layered-cleanup-by-cancellation-context.
