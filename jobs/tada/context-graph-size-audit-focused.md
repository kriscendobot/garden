Both changes are landed and verified. Writing the completion report.

## Completion report

**What I did**

1. **Extended `scripts/context-graph-size-audit.py`** with two repeatable, general scoping flags (default behavior unchanged when omitted):
   - `--exclude-root-glob <pattern>` — drops matching main2 roots from the seed set **and** prunes them from the walk entirely (they are never seeded and never reached through links). This was necessary because `designs/*.md` docs are linked from `CLAUDE.md`/`README.md`; dropping them only as seeds left them dominating the candidate list, defeating the maintainer's intent. Matches are also excluded from the main2 orphan list (they are out of scope, not orphaned).
   - `--exclude-journal-seed <path>` — drops a journal2 seed so the walk does not start from it. The journal orphan signal now scopes to whichever trees were actually seeded rather than the hardcoded `projects/` + `library/`.
   - The report intro, revision stamp, and orphan prose all self-describe the applied excludes.

2. **Extended the fixture test** (`scripts/jobs/test/context-graph-size-audit-test.sh`) with a `designs/` doc and a scoped invocation asserting the designs doc is pruned even when link-reachable, the dropped-seed trees leave the graph, and the orphan scope narrows. Test passes; default-run assertions updated for the new fixture doc.

3. **Ran the focused audit** with `--exclude-root-glob 'designs/*.md' --exclude-journal-seed 'projects/README.md'`, all other defaults intact.

4. **Landed the report** via `land-journal-edit.sh` (with `GARDEN_EDITABLE_TREES=reports`, same as the prior run) as a distinct companion, not overwriting the full-scope report.

**Results (focused run, main2 `ce552548d3fb`, journal2 `111c7aeb491a`)**
- main2 context library: **213** documents walked, **33** reorganization candidates (down from 271/66 full-scope — designs pruned).
- journal2 `library/`: 7968 walked, 266 candidates.
- journal2 `projects/`: 2 walked, 1 candidate (residual links from in-scope docs); the `entries/` and `periodicals/` trees, reachable only through the dropped projects seed, correctly left the graph.
- journal2 root: 1 walked, 1 candidate.
- **Total: 8184 documents walked, 301 candidates flagged.**

**Paths**
- Report: `journal/reports/context-graph-size-audit-focused-2026-08-13.md` (origin/journal2 commit `30ebf571ca`).
- URL: `https://github.com/kriscendobot/garden/blob/journal2/reports/context-graph-size-audit-focused-2026-08-13.md`
- Tool + test changes: pushed to main2 (commit `ce552548d3`).

**Follow-ups**: none required. Still a one-off run, not a schedule.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/context-graph-size-audit-focused.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 71 tokens (2412919 cached reads)
- Output: 22261 tokens
- Cost: $2.4251294999999997
- Wall-clock: 342s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
