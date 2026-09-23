---
title: §The agent cannot exceed its granted capabilities
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

§The-Endo-Idiom-paragraph: *The agent cannot exceed its granted capabilities — if it only has read-only Gmail access, it cannot send emails. If its timer is capped at once per hour, it cannot spam.*

§Capability-by-construction-via-composition — §the-design-pattern-IS-bounded-by-the-substrate-caps + §the-pattern-itself-cannot-relax-the-bounds. §Six-cycles-with-explicit-capability-by-construction-discipline (234 + 238 + 244 + 246 + 253 + 257).

§Two-named-grant-bounds-in-the-example: §read-only-Gmail-cannot-send + §timer-capped-at-once-per-hour-cannot-spam. §Each-bound-IS-the-substrate-cap's-policy-knob. §When-the-pattern-is-bounded-by-the-substrate-caps-not-by-its-own-logic, §name-the-bounds-explicitly + §the-bounds-IS-the-evidence-of-the-pattern's-safety.
