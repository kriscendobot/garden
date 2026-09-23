---
title: "How EQ Makes a Difference: address equality resolves the puzzle, at a cost"
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

How an `EQ` primitive changes the outcome, and the Java code that demonstrates it. The simplest `EQ` is Lisp's original **address-equality** primitive (since appearing in Smalltalk, KeyKOS, and Java). Were the Grant Matcher to use it, `EQ` would return *false* in the "Alice Gets Greedy" scenario — the forwarder is not KEQD — so both donors get their money back instead. That is a perfectly acceptable outcome, though it has real costs, *especially in the distributed case* (where address equality is exactly what is hard to provide without a man-in-the-middle). The page closes with a reference implementation: an abstract `GrantMatcher` that escrows both donations, checks the destinations agree, gives the sum to the common charity, and refunds on failure — left abstract so subclasses choose how to determine equality (`EQGrantMatcher` via Java's `==`, `EqualsGrantMatcher` via `Object.equals()`), with `MalletCharity` as the charity-in-the-middle that forwards all equality messages while pocketing donations.

Of all varieties of `EQ` primitive, the simplest is the original address-equality primitive from Lisp, since then appearing in everything from Smalltalk to KeyKOS to Java. Were the Grant Matcher to use this primitive, `EQ` would say *false* in the "Alice Gets Greedy" scenario, and both would get their money back instead. This is a perfectly acceptable outcome, though it has some real costs, especially in the **distributed case**.

The page links a reference implementation of an address-equality-based Grant Matcher. The Grant Matcher is implemented as a single object (more complicated uses of the same pattern might make it a two-faceted object — one each for Alice and Dana; Joule, KeyKOS, and Mach provide multiple facets primitively, and Marc Stiegler explains how to implement multiple facets in languages such as Java or E using the **Facade pattern**):

- **`Charity.java`** — interface to those, like KEQD, that can accept a donation.
- **`GrantStatus.java`** — interface for callbacks provided by Alice and Dana in their GrantMatcher requests, so they can find out the status of their request and receive a refund if needed.
- **`GrantMatcher.java`** — accepts two messages, escrows the money from each, sees that they agree, gives the sum to the common charity, and lets both sides know the transaction completed; otherwise refunds any money escrowed and signals failure. This class is **abstract**, leaving subclasses to decide how to determine equality.
- **`EQGrantMatcher.java`** — determines equality via the Java `EQ` primitive, `==`.
- **`EqualsGrantMatcher.java`** — determines equality via the Java `Object.equals()` message.
- **`MalletCharity.java`** — a Charity-in-the-middle that forwards all equality messages to the Charity it is trying to impersonate, while pocketing all donations.

The lasting lesson: the choice of equality primitive is not free. Address-equality `EQ` defeats the transparent-forwarder attack but precludes truly transparent forwarders; a message-only system preserves transparency but cannot, by itself, answer the equality question safely. A distributed object-capability system that wants both a safe equality test *and* reliable transport needs a **pass-invariant equality** primitive and a man-in-the-middle-resistant handoff — the modern OCapN answer to the two questions this puzzle poses.

Source: [The Grant Matcher Puzzle](https://erights.org/elib/equality/grant-matcher/index.html) § How EQ Makes a Difference, Mark S. Miller, erights.org; fetched 2026-06-27 via the erights.github.io GitHub Pages mirror, content SHA-256 `d25136c9` (byte-identical to the prior Internet-Archive capture).
