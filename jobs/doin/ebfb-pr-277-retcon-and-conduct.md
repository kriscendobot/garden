# PR #277 — retcon then conduct (merge); maintainer authorized: "ready to merge"
Repo: endojs/endo-but-for-bots (bot direct push; bot identity). **PR #277** —
*feat(daemon): EndoMount.followNameChanges live entry-name stream* —
https://github.com/endojs/endo-but-for-bots/pull/277 — base `llm`, **MERGEABLE/CLEAN, all 24 checks green**.
**Maintainer directive (kriskowal, 2026-07-01T05:20Z, comment 4850500173):**
> Please retcon and conduct. This is ready to merge.
This is the explicit merge authorization. Run the compound in order:
1. **Retcon** (`skills/retcon`): reset the branch + restage cleanly — per-package commits, a **separate
   `chore: Update yarn.lock`** commit, implementation+tests combined, **net diff invariant** (tree
   identical to pre-retcon). Force-push-with-lease.
2. **Conduct** (conductor role): **merge** the PR — do **NOT** name the merge method (the conductor's
   canonical norm chooses it) — after the retcon is pushed and CI is green on the rewritten branch.
**After merge:** post a top-level **summary comment** on #277 (merged SHA + what the retcon restructured
+ CI/verification). Bot fork; no upstream contact.

---
claim:
  host: endolinbot2
  gardener: 13
  claimed_at: 2026-07-01T16:52:11Z
