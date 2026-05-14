---
title: Preparing for the Non-trapping Integrity Trait (overview)
source: packages/ses/docs/preparing-for-stabilize.md
source_repo: endojs/endo
source_commit: 07ff084c87af4e567f6bf4f5e331742be94b6587
source_date: 2025-01-18
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript, exo, persistence]
status: current
---

> Abstract: Mark Miller's note on the upcoming non-trapping integrity trait. Background: TC39 is adding a new ES feature where certain proxy traps and passable invariants behave differently to support stronger integrity guarantees. This document tells SES users how to prepare.

# Preparing for the Non-trapping Integrity Trait

The [Stabilize proposal](https://github.com/tc39/proposal-stabilize) is currently at stage 1 of the tc39 process. It proposes three distinct integrity traits whose current placeholder names are:
- ***fixed***: would mitigate the return-override mistake by preventing objects with this trait from being stamped with new class-private-fields.
- ***overridable***: would mitigate the assignment-override mistake by enabling non-writable properties inherited from an object with this trait to be overridden by property assignment on an inheriting object.
- ***non-trapping***: would mitigate proxy-based reentrancy hazards by having a proxy whose target carries this trait never trap to its handler, but rather just perform the default action directly on this non-trapping target.

Draft PR [feat(non-trapping-shim): shim of the non-trapping integrity trait #2673](https://github.com/endojs/endo/pull/2673) is a shim for this non-trapping integrity trait. The names it introduces are placeholders, since the bikeshedding process for these names has not yet concluded.

Draft PR [feat(ses,pass-style): use non-trapping integrity trait for safety #2675](https://github.com/endojs/endo/pull/2675) uses this support for the non-trapping integity trait to mitigate reentrancy attacks from hardened objects, expecially passable copy-data objects like copyLists, copyRecords, and taggeds. To do so, it makes two fundamental changes:
- Where `harden` made the object at every step frozen, that PR changes `harden` to also make those objects non-trapping.
- Where `passStyleOf` checked that objects are frozen, that PR changes `passStyleOf` to also check that those objects are non-trapping.


Source: [packages/ses/docs/preparing-for-stabilize.md](https://github.com/endojs/endo/blob/07ff084c87af4e567f6bf4f5e331742be94b6587/packages/ses/docs/preparing-for-stabilize.md) at commit `07ff084c`.
