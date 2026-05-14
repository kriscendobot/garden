---
title: Summary (publisher decision matrix)
source: packages/notifier/README.md
source_repo: agoric/agoric-sdk
source_commit: eaef5bfd888e01d641e3e450df4809a165c68633
source_date: 2024-10-31
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
topics: [eventual-send]
status: current
---

> Abstract: The producer-side decision matrix. Publisher decides whether to support fully lossless, forward-lossless, and/or lossy consumption. Use a PublishKit `subscriber.getUpdateSince` or a NotifierKit when consumers only care about recent states (changing-quantity pattern). Use a PublishKit `subscriber.subscribeAfter` or a SubscriptionKit when consumers need gap-free values. Consumers can independently choose how to process the sequence; the publisher doesn't have to know its consumers, and consumers can't interfere with the producer or with each other.

# Summary

Data producers must decide whether to support fully lossless, forward-lossless, and/or lossy consumption. If your consumers only care about more recent states, then use a PublishKit `subscriber.getUpdateSince` or a NotifierKit. This is often appropriate when the iteration represents a changing quantity. If you want to support consumers that need to see gap-free values, then use a PublishKit `subscriber.subscribeAfter` or a SubscriptionKit.

Consumers can choose different ways of processing the sequence. In all cases, the publisher doesn't have to know the consumers, and the consumers can't interfere with the producer or with each other.

Source: [packages/notifier/README.md](https://github.com/Agoric/agoric-sdk/blob/eaef5bfd888e01d641e3e450df4809a165c68633/packages/notifier/README.md) at commit `eaef5bfd`.
