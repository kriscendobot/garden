Inbox empty. Both bugs are fixed, verified against the real repro, and shipped.

## Completion report

**Job:** Fix two compounding first-triage bugs in `scripts/jobs/handlers/triager-claude.sh` that killed `garden-triager@<slug>` before it logged anything on the first triage of any repo (empty cursor).

**State found:** A peer had already landed a *partial/divergent* fix on main2 (commits `d486643cf`, `35db0c0a7`): Bug 1 was addressed with an `if/else` using `-1 "$new"` (only the tip commit on cold start), and Bug 2 was still papered over with `| head -400 || true` — exactly the `|| true` the job forbids for masking genuine git failures. A regression test already existed.

**What I changed** (`c14da9355`, pushed to main2):
- **Bug 1 (exit 128, empty revision):** Collapsed the if/else back to the single expansion `"${old:+$old..}$new"`, mirroring the `range=` line. Cold start now logs full history down to `$new` (capped); incremental logs `$old..$new`. This is the job's prescribed form and a richer cold-start summary than the tip-only `-1 $new`.
- **Bug 2 (exit 141, SIGPIPE):** Replaced `| head -400 || true` with `| sed -n '1,400p'`. sed consumes the whole stream, so git reaches a clean exit and no SIGPIPE hits pipefail. Also dropped the git `2>/dev/null`, so a *genuine* git failure now aborts the handler **and** leaves its stderr as a signature rather than being masked.
- Updated the test header comment to describe the sed cap instead of the retired `|| true` approach.

**Verification:**
- Regression test `triager-claude-handler-test.sh`: all 7 assertions PASS (empty-old cold start, >400-line SIGPIPE path, normal range).
- Against the **real** `kriscendobot-minion.town.git` (811-line history), cursor `<none>`: handler exits 0 and logs `posted N job(s)`; the `git log … | sed` pipeline caps at 400 lines with every stage exiting 0 (git=0, sed=0) — no SIGPIPE, no empty-revision.
- Incremental path confirmed to still expand to `$old..$new` and yield only the delta.

**Optional hardening (already done):** Capturing claude's stdout+stderr on failure so a future crash leaves a diagnostic signature was landed in earlier commits (`a8b87df68`, `921b8444f`) plus the bounded retry loop — no further work needed.

**Follow-ups:** None. Inbox drained (empty).
