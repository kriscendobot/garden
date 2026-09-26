PR #761 is verified: OPEN, DRAFT, base `master-3f601bc`, +105/-12 across 3 files — exactly matching the original merge's net diff. This job mutated only the project fork (branches + PR); no garden `main2` changes to commit.

---

## Completion report

**Reconstructed endojs/endo-but-for-bots#720** ("fix(patterns): preserve literal inference in compound matchers") as a fresh DRAFT PR: **endojs/endo-but-for-bots#761**.

**What I did:**
- Recovered the diff from the errant merge commit `91c671885` (parents: pre-merge master `3f601bc5f3`, deleted PR head `bd8cc6ff48`).
- **Key finding:** unlike the sibling reconstructions in this batch (#758/#757/#589), #720's change is **still present in current fork `master`** — it was merged only 3 days ago and hasn't been dropped by a re-mirror yet. A PR based off current master would therefore have had an **empty diff**. I followed the established `frozen-base-branch` convention used by the siblings: cut a frozen snapshot of master at the pre-merge commit (`master-3f601bc` → `3f601bc5f3`) so the PR diff isolates exactly the reconstructed change.
- Reset the reconstruct branch to the frozen base, cherry-picked `bd8cc6ff48`, and re-authored a single clean commit under the Kriscendo Bot identity with a provenance-prefixed message.
- Pushed frozen base `master-3f601bc` and head `reconstruct/ebfb-pr720-patterns-literal-inference` to the fork.
- Opened PR #761: `--draft`, base `master-3f601bc`, with a provenance body explaining the errant-master-merge, the re-mirror risk, the invisible-upstream status (`#645` is intra-fork), and links to the original PR #720 + merge commit `91c671885`.

**Faithfulness (verified):** reconstructed tree is byte-identical to original head `bd8cc6ff48` (`git diff` empty); the patch against the frozen base is identical to the original merge's net diff (`diff` of the two patches: identical). No adaptation/conflict resolution needed — clean apply. Final PR: 3 files, +105/-12, matching the original exactly.

**Follow-ups:**
- PR #761 is DRAFT pending the maintainer's ferry-to-`endojs/endo`-or-close decision.
- Note for the maintainer: because #720's change is *currently still in master*, if master is re-mirrored before this PR is actioned, the frozen base preserves the change and keeps the diff meaningful — but the live master will lose it at that point, which is the whole reason for surfacing it.

New PR: https://github.com/endojs/endo-but-for-bots/pull/761
