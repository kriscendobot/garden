---
title: Stage 5 — question/answer GC (op:gc-answers)
source: implementation-guide/Implementation Guide.md
source_repo: kriscendobot/ocapn
source_commit: 8704f69e01f93701de8bc5eb4bb22b9927a2665a
source_date: 2026-03-12
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
topics: [ocapn, captp]
status: current
notes: Simpler than stage 3 because only the questioner uses the question — no need for a wire-delta because there are no concurrent referencers. Symmetric counterpart to stage 3's import/export GC.
---

> Abstract: Stage 5 milestone: GC questions and answers via `op:gc-answers`. Because only the questioner uses a question (no third party can reference the answer-pos), the GC operation is simpler than stage 3's `op:gc-exports`: a single list of `answer-pos` values, no wire-delta needed. The questioner's representation of the question is GC'd locally; a finalizer emits `op:gc-answers` for the corresponding positions; the other side removes them from its answers table.

### Stage 5: question/answer gc

When it comes to questions and answers those can also build up. The exporting peer can't know when they can be GC'd unilaterally — but unlike imports/exports, only the *questioner* uses the question (the answer-pos lives in the questioner's outgoing side). This means the questioner is the only side that knows when to release.

`op:gc-answers` operation:

```
<op:gc-answers answer-pos-list>  ; list of positive integers
```

No wire-delta is needed: because only the questioner references the answer-pos, there can't be concurrent in-flight references the exporter is unaware of.

Alisha sets up a hook to be called when her internal question representations are collected. When her hook fires she looks up the questions in her questions table, gets each corresponding `answer-pos`, and emits the `op:gc-answers` record. She removes the entries from her own questions table. On the other side, she handles incoming `op:gc-answers` by removing the answers from her answers table.

Source: [implementation-guide/Implementation Guide.md](https://github.com/ocapn/ocapn/blob/8704f69e01f93701de8bc5eb4bb22b9927a2665a/implementation-guide/Implementation%20Guide.md) at commit `8704f69e`.
