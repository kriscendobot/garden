---
title: Producing values — rule heads are contracts
source: notes/guide.md
source_repo: dialog-db/dialog-db
source_commit: 3cd6607aa9e6f70d65bafe7692e1a52b953e1faf
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: The asymmetry between the two ends of a rule: **rule bodies filter; rule heads promise.** A conclusion's required field is a promise that every derived row carries a present value, so binding it from a variable that may be `Absent` is rejected at compile time (`RequiredHeadFromOptional`). The fix is to discharge the optionality explicitly before the head — e.g. `?text.is(?nick.unwrap_or("friend"))` — turning a `maybe` into a present value the head can promise. The same contract holds across concept boundaries: an outer rule that feeds an inner concept's *optional* field into its own *required* head is rejected, because the inner concept's schema declares that the slot can deliver `Absent`.

Rule bodies filter; rule heads promise. A conclusion's required field is a promise that every derived row carries a present value, so binding it from a variable that may be `Absent` is rejected at compile time:

```rust
// REJECTED: RequiredHeadFromOptional
// deduce Greeting { text: String }   <- required head field
// when   Person { nickname: ?text }  <- ?text may be Absent
```

The fix is to discharge the optionality explicitly before the head:

```rust
// OK
// when Person { nickname: ?nick }
//      ?text.is(?nick.unwrap_or("friend"))
```

The same contract holds across concept boundaries: an outer rule that feeds an inner concept's *optional* field into its own *required* head is rejected, because the inner concept's schema declares that the slot can deliver `Absent`.

Source: [notes/guide.md](https://github.com/dialog-db/dialog-db/blob/3cd6607aa9e6f70d65bafe7692e1a52b953e1faf/notes/guide.md) at commit `3cd6607a`.
