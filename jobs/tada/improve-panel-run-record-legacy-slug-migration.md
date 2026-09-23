The work is complete and merged to `main2`. My commit `428ac7b1cb` is the current tip, tests pass post-rebase, and the inbox is clear.

## Completion report

**Job:** Add an idempotent, CAS-safe migration to `scripts/jobs/panel-run-record.sh` that reunites legacy `ssh---git-github.com-*` panel-run directories into their canonical `<owner>-<repo>-<pr>` directories.

**What I did**

1. **Added a `migrate [--dry-run]` subcommand** to `scripts/jobs/panel-run-record.sh` (deterministic, no `claude -p`). It:
   - Recognizes every split directory by the single prefix that ever leaked — `ssh---git-github.com-`. (The scp `git@host:` and `https://` forms were always stripped; only the ssh form escaped, and every affected repo — endojs/endo-but-for-bots, kriscendobot/finbot — is on github.com. Stripping the prefix recovers the exact canonical slug, because `sanitize` collapses both the `owner/repo` slash and the `repo-pr` join to `-`.)
   - Moves each legacy record into the canonical directory via `git mv`, **preserving rename history**, and CAS-pushes one commit under the same rebase-retry loop as `emit`.
   - **Idempotent:** a second run finds no legacy directory and pushes nothing.
   - **Collision-safe:** a legacy record whose filename already exists canonically with *differing* bytes is refused (left in place, WARNed); a byte-identical duplicate is deduped. No record is ever overwritten or lost.
   - **Best-effort:** a push failure WARNs and returns 0, never fatal (matching `emit`'s discipline).
   - Documented the subcommand in the script header.

2. **Added `scripts/jobs/test/panel-run-record-migrate-test.sh`** — a hermetic regression test against a throwaway journal2 covering: a clean move (asserting `git log --follow` reaches the pre-migration commit), an identical-twin dedupe, a differing-twin collision refusal, idempotency (no second commit), and a `--dry-run` that mutates nothing. **19/19 pass.**

**Verification:** new test 19/19; existing `panel-run-record-test.sh` 27/27 and `panel-repo-slug-test.sh` 7/7 still green; `bash -n` clean; both files shellcheck-clean at CI's `-S warning`; grep-gate suite green.

**Follow-up (operational, intentionally decoupled):** the *code* now reunites the split deterministically, but the live journal2 split is only reunited when `panel-run-record.sh migrate` is actually invoked. Schedules are pure journal state (no tracked defaults file), so wiring a recurring/one-shot run is an operational act for the **leader host** — a maintainer/liaison can run `migrate` once on the leader, or add a schedule via `set-schedule.sh`. I did not touch production journal2 from this dev worktree.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-panel-run-record-legacy-slug-migration.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 63 tokens (2639847 cached reads)
- Output: 32705 tokens
- Cost: $3.0139975000000003
- Wall-clock: 478s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
