# Verify @endo/cancel (#345) exists; reconduct if missing (endo-but-for-bots #507)

Maintainer directive (kriskowal, 2026-06-24T22:52Z) on PR #507:
"I submit #345 as counter-factual. The cancel package should exist. If it does not,
it needs to be reconducted." —
https://github.com/endojs/endo-but-for-bots/pull/507#issuecomment-4794311329

Posted by the liaison (the comment-watcher classified it non-actionable and dropped
it during the jq outage; reactji-acknowledged 👀 by kriscendobot). Wear the **fixer**
role (escalate to conductor if a merge is needed). Repo: `endojs/endo-but-for-bots`.

## Task

Establish whether the **`@endo/cancel`** package (introduced by **#345**) actually
exists on the relevant branch(es), and **reconduct it if it does not**:
1. Verify #345's merge state and whether `@endo/cancel` (`packages/cancel/` or the
   package the PR adds) is present on the branches that need it — note that #513's
   fixer flagged `@endo/cancel` is NOT on #513's base (`llm-44e3b17`); #345 merged
   onto `llm-5b1361d`. So the package may be missing from some `llm-*` bases.
2. If `@endo/cancel` is missing where it should be (the cancel package "should
   exist" per the maintainer), **reconduct #345** — re-merge / forward-port it onto
   the base(s) that need it so the package exists, per the conductor's merge
   discipline. If #345 is already merged and the package exists everywhere expected,
   report that (the directive is satisfied) and identify why #513 saw it missing
   (base divergence) so the bases can be converged.
3. Reply on #507 with the finding (cancel package present, or reconducted), and on
   #513 if the base-convergence affects it.

## Definition of done

A clear determination of whether `@endo/cancel`/#345 exists where needed, the
package reconducted onto any base missing it (or a report that it is already
present), and #507 answered. Report the state and any merge performed. If the
reconduct requires a maintainer decision (which base, conflicts), surface it rather
than guessing.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 29
  claimed_at: 2026-06-25T14:45:35Z
