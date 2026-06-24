---
title: Handoffs from the Exporter's perspective
source: "draft-specifications/CapTP Specification.md"
source_repo: kriscendobot/ocapn
source_commit: 8704f69e01f93701de8bc5eb4bb22b9927a2665a
source_date: 2026-03-12
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn, captp, capability-security]
status: current
notes: Maps to capability-security: third-party handoffs are how capabilities flow across mutually-suspicious peers.
parent: ocapn--draft-specifications-captp--third-party-handoffs
---

There are two events which will happen for the Exporter, these can happen *in any
order*:

-   The Gifter deposits a gift.
-   The Receiver sends a [`desc:handoff-receive`](#desc-handoff-receive) via the [`withdraw-gift` method](#withdraw-gift-method).

The Exporter performs the following:

1.  MUST verify the `desc:handoff-receive` and the `desc:handoff-give` it contains (see `desc:handoff-receive` section).
    If it is incorrect, abort the handoff; otherwise, continue.
2.  If the gift has already been deposited return the gift; otherwise return the
    gift when it is received.

Note: Gifts are specified by the Gifter to a single Receiver via the Receiver's Public Key from
the **Gifter-Receiver** session. The Exporter will likely not have seen this Public Key before.
The Receiver should be the only party able to withdraw the gift left by the Gifter.
Implementers MUST ensure that the management of gifts adheres to this requirement,
preventing unauthorized access to gifts.

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
