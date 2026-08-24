---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Refresh https://github.com/endojs/endo-but-for-bots/blob/llm/designs/README.md
so it accurately indexes the current state of `designs/` on the `llm`
branch: add entries for designs landed since the index was last touched,
remove or mark superseded/dropped designs, and correct any stale status
notes (in-progress vs. landed vs. shelved). Treat it as a rolling index
refresh, not a rewrite — preserve its existing structure/conventions unless
they're actively wrong.
