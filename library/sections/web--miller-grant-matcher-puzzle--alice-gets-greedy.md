---
title: "Alice Gets Greedy: the transparent-forwarder attack on a message-only equality protocol"
source_kind: web
source_url: https://erights.org/elib/equality/grant-matcher/index.html
source_content_sha256: d25136c94d42dc389c74d8bdff8ae63871bd6a00bc85a07b3c1aad4606107b58
source_authors: [Mark S. Miller]
source_date: 2000-01-01
ingested: 2026-06-27
ingested_by: scholar
topics: [capability-theory, marshal, captp]
status: current
---

The attack that defeats a message-only equality protocol in a system with *truly transparent* forwarders. In Actor systems and in Joule, equality protocols bottom out in an internal `EQ` that is deliberately hooked in so it **cannot reveal a transparent forwarder** interposed on a messaging path — otherwise full transparency would be lost. So Alice can hand the Grant Matcher a reference to a transparent forwarder to KEQD that forwards everything (including the equality-protocol messages) **except** a message carrying $20, which it diverts to Alice's own bank account. The Grant Matcher cannot distinguish this from the honest case except at the price of the very $20 at stake. The asymmetry is the point: Alice has not, strictly, done anything dishonest (her forwarder is a valid conduit to KEQD, and giving the $20 directly to KEQD would leave her without complaint), but Dana can lose his $10 with no destination acceptable to *Dana* receiving $20.

In Actor systems and in Joule, these equality protocols may eventually bottom out in an internal *EQ* primitive, but this primitive is hooked into the system in such a way as to prevent revealing a transparent forwarder interposed on a messaging path. If the primitive could be used to reveal the forwarder, then full transparency would be lost. In such a system, one could not have a transparent forwarder.

So, in a system in which forwarders can truly be transparent, Alice can send to the Grant Matcher instead a reference to a transparent forwarder to KEQD. This forwarder always transparently sends messages through to KEQD, unless those messages carry $20. In that latter circumstance, the forwarder will deposit the money to Alice's bank account. By assumption, the Grant Matcher cannot distinguish this situation from the earlier one, except at the price of the very $20 that is at stake.

Notice that Alice cannot really be said to have done anything dishonest. The cause she is designating to the Grant Matcher is simply one that acts just like KEQD, except for where it puts $20 bills. If Dana were to designate this same forwarder object in its request to the Grant Matcher, it would be stating that this object is where it would like to see the money go as well. Since Alice's object is forwarding messages to KEQD — including the messages that make up the equality protocol — the intermediate object could validly also be seen as part of the plumbing, a message conduit for delivering messages to KEQD. In this sense, KEQD itself would also be a valid interpretation of what Alice meant by the capability she passed; were the Grant Matcher to give the $20 directly to KEQD instead of her forwarder, Alice would have no grounds for complaint.

However, the Grant Matcher's situation is completely symmetrical, so it might still break the symmetry in Alice's favor, in which case Alice pockets the money. **Dana has lost his $10 even though no destination acceptable to Dana got $20.** By no stretch of semantics could one interpret Dana's actions so as to say that Alice's bank account was a valid interpretation of the destination Dana meant to designate.

Source: [The Grant Matcher Puzzle](https://erights.org/elib/equality/grant-matcher/index.html) § Alice Gets Greedy, Mark S. Miller, erights.org; ingested from the Internet Archive original-bytes capture, content SHA-256 `d25136c9`.
