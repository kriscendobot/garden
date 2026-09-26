PR #1071 is MERGED via merge commit `ff6047fc` onto the live `llm` trunk. No downstream PRs depend on its head branch. Job complete.

---

**Completion report**

Finalized (curated → merged) endojs/endo-but-for-bots PR #1071 — "design(ocapn): one hint per transport protocol".

**Guards re-verified before merge:**
- **Repo:** endojs/endo-but-for-bots (bot repo). Base `llm` (live trunk, not a frozen snapshot — no unfreeze needed; no `master` involvement).
- **Approval:** kriskowal (MEMBER) APPROVED "Conduct." at 2026-08-31T03:29:30Z on commit `733f3f5a` — the exact PR head. The earlier CHANGES_REQUESTED (2026-08-28, on old commit `f91e7004`) was superseded by this later approval; not dismissed.
- **State/CI:** OPEN, MERGEABLE, mergeStateStatus CLEAN; all 5 status checks COMPLETED/SUCCESS on the approved head.

**Actions taken:**
1. Set up isolated project worktree keyed to this job's base.
2. Un-drafted the PR (`gh pr ready` — it was still a draft).
3. Ran the deterministic merge spine `ci-wait-merge.sh endojs/endo-but-for-bots 1071` from the worktree: confirmed CI green, confirmed non-stale maintainer approval, and merged with `--merge` (merge commit shape).

**Result:** state=MERGED at 2026-08-31T03:44:25Z, merge commit `ff6047fc1272cc788ad9fe92138dc0d63ff74bf9` onto `llm`.

**Cleanup / downstream:** No open PR uses `design/ocapn-single-hint-per-transport` as its base, so branch deletion posed no auto-close hazard. No downstream weave/shepherd follow-ups unblocked. No follow-ups needed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1071-conduct.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (443048 cached reads)
- Output: 3625 tokens
- Cost: $0.8465119999999999
- Wall-clock: 95s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
