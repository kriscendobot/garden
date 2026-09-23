Inbox empty. Work complete.

---

## Completion report: `harden-conductor-ci-wait-complete-merge`

**SHA:** `422170623b898ec55ec0dc95025b2201831bb2da` on `origin/main2` (deployed to the live tree by the watchman; verified present + executable).

### The bug
A conduct job that found a PR **approved + mergeable but CI pending** reported "waiting for CI" and **ended (moved to `tada`) without ever merging** — leaving the PR green-but-unmerged with nothing to finish it. It bit endo-but-for-bots #178 (→ `llm`) **twice**: two separate conduct jobs each waited-and-quit. Root cause: the conductor role treated "waiting for CI" as a terminal state and relied on "a later tick re-posts the merge job," which nothing guaranteed.

### Behavior change
"Waiting for CI" is now **non-terminal**. A merge dispatch must carry the merge to completion in the same job, or re-enqueue itself — it may never complete unmerged-while-pending.

### What changed
- **New deterministic spine `scripts/jobs/gardening/ci-wait-merge.sh`** — blocks on the `statusCheckRollup` (the source of truth) with a real timeout (`GARDEN_CI_DEADLINE_SECS`, default 90 min) + gentle backoff until CI is terminal, then **merges in the same invocation**. Exit codes are the contract: `0` merged, `2` already closed, `3` CI red (→ stall `ci red: needs shepherd`, never merges red), `4` watch timed out → **re-enqueue, still unmerged**, `1` merge blocked. It **verifies `state=MERGED`** before reporting and never fabricates a green/merge (jq-outage discipline). `GARDEN_GH` override seam for testing.
- **`roles/conductor/AGENT.md`** — rewrote step 4 (carry-to-completion, the auto-merge-unavailable path now block-watches instead of stalling-and-ending), added an operating norm ("waiting for CI is NOT terminal"), strengthened the definition of done ("never left in `tada` green-but-unmerged"), added a field note, bumped `updated:`. Explicitly hardened against the harness "background watch then re-invoke" pattern: an ended job never resumes if the re-invoke doesn't fire, so the merge is carried in-job or the job is re-enqueued.
- **`skills/pr-ci-watch/SKILL.md`** — field note pointing long merge-waits at the new spine rather than a bare per-tick loop that can end mid-wait.
- **`scripts/jobs/test/ci-wait-merge-test.sh`** — 12 assertions over all paths (block→merge on green, red→no-merge exit 3, never-terminal→timeout exit 4 with no merge, idempotent MERGED/CLOSED, no-false-merge-report, `--no-merge` probe). **All pass.**

### Verification
- `bash -n` + `shellcheck` clean on both new scripts (the helper carries only the SC1091/SC2034 advisories that the committed `pr-mergeable-gh.sh` baseline already has; the test has none).
- Test suite green against both the worktree copy and the **deployed** live-tree copy (12/12).
- Built in an isolated worktree off `origin/main2`, committed with explicit pathspecs, pushed `HEAD:main2`, deployed via a watchman fast-forward (live tree had no tracked edits), worktree torn down.

### Follow-ups
- None required. The helper is invoked on-demand by the conductor (a `claude -p` agent), so no systemd unit changes were needed. If a future gardening state-machine wants to call `ci-wait-merge.sh` directly from `garden-pr.sh`'s loop-decision step, the exit-code contract is ready for it.
