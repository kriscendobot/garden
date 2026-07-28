Landed on `main2` as `c40b8358ba`.

## Report

**What the defect was.** `journal-entry.sh` had no re-post guard, so an agent that invoked it twice for one report wrote two permanent entries into the append-only journal (`entries/2026/07/28/071837Z-result-botanist-e4bedc.md` and `071905Z-result-botanist-71442a.md` — byte-identical results for endojs/endo-but-for-bots#269, same host, 38s apart). As the job spec noted, this was never the retry loop: `rel` is computed once before it, so a retry after a landed push is a no-op commit.

**What I changed** (`scripts/jobs/journal-entry.sh`, +130):

- Before committing, the script scans entries recently landed on `origin/$JOURNAL_BRANCH` for one with the same `kind`, `role` and host whose **body** is byte-identical, and on a hit logs `duplicate of <path>, not posting` and exits 0 having written nothing. Frontmatter is parsed for kind/role/host and then discarded, so the per-invocation `at:` stamp — the one field two copies of a report are guaranteed to disagree on — cannot defeat the match.
- It reads the **origin ref, not the clone's working tree**, so only an entry that actually landed can suppress a post; an untracked leftover from a run that died between writing its file and committing can never silently swallow a real entry. (This was the one non-obvious design call — the naive working-tree scan is a permanent-entry-loss hazard.)
- Bounded twice: by UTC day (exactly the days the window spans, hard-capped at `GARDEN_ENTRY_DUP_MAX_DAYS=2`) and, within a day, by the `HHMMSSZ` stamp already in the filename, so out-of-window candidates are discarded without reading their blob. Same-host-only matching keeps that filter free of cross-host clock skew.
- Runs on every retry attempt against the just-synced tip, so it also catches the silent-loss case where our own earlier push landed after we judged it failed.
- Escape hatches: `--allow-duplicate` (accepted anywhere in argv; every *other* dash-led token still hits the existing malformed-kind refusal) and `GARDEN_ENTRY_DUP_WINDOW` (seconds, default 900; `0` disables). A non-numeric knob dies loudly rather than losing the entry inside arithmetic.

**Caller audit.** No current caller needs `--allow-duplicate`: the fleet's narration entries embed varying data (cycle, elapsed, rc, sha), and the two that could repeat verbatim — the worker health gate (`common.sh:_worker_health_report`) and `identity-drift-guard.sh` — already emit once per episode behind their own edge claim. The message bus does not route through this script.

**Tests.** New hermetic `scripts/jobs/test/journal-entry-dedup-test.sh` (26 assertions, throwaway bare origin, no network): the 071837Z/071905Z shape suppressed with the exact log line and an unchanged origin head; the negatives that must still post (different body / kind / role / host); both escape hatches and window expiry; the day walk and its cap; the untracked-leftover case; and the argv guards with the new flag in play. All 26 pass. Sibling `journal-entry-argv-test.sh` still 23/23.

**run-test.sh parity.** 336 passed / 30 failed — and a baseline run of a pristine clone of the pre-change HEAD produced the *identical* failure set, so nothing here regressed. Those 30 are pre-existing (git-corruption fixtures, `sync_clone` re-clone healing, a shellcheck nit in the `gh` wrapper, foreman fill, declined-blocker, issue-note subtests). Flagging that per the standing "CI failure = automation defect" policy: **`scripts/jobs/test/run-test.sh` is currently red at baseline on this host**, which is worth a separate job — I did not touch it, since fixing 30 unrelated assertions is well outside this job's scope.

**Docs.** `roles/COMMON.md` § Writing an entry now tells gardeners that re-posting is a no-op, states the comparison rule and the knob, and points at `--allow-duplicate` for a genuine heartbeat.

**Follow-ups.** (1) The pre-existing red `run-test.sh` baseline above. (2) The two duplicate entries from 2026-07-28 are still in the journal; the journal is append-only, so they stay unless someone deliberately supersedes them.
