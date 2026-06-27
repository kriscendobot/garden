---
title: "When it Works: the two questions — equality and transport"
source_kind: web
source_url: https://erights.org/elib/equality/grant-matcher/index.html
source_content_sha256: d25136c94d42dc389c74d8bdff8ae63871bd6a00bc85a07b3c1aad4606107b58
source_authors: [Mark S. Miller]
source_date: 2000-01-01
ingested: 2026-06-27
ingested_by: scholar
topics: [capability-theory, marshal]
status: current
---

The statement of the puzzle's two coupled questions. The Grant Matcher matches grants to a common destination: Alice wishes to give $10 to KEQD **only if** $10 also goes to KEQD from Dana, and Dana has the symmetric desire; the Grant Matcher (with no prior knowledge of KEQD) takes the money from each and gives the sum to the destination only if both donate the same amount and **designate the same destination**, otherwise refunding both. The puzzle is then: **(1) the equality question** — can the Grant Matcher determine whether Alice and Dana are designating the same destination? — and **(2) the transport question** — having determined this, can it reliably transport the money to the destination in a way mutually acceptable to Alice and Dana, ensuring Alice does not lose $10 unless a destination acceptable to her gets $20 (and symmetrically for Dana)?

The Grant Matcher provides the service of matching grants, to be given to a common destination. Alice wishes to use the Grant Matcher to give $10 to KEQD, but only if $10 also goes to KEQD from Dana. Dana has the symmetric desire involving Alice. The Grant Matcher has no previous knowledge of KEQD, but if both Alice and Dana provide the same amount of money and designate the same destination, the Grant Matcher will take the money from each and give the sum to the destination. Otherwise, the Grant Matcher returns the money to the prospective donors.

The Grant Matcher is assumed to be coded to perform its duties if it is possible for it to do so. The puzzle is:

1. **Can the Grant Matcher determine if Alice and Dana are designating the same destination?** (The *equality* question.)
2. **Having made a determination, can the Grant Matcher reliably transport the money to the destination, in a way mutually acceptable to Alice and Dana?** (The *transport* question.)

The Grant Matcher must operate so as to ensure that Alice will not lose $10 unless a destination acceptable to her gets $20. Similarly for Dana.

Suppose there is no *EQ* primitive — that one can only gain information about a capability by sending messages over it. Then the Grant Matcher has to determine equality by sending messages over these capabilities in some equality-determining protocol. Having determined — somehow — that both references are equivalent, the Grant Matcher can simply pick one and send the money. The next section shows why a message-only equality protocol is not enough.

Source: [The Grant Matcher Puzzle](https://erights.org/elib/equality/grant-matcher/index.html) § When it Works, Mark S. Miller, erights.org; ingested from the Internet Archive original-bytes capture, content SHA-256 `d25136c9`.
