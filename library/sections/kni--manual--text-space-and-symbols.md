---
title: Text, space, and symbols — literal narrative versus significant characters
source: MANUAL.md
source_repo: kriskowal/kni
source_commit: 120fd885f15c2b0d9b2def4faa113b1a0a4e87ca
source_date: 2025-12-29
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

Abstract: kni scripts are text (which appears in the generated narrative) interleaved with symbols (which are instructions to the engine). This section catalogs the reserved symbols and the "collapsed space" rule — the whitespace model by which text pieces are joined with or without a space, and by which curly braces can concatenate across line breaks. Grammar-level detail, load-bearing for authors but tangential to the agent-context lens.

Stories consist of text and symbols. Text appears in the generated narrative, and symbols provide instructions to kni.

Symbols include `>` on standalone lines (a prompt instruction), the bullets `-`, `*`, `+`, sequences of dashes, and `/`, `@`, `->`, `<-`, `{`, `|`, `}` for other instructions. Within an option, `[` and `]` are also special. The first non-space character after a curly brace may be a symbol; these include `%`, `~`, `$`, `@`, `#`, `?`, `!`, `>`, `<`, `<=`, `>=`, `==`, and `!=`. kni reserves any character that is not a letter or number for special use in that position. Any number of spaces or newlines is equivalent to a single space in the generated narrative.

**Collapsed space.** For any two pieces of text, if there is any whitespace between the first text and the next symbol, or before the second text and the previous symbol, those pieces are separated by whitespace in the narrative. The following are equivalent:

```
Hello, {Alice|Bob|Charlie}!
Hello,{ Alice| Bob| Charlie}!
Hello, { Alice| Bob| Charlie}!
```

You can use space around symbols to govern whether a space should exist on either side of adjacent text (`Hyper{-drive| space}.`). The narrative may use either a space or a newline as appropriate. Curly braces can concatenate long words across lines:

```
Was bedeudet, „Rindfleische{
}tikettierungsueberwachungs{
}aufgabenuebertragungsgesetz?”
```

Source: [MANUAL.md](https://github.com/kriskowal/kni/blob/120fd885f15c2b0d9b2def4faa113b1a0a4e87ca/MANUAL.md) at commit `120fd885`.
