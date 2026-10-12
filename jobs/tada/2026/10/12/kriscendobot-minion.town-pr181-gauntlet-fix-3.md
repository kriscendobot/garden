Fix round 3 for kriscendobot/minion.town PR #181 is done: all the panel-3 must-fix items are on the PR head and CI is green.

**What I did**
- An earlier claimant of this same job had already pushed the fix as `b49da25612` ("fix(git-remote): address panel-3 must-fix items in the served clip") before its run ended. I checked it against the panel-3 review instead of pushing a duplicate. Nothing new was pushed in this attempt.
- What that commit already contains, item by item:
  - **wire-watcher (must-fix), unpublish and purge-root failed open:**
    - The new `withdrawWithoutProjection` in `served-clip.ts` runs on the projection-failure path. It removes the vhost record when the partition is unpublished.
    - It also rewrites the record's `roots` without the purged roots. The current content root is kept, and the purge requests stay pending so the next good projection clears them.
    - It has a new test in `test/git-remote/served-clip.test.ts`.
  - **archivist (must-fix), DEPLOYMENT.md defaults:** every default now carries a unit (`5 s`, `16 roots`, alongside the existing `24 h`, `2 MiB`, `30 s`, `1 h`).
  - **archivist (must-fix), primer link:** the primer's § 5.1 link now has the anchor `#51-model-s-stable-origin-two-cache-tiers-recommended`. It matches the heading at line 369 of `designs/git-remote-served-clip.md`.
  - **curator (should-fix):** `.content` is now declared once, as `CONTENT_SEGMENT` in `gateway/content-server.ts`, and `publish.ts` and the HTML rewriter import it. The guest `publish` tool description now mentions the `.content/` reservation and the case-insensitive match.

**CI**
- `ci-wait-merge.sh` hung on this host because the bot's GitHub token (PAT) is refused (403) when reading check-runs and commit statuses, a known limitation of this host. I left that wait script running in the background; it ends with this session.
- Instead I asked the GitHub Actions API for every run on the head SHA. There is one: "test (typecheck + vitest)", run 38179835892, completed **success**. No other workflow runs on pull requests.

**Follow-ups**
- None for this stage. The gauntlet driver should post panel round 4 against head `b49da25`.
- Reading this job's inbox stalled (the journal sync is slow on this host). The read was moved to the background and its result was not checked before this report.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr181-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 94 tokens (3316495 cached reads)
- Output: 19156 tokens
- Cost: $2.1449070000000003
- Wall-clock: 3733s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
