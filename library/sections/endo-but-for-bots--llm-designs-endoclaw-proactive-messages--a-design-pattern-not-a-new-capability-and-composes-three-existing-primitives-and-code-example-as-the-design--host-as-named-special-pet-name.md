---
title: §`@host` as named special pet name
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
const host = await E(powers).lookup('@host');
// ...
await E(host).send('@host', summary);
```

§The-`@host`-pet-name uses the §`@`-prefix-convention for §system-special-pet-names (sibling to cycle 250's reference to `@self` and `@agent`). §First-explicit-observation in library of §`@host`-as-named-special-pet-name + §the-`@`-prefix-as-system-namespace-convention.

§The-`@host`-IS-both-the-pet-name-of-the-host-and-the-target-of-the-message (`E(host).send('@host', summary)`). §The-double-use suggests `@host` is the canonical name for the host both as a referent and as a recipient.

§Sibling-pattern-to-cycle-250's-system-items-with-@-prefix-remain-with-existing-toggle — §two-cycles-with-`@`-prefix-system-pet-names (250 + 257). §First-explicit-observation in library of §the-`@`-prefix-as-system-pet-name-convention as named architecture-pattern.
