---
section: endo-locator-url-format-with-externalize-internalize-duality-and-LOCAL_NODE-sentinel
source: endo-but-for-bots--llm-designs-daemon-locator-reference
topics: [daemon, ocapn]
status: current
title: The §connection-hints-are-ephemeral discipline
parent: endo-but-for-bots--llm-designs-daemon-locator-reference--endo-locator-url-format-with-externalize-internalize-duality-and-LOCAL_NODE-sentinel
---

The §Connection Hints and Peer Info section names the *transport-
addresses-are-ephemeral* discipline:

> *Connection hints (`at` parameters) are ephemeral transport
> addresses.*
>
> *1. The formula identifier is extracted and stored durably*
> *2. The hints are forwarded to the peer info system via
>    `addPeerInfo`*
> *3. Hints are not stored with the formula — they are looked up
>    fresh when producing a locator for sharing*
>
> *When producing a locator for sharing (`locate`), the current
> hints for the peer are fetched from the network layer and
> appended as `at` parameters.*

The §hints-stored-separately-from-formula-identity discipline:
the *identity* of the formula (who, which one, what kind) is
durable; the *transport hints* are *replaceable*. When sharing a
locator, the system *looks up fresh hints* — it doesn't
*re-share old hints*.

This is the §addressing-is-not-identity discipline: peer A's
network address may change (Wi-Fi vs cellular vs Tor), but A's
public key doesn't. Locators carry the durable identity in
parameters that *don't change* (`nodeNumber`, `id`, `type`); the
ephemeral parameters (`at`) carry the *currently-reachable*
addresses.
