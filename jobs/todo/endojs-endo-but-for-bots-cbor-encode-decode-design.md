---
tier: mentor
role: designer
fallback-tier: minion
dispatch: automatic
---

# Design follow-up: split @endo/cbor encode and decode entry points

Prepare a self-contained design in the project for a follow-up refactor that provides `@endo/cbor/encode` and `@endo/cbor/decode` entry points. The design must ensure decoding consumers do not retain encoding machinery and encoding consumers do not retain decoding machinery.

Originating approved review: https://github.com/endojs/endo-but-for-bots/pull/885#pullrequestreview-4813762886

This is a design-stage follow-up. Do not modify PR 885 as part of this job. Follow the designer role requirements, including opening a draft design PR on the configured roadmap branch.
