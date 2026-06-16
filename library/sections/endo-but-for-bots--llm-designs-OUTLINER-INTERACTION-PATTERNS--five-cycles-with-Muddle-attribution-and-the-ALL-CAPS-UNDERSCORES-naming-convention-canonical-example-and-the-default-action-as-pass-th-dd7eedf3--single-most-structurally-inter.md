---
title: Single most structurally interesting move
section-slug: endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--five-cycles-with-Muddle-attribution-and-the-ALL-CAPS-UNDERSCORES-naming-convention-canonical-example-and-the-default-action-as-pass-through-and-three-vertical-zones-and-double-rAF-for-mobile
source-slug: endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/OUTLINER_INTERACTION_PATTERNS.md
authors: [Endo project (with attribution to Muddle project)]
status: (no explicit metadata table)
ingest-cycle: 285
ingest-date: 2026-06-10
lane: designs
scope: full
total-lines: 996
parent: endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--five-cycles-with-Muddle-attribution-and-the-ALL-CAPS-UNDERSCORES-naming-convention-canonical-example-and-the-default-action-as-pass-through-and-three-vertical-zones-and-double-rAF-for-mobile
---

**§the-`{ type: 'default' }`-action-as-named-pass-through-discipline** — the design treats "do nothing app-level; let the browser handle it" as **one of the named cases in a closed type union**, not as the absence of a case. This makes the behavior layer a *total function* over keystrokes: every key produces some named action; one of those named actions is "fall through". The total-function discipline means:

1. The type system catches "did you forget to handle this key?" because the union is exhaustive.
2. Tests can assert `{ type: 'default' }` explicitly — a test for "Enter at end + cmd-pressed returns default" is a positive test, not a negative one.
3. The architecture is explicit about its non-interception, not implicit. Every keystroke is *consciously* either intercepted or passed through.

This is **§the-named-no-op-as-named-action** — a discipline that turns "absence of a decision" into "an explicit decision". The pattern generalizes far beyond outliners: any layer that selectively intercepts events can use a `default`-typed action to make pass-through explicit.

§the-closed-discriminated-union-with-an-explicit-no-op-member-IS-the-architectural-discipline. §total-function-over-input-events.
