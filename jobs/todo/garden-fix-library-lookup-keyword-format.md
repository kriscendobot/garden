---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Self-improvement finding (liaison bus, 2026-08-11, from `minion-town-weblet-usage-metering-design` job, sent by endolin-garden2-5bcdff64):

`skills/library-lookup/SKILL.md` and `journal/library/conventions.md` document keyword rows as `<term> | <concept-id>`, but the live `journal/library/keywords.md` actually uses `- <terms> -> <concept-id>`. Reconcile: either update the two doc sources to name the live shape, or normalize `keywords.md` to the documented pipe format (and migrate existing rows) — whichever keeps future writeback callers from appending a second, inconsistent format. Verify no other doc references the stale shape before closing.
