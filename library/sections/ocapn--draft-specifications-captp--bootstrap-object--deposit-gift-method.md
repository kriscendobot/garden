---
title: "`deposit-gift` Method"
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
parent: ocapn--draft-specifications-captp--bootstrap-object
---

The deposit gift method is used in conjunction with sending a [Third Party Handoff](#third-party-handoffs).
This method is used to deposit a gift which has been sent to the bootstrap object. It has two arguments:

1.  A gift ID that is bytearray of 32 generated random bytes.
2.  A [Reference][Model-Reference] which has been exported
    within the given CapTP session.

This should have been sent with the [`op:deliver`](#op-deliver) operation
with no reponse requested.

Here is an example of how to use this method:

```text
<op:deliver <desc:export 0>            ; Remote bootstrap object
            ['deposit-gift             ; Argument 1: Symbol "deposit-gift"
             gift-id                   ; Argument 2: Unique gift ID (bytearray)
             <desc:import-object 5>]   ; Argument 3: object being shared via handoff
             false                     ; No answer promise desired
             false>                    ; No result desired
```

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
