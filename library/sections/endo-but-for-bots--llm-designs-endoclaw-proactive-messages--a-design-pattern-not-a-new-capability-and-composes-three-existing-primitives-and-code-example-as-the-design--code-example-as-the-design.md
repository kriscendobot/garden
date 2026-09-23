---
title: §Code example as the design
source-slug: endo-but-for-bots--llm-designs-endoclaw-proactive-messages
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-proactive-messages.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-proactive-messages.md
total-lines: 74
ingest-cycle: 257
ingest-date: 2026-06-10
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-proactive-messages--a-design-pattern-not-a-new-capability-and-composes-three-existing-primitives-and-code-example-as-the-design
---

```js
const setup = async (powers) => {
  const timer = await E(powers).lookup('timer');
  const gmail = await E(powers).lookup('gmail');
  const host = await E(powers).lookup('@host');

  // Morning briefing at 08:00 every day
  await E(timer).schedule('0 8 * * *', async () => {
    const unread = await E(gmail).fetch('/messages?q=is:unread&maxResults=5');
    const summary = await summarizeWithLLM(unread);
    await E(host).send('@host', summary);
  });
};
```

§The-code-example-IS-the-design — §the-fourteen-line-snippet shows the entire pattern. §No-Capability-Shape-section-because-no-new-capability — §the-code-example-replaces-the-Capability-Shape-section.

§First-explicit-observation in library of §code-example-as-the-design (as distinct from Capability-Shape-as-the-design). §When-a-design-is-a-composition-pattern-not-a-new-capability, §the-code-example-IS-the-spec + §the-Capability-Shape-section-is-absent-not-forgotten.

§Three-lookups-then-one-schedule — §the-composition-IS-the-pattern: §look-up-the-three-substrate-caps + §compose-them-in-a-single-async-callback + §the-callback-IS-the-agent's-policy. §Sibling-pattern-to-cycle-244's-IntervalScheduler-pet-name-handle (the scheduler's stable pet-name `SCHEDULER` accessible to the agent) — §cycle-257's-`E(powers).lookup('timer')` uses-the-same-discovery-mechanism.
