---
title: §Unified-axis-scheme as the recommendation
source-slug: endo-but-for-bots--llm-designs-cli-store-verb-text-modes
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/cli-store-verb-text-modes.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/cli-store-verb-text-modes.md
total-lines: 446
ingest-cycle: 240
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-read-and-write
---

```
endo store [--blob|--text|--json|--bigint|--tree]    # representation
           [-p <file>|--stdin|--literal <s>]         # source
           [-n <name-path>]                          # destination
           [--as <agent>]
```

§Mutual-exclusion-of-flag-groups: §representation-flag-required-and-mutually-exclusive + §source-flag-required-and-mutually-exclusive. §The-flag-groups-IS-the-axes. §When-a-CLI-verb-has-multiple-axes, §each-axis-becomes-a-required-mutually-exclusive-flag-group + §the-flag-groups-name-the-axes-and-the-flags-name-the-positions-on-each-axis.

§Eleven-canonical-form-examples follow the scheme:

```
endo store --blob -p ./image.png -n photos/cat
endo store --text --literal "hello" -n greeting
endo store --text --stdin -n notes/meeting     # subsumes write-text
endo store --json --stdin -n inbound/payload
endo store --tree -p ./src -n project          # subsumes checkin
```

§Subsumes-old-verb annotations name the migration explicitly per row. §When-a-canonical-form-replaces-an-existing-verb, §the-canonical-form-MUST-annotate-the-subsumption-inline-with-a-comment + §the-reader-sees-which-old-verb-each-line-replaces.
