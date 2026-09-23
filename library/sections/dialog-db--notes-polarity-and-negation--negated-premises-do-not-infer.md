---
title: Polarity, Direction 1 — negated premises do not contribute to inference
source: notes/polarity-and-negation.md
source_repo: dialog-db/dialog-db
source_commit: ebd8f73989dd785697e58d31495dbb056c9f6c8b
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: A design note on the polarity discipline for rule-level type narrowing. Rule-level inference computes, per variable, the meet of the kinds of every slot the variable appears in, read as an occurrence-typing fact ("in every row that survives the positive premises, `?x` inhabits this type"). **Direction 1 (settled, semantics-bearing):** negated premises do not contribute to inference. In the running counterexample — `Person { name: ?name, nickname: ?nickname } unless club/banned(_, ?nickname)` with `nickname` optional — the negated `club/banned` lookup demands a present `?nickname`; if that demand joined the rule-wide meet it would strip `Nothing` from `?nickname`, demote the optional lookup to a required scan, and drop people without nicknames before the negation ever ran. Because a negated premise constrains which rows are *rejected* (facts about rows that do not survive) while inference describes rows that *do* survive, mixing the two changes the meaning of rules, so `TypeEnv::infer` skips `Premise::Unless` entirely.

> Design note. Records the polarity discipline adopted for rule-level type narrowing, the reasoning behind each direction, and the part that remains an open judgment call. User-facing behavior is summarized in `notes/guide.md`; this note is the rationale and the uncertainty.

Rule-level inference computes, per variable, the meet of the kinds of every slot the variable appears in. The result is read as an occurrence-typing fact: "in every row that survives the positive premises, `?x` inhabits this type." Two questions follow, one per direction of flow between the positive body and a negated premise.

## Direction 1: negated premises do not contribute to inference

Settled, and semantics-bearing. The running counterexample:

```text
Person { name: ?name, nickname: ?nickname }   // nickname is maybe
unless club/banned(_, ?nickname)
```

The negated `club/banned` lookup demands a present `?nickname` in its value slot. If that demand contributed to the rule-wide meet, the inference would strip `Nothing` from `?nickname`, the optional lookup would demote to a required scan, and people without nicknames would be dropped from the result before the negation ever ran. The rule says "unless the nickname is banned"; the narrowed reading would be "must have a nickname, and it must not be banned", which the author did not write and can write explicitly if wanted.

The general statement: a negated premise constrains which rows are *rejected*, so its demands are facts about rows that do not survive. Inference describes rows that do survive. Mixing the two changes the meaning of rules.

`TypeEnv::infer` therefore skips `Premise::Unless` entirely.

Source: [notes/polarity-and-negation.md](https://github.com/dialog-db/dialog-db/blob/ebd8f73989dd785697e58d31495dbb056c9f6c8b/notes/polarity-and-negation.md) at commit `ebd8f739`.
