Pushed cleanly to `main2` on the first attempt.

## Completion report

**Job:** Fix the `triager-claude.sh` cold-start crash where an empty journal cursor produced an empty-string revision argument to `git log`.

**What I found:** The file had already received partial hardening in recent commits (the `|| true`, `2>/dev/null`, and stderr/stdout capture for diagnosability). But the root cause remained at line 36: the `"${old:+$old..$new}"` expansion collapses to the empty string when `old=""`, so `git log --no-merges --stat ""` fails with `fatal: ambiguous argument ''` (exit 128). With the `|| true` now present, this no longer crashes the handler — but it silently degrades **every first triage of a repo to an empty change summary**, so the triager sees no changes on cold start.

**What I changed** (`scripts/jobs/handlers/triager-claude.sh`):
- Replaced the single `"${old:+$old..$new}"` git-log call with an explicit `if [ -n "$old" ]` branch: diff `"$old..$new"` when a cursor exists, else describe just the new tip with `-1 "$new"` — never passing an empty argument.
- Kept the `2>/dev/null | head -400 || true` hardening on both branches (SIGPIPE truncation from `head` and any genuine git failure degrade to empty `$changes`, which the prompt tolerates).
- Rewrote the preceding comment to document the empty-revision cause rather than only the SIGPIPE case.

**Verification:**
- Reproduced deterministically against `repos/kriscendobot-minion.town.git`: the old expansion → `fatal: ambiguous argument ''`, exit 128; the new cold-start path (`-1 "$new"`) → a real change summary, exit 0.
- `bash -n` clean; `shellcheck` shows only pre-existing, unrelated SC1091/SC2034 notices.
- `scripts/jobs/test/triager-test.sh`: 21 passed, 0 failed (this suite uses a stub handler, so it confirms no regression to `triager.sh`'s breaker but does not exercise the real handler directly).

**Committed & pushed:** `d486643cf` to `origin/main2` (CAS push succeeded first try).

**Follow-ups:** None required. Note there is no unit test that exercises the real `triager-claude.sh` handler's range selection (the existing test stubs it out); a future harness could add a cold-start assertion, but that's out of scope here.
