---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Rename "weblet"/"weblets" to "clip"/"clips" throughout
kriscendobot/minion.town — the garden's project that actually owns this
terminology (confirmed via search: it does not appear in
endojs/endo-but-for-bots or the garden's own roles/skills, only referenced
there in passing).

Scope: source code, tests, identifiers, comments, docs, and design
documents (including designs/weblet-ocap-synthesis.md — consider whether
to rename the file itself), covering case variants (Weblet, WEBLET,
weblet-*, *-weblet, etc.). Do this as its own focused, dedicated change
per skills/rename-discipline's spirit — don't mix it into unrelated work.

Use judgment on anything externally-visible that a hard rename could break
or orphan: published API routes/URLs, on-chain or protocol-level
identifiers, already-merged git branch names, and any external
documentation or announcements that used "weblet" — decide alias/redirect
vs. straight rename case by case and note the reasoning.

This likely touches many files; consider whether it needs to land as a
single PR or a staged sequence, and say so in the completion report.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-27T22:18:40Z
