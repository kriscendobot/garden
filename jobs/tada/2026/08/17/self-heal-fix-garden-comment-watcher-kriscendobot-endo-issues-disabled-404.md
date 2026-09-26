The work is complete and durably landed. Here is my report.

---

**Job: self-heal fix — comment-watcher Issues-disabled 404 crash-loop (kriscendobot/endo)**

**What I did**

Landed an ISSUES-DISABLED degrade in `scripts/jobs/handlers/comment-source-gh.sh`, sibling to the existing REPO-GONE degrade, fixing the permanent restart loop that hit `kriscendobot/endo` and 11 other forks whose `has_issues:false` makes `GET /repos/<repo>/issues/comments` 404 forever while the repo itself answers (so REPO-GONE never fires and the LOST-FETCH invariant exited 1 every tick).

**What changed** (commit `544355d714` on `main2`, 3 files, +214/−43):

- **`comment-source-gh.sh`** — On surface 1's *definitive* (non-transient) 404, probe `repos/<repo>` for `.has_issues` once; only on `false` enter `issues_disabled` mode. In section 3's activity-bounded open-PR walk, enumerate each PR's conversation comments from the per-PR `/issues/<n>/comments` endpoint (verified 200 with Issues disabled) and emit the same `pr-comment` rows — coverage preserved, not blanked. A failed per-PR call calls `note_fetch_failure` and freezes (LOST-FETCH intact). No `alert_maintainer` (a healthy, expected fork config). Probe runs only on the already-failed path.
- **`comment-watcher.sh`** — documented the jq-blindness self-probe's known limitation on Issues-disabled repos (its repo-wide aggregate 404s → inconclusive; benign, since jq-blindness is host-wide and any co-watched Issues-enabled repo still exercises the pipe). Per the spec's "or note the limitation in a comment" option.
- **`comment-watcher-test.sh`** — ID test family: ID1 (404+`has_issues:false` → exit 0, `pr-comment` rows, cursor advances), ID2 (404+`has_issues:true` → freeze/exit 1), ID3 (transient 5xx → freeze, never probes `has_issues`), and **ID4 which I added** (per-PR call fails → freeze/exit 1, no silent partial — spec case c). **325 passed, 0 failed.**

**Notable process detail**: a sibling self-heal job had written a complete version of the same source+test edit **directly into the deployed root** `/home/kris/garden` as uncommitted changes (non-durable; the next deploy discards them). I rescued that sound work into this durable commit via plain `cp` into my worktree, verified syntax and tests, and added the two missing pieces (watcher note + ID4). All git ran only in my per-job worktree.

**Follow-ups** (messaged to the maintainer): (1) a gardener editing the deployed root directly is a bug worth investigating — stray uncommitted edits remain in `/home/kris/garden` and will be clobbered on next deploy; (2) the ~7 sibling `*-issues-comments-404-issues-disabled` jobs are now redundant (the fix is generic across all 12 repos) — consider draining or letting them no-op rather than racing duplicate pushes.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-comment-watcher-kriscendobot-endo-issues-disabled-404.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 69 tokens (3277483 cached reads)
- Output: 27182 tokens
- Cost: $3.3443235000000002
- Wall-clock: 505s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
