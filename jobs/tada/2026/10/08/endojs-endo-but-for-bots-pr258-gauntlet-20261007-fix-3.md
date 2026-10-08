## Fix round 3: endojs/endo-but-for-bots PR #258

The panel's must-fix items are applied and pushed, and CI is green on the new head `91f69ecd6a`: all 16 checks pass, including `test-ocapn-guile-interop` and `zizmor`.

**PR body (the binding must-fix, rewritten with `gh pr edit`):**
- **Template headings:** added the three missing sections, Documentation, Compatibility and Upgrade Considerations. The body now follows all seven template headings in order.
- **Removed paragraph:** dropped the paragraph apologizing for the out-of-date first commit message (integrator and pruner).
- **New paragraphs:**
  - why the cache snapshots the whole store instead of using `guix archive` export/import (decomplector);
  - that the package list is now defined once;
  - that the `ci.yml` pin-comment edit is an unrelated change in its own commit.
- **Security section:** now names the new `actions: write` permission and says what makes a restored cache trustworthy.

**Workflow fixes (follow-up commits `764141d005` and `91f69ecd6a`):**
- **A bad cache entry now repairs itself** (corner-prober must-fix-loop; assessor). Before, an empty or corrupt archive counted as a miss but was never replaced, so it came back on every run. Now the extract step reports `usable=true` only after a successful restore. On a bad hit it deletes the entry with `gh cache delete`, and the snapshot step runs whenever `usable` is not true, so the same key gets saved again.
  - This needs a new job-level `actions: write` permission.
  - On fork PRs the token is read-only, so the delete fails, a warning is logged, and the job carries on.
- **One package list:** the `GUIX_GUILE_PACKAGES` env var now feeds both the snapshot step and the Guile host step (integrator). The four `resolve` calls still name their packages one by one.
- **No repo-local PR numbers in comments:** `#82`/`#255` became a plain description of the earlier iterations, since this file is meant to be ferried to `endojs/endo`. I also dropped the "July run" story from a comment.
- **Clearer comments and warnings:** a comment by the `zstd -t` check now says it catches corruption, not tampering, and why the cache is trusted. The warning for a snapshot over the size cap now says every run on that key will redo and discard the snapshot.
- **zizmor fix:** my first push turned `zizmor` red because the job permissions lacked inline comments. The second commit adds them, matching the other workflows in the repo.
- **actionlint:** reports no new problems; the 5 shellcheck notes left are all in the existing file.

**Not done:** the integrator's should-fix to reset and regroup the commits into one `ci(ocapn-guile-interop):` commit plus the `ci:` commit. This stage pushes follow-up commits only, so a retcon could handle that before the ferry.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr258-gauntlet-20261007-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1599501 cached reads)
- Output: 11763 tokens
- Cost: $1.1652322
- Wall-clock: 1134s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
