---
title: "Backslash line-continuation and Unicode text"
source: examples/german.kni
source_repo: kriskowal/kni
source_commit: 2aea0f1b09fbb2330e93d77e89a274b294a36b4d
source_date: 2018-03-25
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

> Abstract: Three lines spelling a long German compound word across line breaks using the trailing-`\` **line-continuation** escape (`Rindfleische\` + newline + `tikettierungs…` joins with no inserted space, defeating kni's default collapsed-space-at-line-breaks), inside German low / high quotation marks `„…”`. A rendering-only demonstration that kni passes Unicode through verbatim and that a `\` at end-of-line suppresses the word break.

By default kni collapses a line break into a single space (the "collapsed space" model of the MANUAL text-space-and-symbols section), which is right for wrapping prose but wrong when a single token is split across source lines for readability. The trailing `\` is the escape: it joins the next line with no intervening space, so the three source lines render as one unbroken compound word. The surrounding `„…”` marks and the long German word also show that kni is Unicode-transparent — non-ASCII source is emitted as-is.

This section is a brief pointer ingested for completeness. It is the escape complement to `ascii` (quotes, dashes, brace escaping) and to the collapsed-space rules documented authoritatively in the MANUAL text-space-and-symbols section.

Source: [examples/german.kni](https://github.com/kriskowal/kni/blob/2aea0f1b09fbb2330e93d77e89a274b294a36b4d/examples/german.kni) at commit `2aea0f1b`.
