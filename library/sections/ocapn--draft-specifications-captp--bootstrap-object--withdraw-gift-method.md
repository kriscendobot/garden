---
title: "`withdraw-gift` Method"
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

This method is used to send the [`desc:handoff-receive`](#desc-handoff-receive)
in order to receive a gift. It has one argument:

- The `desc:handoff-receive`

This should have been sent with the [`op:deliver`](#op-deliver) operation, the response the
bootstrap object should give is the gift which was (or will be) deposited.

Here is an example of how to use this method:

```text
<op:deliver <desc:export 0>           ; Remote bootstrap object
            [withdraw-gift            ; Argument 1: Symbol "withdraw-gift"
             <desc:handoff-receive>]  ; Argument 2: sig:envelope containing desc:handoff-receive
            1                         ; Answer position: Non-negative integer (>=0)
            <desc:import-object 3>>   ; The object exported (by us) at position 3, should receive the gift.
```

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
