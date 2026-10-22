**Viability: proceed.** PR #1537 is open, not superseded, and still needed, so the gauntlet can start. I spent no clean, panel, fix, CI-wait or un-draft budget.

**Deciding question:** Does the current `llm` branch, or any other PR, already provide paged `ls-tree` streaming (Phase 6) and parsing of sha256-format repositories (Phase 5) for `Git.filesystemAt`?

**Answer:** No. The PR has not been superseded, and the gaps it was opened to fill are still there.

**Evidence:**
- **PR state:** open and unmerged; a draft created 2026-10-22T17:20Z with no comments or reviews yet. The base is the pinned `llm-54d3d2a`, and the head is `fee2309e`.
- **Current base code:** I read `packages/git/src/native-git-backend.js` on `llm`. Its `ls-tree` parser still accepts only 40-hex OIDs (`[0-9a-f]{40}`), so a sha256 repository still fails with `Could not parse git ls-tree metadata`. It has no `streamLsTree`, and listings are still read whole through `readGitText(['ls-tree', …])`.
- **Design doc on `llm`:** `designs/endo-fs-from-git.md` still lists sha256-format repository detection (Phase 5) and paged listing (Phase 6) as deferred.
- **Newer base history:** `llm` is 2 commits ahead of `54d3d2a`. Neither touches `packages/exo-git`, `packages/git` or the design doc.
- **Other PRs:** a search for streamLsTree, sha256, filesystemAt and endo-fs-from-git turned up only #1510 (Phase 4, compose interop) and #807 (a docs reconciliation of the `tree(ref)` and `filesystemAt(ref)` naming). Neither covers Phase 5 or Phase 6, and #1537 explicitly avoids overlapping #1510. A code search for `streamLsTree` across the repo finds only the design doc.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1537-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (159247 cached reads)
- Output: 1645 tokens
- Cost: $0.3918294
- Wall-clock: 46s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
