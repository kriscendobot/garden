---
title: §the-textarea-not-contentEditable-decision with four named reasons (first-explicit-observation)
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

The doc enumerates **four named reasons** for choosing `<textarea>` over `contentEditable`:

1. **Predictable cursor behavior** — `textarea.selectionStart`/`selectionEnd` give exact numeric cursor positions; ContentEditable uses Range/Selection APIs that are notoriously inconsistent across browsers.
2. **No HTML injection surface** — Textareas only contain plain text. No XSS concerns from paste, no unexpected formatting.
3. **Simpler event model** — `onChange` gives you the new value; no `beforeinput`/`input` event circus.
4. **Auto-resize is trivial** — Set `height: auto`, then `height = scrollHeight + 'px'` on every change.

**§the-four-named-reasons-for-rejecting-the-richer-API pattern** (first-explicit-observation): the design names the seductive alternative and itemizes why it was rejected. Compare cycle 283's §three-named-rejected-alternatives-with-reasons (loopback TCP + kernel credential check; cryptographic attestation); this is the same shape applied to web APIs.

**§the-tradeoff-IS-explicitly-named**: "The tradeoff is that rich text formatting (bold, links) must be rendered separately — we use markdown rendering for display and raw text for editing." This is **§the-name-the-rejected-feature pattern** — the design says what it loses, not just what it gains.
