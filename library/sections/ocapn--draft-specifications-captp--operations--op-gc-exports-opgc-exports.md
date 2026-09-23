---
title: "[`op:gc-exports`](#opgc-exports)"
source: "draft-specifications/CapTP Specification.md"
source_repo: kriscendobot/ocapn
source_commit: 8704f69e01f93701de8bc5eb4bb22b9927a2665a
source_date: 2026-03-12
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn, captp]
status: current
notes: 9 H2 ops consolidated into one section. op:start-session, op:deliver, op:abort, op:listen, op:get, op:index, op:untag, op:gc-exports, op:gc-answers. Each is independently looked-up-able by the H2 anchor within the consolidated body.
parent: ocapn--draft-specifications-captp--operations
---

When a reference is given out over CapTP, the reference must be kept
valid until the other party within a session is done with it. This is
achieved by reference counting the object with respect to how many
times a reference has been sent. Each time a reference is sent, the
count MUST be incremented (the first time it is sent, the reference
count should be set to 1).

When the remote session becomes aware that it no longer needs a set of
references, it MUST send an `op:gc-exports` message with two lists: one list
containing the `export-pos` of each reference it no longer needs and another
list containing the corresponding `wire-delta` that reflects the number of
times the reference has been received since the last `op:gc-exports` message
for that reference was sent.

When receiving an `op:gc-exports` message, the reference count for each 
`answer-pos` is decremented by its corresponding `wire-delta`. When a reference
count reaches 0, the corresponding object can be garbage collected.


The message looks like:

```text
<op:gc-exports export-pos-list   ; list of positive integers
               wire-delta-list>  ; list of positive integers
```

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
