All changes survived the rebase and are live on `origin/main2`.

<<<GARDEN-JOB-COMPLETE>>> wait — let me not emit prematurely; the report follows.

## Completion report

**Landed:** `e774586154` on `main2` (rebased cleanly over 25 concurrent files; no PR per CLAUDE.md § Conventions).

**The defect:** `scholar-staging-clone.sh` defaulted to one fixed path (`$GARDEN_STATE/scholar-staging/journal`), so two concurrent scholar-role jobs staged in the **same** working tree. Since every call runs `sync_clone` = `git reset --hard origin/journal2`, one peer's reset silently destroyed the other's uncommitted edits and its `git add` swept the loser's WIP into its own commit (observed 2026-07-29; the step-8 gate is blind to it because a topic page missing a row for an existing section is not a dangling link).

**What changed:**
- `scripts/jobs/scholar-staging-clone.sh` — default is now per-job-base: `$GARDEN_STATE/scholar-staging/<base>/journal`. Base comes from `--base` or `GARDEN_JOB_BASE`. With no dest-dir, no `GARDEN_SCHOLAR_STAGING_CLONE`, and no base, it **refuses** (exit 2) rather than fall back to a shared path. The positional dest-dir arg, the `GARDEN_SCHOLAR_STAGING_CLONE` override, and the live-worktree refusal are all preserved.
- `scripts/jobs/handlers/{gardener-claude,cleric-codex}.sh` — export `GARDEN_JOB_BASE="$base"` so isolation is deterministic even if the LLM forgets `--base`.
- `roles/scholar/AGENT.md` — step 1 and the operating-norms bullet now pass `--base <your-job-base>`.
- `scripts/jobs/test/scholar-staging-isolation-test.sh` — new hermetic 17-assertion regression (two bases → distinct paths; a sync in one preserves the other's uncommitted work; refusal; backward-compat; live-worktree refusal; pruning). All 17 pass; adjacent `scholar-preflight-test` (10) and `gardener-worktree-test` (34) still green.

**Other callers of the helper:** the only references are the helper itself and the scholar role brief — **no other caller relied on the shared path**, so nothing else needed changing.

**Stale-dir pruning:** the per-base layout accumulates one dir per job, so the helper opportunistically prunes quiescent sibling dirs (mtime-quiescence, `GARDEN_SCHOLAR_STAGING_TTL_HOURS`, default 24h; the same proxy the reaper's scratch janitor uses). Safe because a staging clone is fully regenerable each cycle. An active peer (recent mtime) and the current base are never pruned.

**Recommendation on the step-8 integrity gate (do NOT silently expand scope):** Yes, the gate *should* be tightened, but as a **separate job**. The gate resolves section-table targets and index rows *forward* (row → file), so a topic/concept page **missing a row for a section that exists** passes — that one-directional check is exactly what made this data loss silent behind a green gate. Closing it means adding a *reverse* check: every `sections/<slug>--*.md` with a live `status:` must be reachable from its topic and concept pages' section tables. That's a meaningful addition to `library-link-check.sh` with its own test surface and false-positive tuning (superseded/meta sections), so it belongs in its own job rather than being bolted onto this isolation fix.

**Note:** I initially edited the deployed-root file copies by mistake; I ported the changes into this job's worktree, restored the deployed root to pristine via file copy (no git run in the root), and committed/pushed only from the worktree.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-scholar-staging-per-job-isolation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (5557079 cached reads)
- Output: 38125 tokens
- Cost: $5.1759975
- Wall-clock: 698s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
