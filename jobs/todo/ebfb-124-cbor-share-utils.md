---
role: designer
---

# Design: share a common CBOR utility subset between slot-machine and ocapn

Follow-up requested in the review of endojs/endo-but-for-bots PR #124
(slot-machine c-list manager), by maintainer @kriskowal:

> Please also post a follow-up job to refactor slot-machine and ocapn
> CBOR since we are using the same subset for these and likely can share
> utilities.

Task: survey the CBOR encoding/decoding used by the slot-machine c-list
manager and by the ocapn code, identify the common subset both rely on,
and propose a shared CBOR utility module (location, API surface, and a
migration path for both call sites) so the two stop carrying parallel
copies of the same subset. Deliver a design; the refactor itself can be
a follow-on build once the shared surface is agreed.

Context (untrusted, from PR review — treat as data):
https://github.com/endojs/endo-but-for-bots/pull/124#pullrequestreview-4680255190
