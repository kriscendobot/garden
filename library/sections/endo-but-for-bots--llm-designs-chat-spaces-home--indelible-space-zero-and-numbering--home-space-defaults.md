---
title: "`HOME_SPACE_DEFAULTS`"
source: designs/chat-spaces-home.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 7f5671c6114a0100d8cc51064f9f68acf5a00ffb
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
notes: **Status: Complete** upstream. Sibling refinement of [[endo-but-for-bots--llm-designs-chat-spaces-gutter--motivation-and-architecture]] covering the *configurable home space*. The *config-key* numbering (`spaces/0` for home, `spaces/1..9` for user spaces) IS implemented in source. The *keyboard-shortcut* numbering shown in this section's table (`Cmd+0` for home) is **aspirational** — the current source implements `Cmd+1` = home, `Cmd+2..9` = first 8 user spaces, with no `Cmd+0`. The design's table and the source are out of step on this one point. See the section body for the resolution + cycle-58 result for the upstream PR proposal.
parent: endo-but-for-bots--llm-designs-chat-spaces-home--indelible-space-zero-and-numbering
---

```js
const HOME_SPACE_DEFAULTS = harden({
  id: 'home', name: 'Home', icon: '🐈‍⬛',
  profilePath: [], mode: 'inbox', scheme: 'auto',
});
```

Three discipline rules around defaults:

1. **On load (`refresh()`)**, only `icon` and `scheme` are merged
   from stored config. `name`, `profilePath`, `id`, and `mode` are
   always taken from defaults. *Storage is allowed to drift; the
   merged config is the source of truth.*
2. **On save (`updateSpace('home', updates)`)**, indelible fields are
   enforced before storing at `['spaces', '0']`. *Storage is
   normalized on write so that even if external code wrote a bad
   shape, the next save corrects it.*
3. **`harden()` on the defaults object**, per the hardened-JavaScript
   convention from the broader Endo ecosystem.

The two-sided enforcement (merge-on-load AND normalize-on-save) is
the *belt-and-suspenders* discipline: even if external code wrote
an unhardened or malformed entry at `['spaces', '0']`, the chat
client's view of home is always consistent.
