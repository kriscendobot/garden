---
title: Handoffs from the Receiver's perspective
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

When a [`desc:handoff-give`](#desc-handoff-give) is received, several actions
should be taken:

-   Validate the `desc:handoff-give`.
-   Construct a local promise in order to deliver the message to the intended
    object. The promise should eventually resolve to the remote reference.
-   Establish a connection to the Exporter if one does not exist.
-   Construct a [`desc:handoff-receive`](#desc-handoff-receive) and send it to
    the Exporter's Bootstrap object via the [`withdraw-gift` method](#withdraw-gift-method).

The specifics of constructing the `desc:handoff-receive` message are specified
in the [desc:handoff-receive](#desc-handoff-receive) section. Once constructed,
you MUST send the `desc:handoff-receive` to the Exporter's [`withdraw-gift` method](#withdraw-gift-method). The
promise created by sending the message SHOULD resolve to the deposited gift,
provided no error has occured during the handoff process.

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
