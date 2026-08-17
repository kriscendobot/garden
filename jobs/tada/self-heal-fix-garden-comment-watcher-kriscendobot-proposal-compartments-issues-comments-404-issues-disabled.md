## Completion report

**Job:** Fix `comment-source-gh.sh` crash-loop on Issues-disabled forks (repo-level `issues/comments` 404).

**Finding:** The required fix — both code and tests — was **already landed on `origin/main2`** before this attempt, by commits `544355d1` (degrade Issues-disabled repos to a per-PR walk), `cb00b99e` (recover pr-comment on Issues-disabled forks), and `d7cfcc68` (drop the duplicate per-PR enumeration). My worktree HEAD equals `origin/main2` (`d7cfcc6875`) with no diff on either target file, so there was nothing to commit or push.

**Verification I performed:**
- The landed code implements exactly the required behavior: on a definitive 404 from `repos/$repo/issues/comments` it authoritatively probes `repos/$repo.has_issues` (cached per tick via `repo_has_issues`/`repo_issues_disabled`), and only when `has_issues==false` sets `issues_disabled=1` and recovers `surface=pr-comment` per open PR via `repos/$repo/issues/<n>/comments` inside the existing section-3 open-PR walk — reusing `emit_pr_conversation_comments` for byte-identical classification. It reuses `_gh_api_stderr_is_transient` (no new ad-hoc string match), so a 5xx/rate-limit still freezes the cursor. A per-PR fallback failure still sets `fetch_failed`; a 404 with `has_issues=true` or an unreadable probe still freezes — LOST-FETCH invariant intact.
- Ran `scripts/jobs/test/comment-watcher-test.sh`: **334 passed, 0 failed**, including the new issues-disabled cases (IDIS, IDEN, ID1–ID4) covering exit-0-with-recovered-pr-comment, cursor advance, failed-fallback freeze, and the `has_issues:true`/transient-blip freeze regressions the job asked for.

**Operational follow-up (flagged to maintainer, not performed here):** I ran on **follower** host `endolin-garden`. The comment watchers are leader-only (`ExecCondition=is-main-host.sh`), so they're cleanly skipped here — no failing units on this host. The failing `garden-comment-watcher@*` units live on the **leader** `endolin-garden2`, whose deployed root is still behind main2 (`55d2c6411b`, no `issues_disabled`). Deploy + `systemctl --user reset-failed 'garden-comment-watcher@*'` + confirming the 11 `has_issues=false` forks tick clean is a leader-host, liaison-supervised **drained deploy** — outside a follower gardener's authority and never done via git in the deployed root. I sent the maintainer (via liaison) a message spelling out these remaining steps, the expected idempotent re-poll burst on first healthy tick, and the note that `minion.town` (`has_issues=true`) is a distinct cause not addressed by this change.

**Net:** Code deliverable complete and verified on main2; only the leader-host deploy/reset-failed operational step remains, owned by the deploy pipeline / liaison and surfaced to the maintainer.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-comment-watcher-kriscendobot-proposal-compartments-issues-comments-404-issues-disabled.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (824824 cached reads)
- Output: 9841 tokens
- Cost: $1.280729
- Wall-clock: 201s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
