---
title: "Quote, dash, and escape rendering"
source: examples/ascii.kni
source_repo: kriskowal/kni
source_commit: 435ec3cf062a40cee0dc1b8ec948c6fee4e516fd
source_date: 2016-07-30
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

> Abstract: A rendering-only reference of kni's typographic conventions: `{"…"}` and `{'…'}` wrap curly double / single quotes (nestable, `{"…{'…'}…"}`), `--` renders an en-dash and `---` an em-dash (`The em-dash---as seen here---…`, optionally space-padded), and `'}` escapes a literal brace so quote characters can carry into prose. No decision-graph constructs — the value is that it concretizes the MANUAL text-space-and-symbols rules for anyone rendering text.

The file is seven lines, each a small typographic demonstration: nested quote braces (`{"Quotes {'within'} quotes"}`), the en-dash for number ranges (`1--20`), the em-dash for parentheticals (padded or unpadded), a leading `'}` producing a literal apostrophe/brace, and space-tolerant quote braces. It carries no options, variables, blocks, or flow directives; it exists purely to show how kni turns markup into curly quotes and proper dashes.

This section is a brief pointer, ingested for completeness so the examples corpus has a landing page for kni's text-rendering conventions; the authoritative treatment is the MANUAL text-space-and-symbols section, and `german` is its sibling escape reference (backslash line-continuation and Unicode pass-through).

Source: [examples/ascii.kni](https://github.com/kriskowal/kni/blob/435ec3cf062a40cee0dc1b8ec948c6fee4e516fd/examples/ascii.kni) at commit `435ec3cf`.
