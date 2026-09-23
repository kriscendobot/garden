PR #878 is merged. Merge commit `849f0438` on live trunk `llm`, base was `llm` (never a frozen snapshot), no open downstream PRs on the head branch.

## Completion report

**Job:** Finalize (curate → merge) endojs/endo-but-for-bots PR #878 — `feat(endor): endow WHATWG URL and URLSearchParams in npm archive compartments`

**Re-derived state on clean start:** PR was OPEN, un-drafted, based on live trunk `llm`, checks green, and carried a fresh `kriskowal` APPROVED review (2026-08-16T21:29:11Z). No prior attempt had merged it, so I drove it to completion.

**What I did:**
- Set up an isolated project worktree keyed to this job's base and synced it to the exact PR head (`cdd04fabff`).
- Ran the deterministic merge spine `ci-wait-merge.sh endojs/endo-but-for-bots 878`. It unfroze/verified the live base, rebased onto freshly-fetched `llm`, lease-pushed the rewrite (new head `6a3ce66b`), block-watched the fresh CI run to terminal green (26/26 checks, 0 failed), re-verified maintainer approval on the rebased head (`kriskowal`), and merged in-job.

**Outcome:**
- **MERGED** at 2026-08-16T22:06:30Z via a merge commit (`--merge` shape preserved): `849f0438`.
- Base at merge time: `llm` (live trunk, not a snapshot). ✓
- No open downstream PRs use the head branch as base; branch cleanup was safe.

**Follow-ups:** None. Merge gate genuinely satisfied — no `orchestration-failed` marker.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr878-conduct.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s) (2 unmetered)
- Input: 60 tokens (1711649 cached reads)
- Output: 14503 tokens
- Cost: $2.1805294999999996 (3 engagement(s) unpriced)
- Wall-clock: 2027s
- Model(s): kimi-k3 ×1, claude-opus-4-8 ×2

<!-- garden-usage-end -->
