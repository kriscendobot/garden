---
title: "[Third Party Handoffs](#third-party-handoffs)"
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

Third party handoffs are used when a message that is sent within a CapTP session
contains a reference to an object that has been imported from a different CapTP
session. This ability to include remote references to objects is a crucial part
of CapTP as it enables objects to use any references they hold in any context.

The third party handoffs specified here ensure this can be done in a secure
fashion, even if the messages are viewed by a malicious actor.

Third party handoffs define three roles:

- **Gifter**: The peer sharing their [Reference][Model-Reference].
- **Receiver**: The peer the [Reference][Model-Reference] is being shared with.
- **Exporter**: The peer exporting the [Reference][Model-Reference].

These three peers imply three sessions connecting them:

- **Gifter-Exporter**
- **Gifter-Receiver**
- **Exporter-Receiver**

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
