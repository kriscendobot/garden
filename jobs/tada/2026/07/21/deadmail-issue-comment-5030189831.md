Inbox is empty. Work complete.

## Completion report

**Job:** Dead-lettered message pickup — a new comment on kriskowal/garden issue #59 was addressed to `issue-kriskowal-garden-59`, which had already completed. I picked up its intent: fold the maintainer's comment into the work and reply on the issue thread.

**Context:** Issue #59 is about durable persistent stores in the endo pet daemon (endojs/endo-but-for-bots). The arc: a proposed daemon-native `MapStore` (design PR #809) → kriskowal challenged it (why not a directory + `storeValue`?) → the prior doer conceded and proposed reorienting to a directory-backed facade, keeping an escape hatch. kriskowal's new comment **overrules the facade reorientation**, favoring **direct implementation** of the full collection family (map, set, weakset, sortedset, sortedmap) with range queries over arbitrary passable keys.

**What I did:**
1. **Replied on the issue thread** (https://github.com/kriskowal/garden/issues/59#issuecomment-5030236444, as kriscendobot). Accepted the direction and reconciled it honestly with the prior facade proposal: kriskowal's targets trip exactly the escape hatch the reorientation named — weak keys need real weak-GC semantics a string-name directory can't express, and sorted/range queries need passable **rank order** a name lookup has no notion of. Laid out the concrete native plan (strong `MapStore`/`SetStore`, weak variants with no retention edge, sorted variants using `@endo/marshal` `makeEncodePassable` rank-order encoding as an indexed SQLite column for O(log n) range scans), incremental phasing with restart-persistence tests. Used fully-qualified GitHub URLs per convention. Did **not** close the issue.
2. **Posted a follow-on design-revision job** `design-endo-daemon-store-family-pr809` to broaden PR #809's design doc from "scalar MapStore" to the full family, carrying the ISSUE NOTE verbatim so the intent lands as real work.

**Changed:** one issue comment on kriskowal/garden#59; one new job on the board. No garden repo or project source edits (this was a communication + dispatch job, nothing to commit).

**Follow-ups:** The existing board job `endojs-endo-but-for-bots-pr809-review-581b1021` reviews the current (pre-rescope) design; its substrate findings likely still apply, but its reviewer is not aware the scope is expanding. The new `design-endo-daemon-store-family-pr809` job will supersede the design's scope. Implementation build jobs should follow once the revised design settles.
