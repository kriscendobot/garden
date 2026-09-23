---
gate: deferred
priority: normal
role: fixer
tier: mentor
token-budget: 100000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: transient
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-09-18T05:43:44Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-09-18T05:43:44Z
---

---
role: fixer
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-09-18T05:21:26Z cleared=none -->

---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# date-sharded-tada stage 3: retroactive migration of jobs/tada/

Blocked on `date-sharded-tada-writer-switch` (stage 2). **Read that job's
tada report first** and confirm from `fleet/health/*` (leader, garden2,
oros-studio) that its commit is actually DEPLOYED fleet-wide, not merely
landed on main2 — the design (`designs/date-sharded-tada.md` § Implementation
stages) treats each stage as a deploy checkpoint, and this exact "landed but
not yet deployed" gap is what correctly stopped the first attempt at this
stage. If any host is still behind, STOP and report — do not proceed on a
partial deploy.

## The work (design § 5 "Migration atomicity")

One-shot, idempotent, repeat-until-empty CAS job:

1. Enumerate every `jobs/tada/<base>.md` at the flat level (not yet sharded).
2. For each, recover its completion date from its **add commit** (the first
   commit that ever added that path — `--diff-filter=A`, `tail -1` on the
   git log for that exact path, so a base that drained and re-completed keeps
   its ORIGINAL add date, not a later one):
   ```sh
   git log --diff-filter=A --format='%cd' --date=format:'%Y/%m/%d' \
       -- jobs/tada/<base>.md | tail -1
   ```
3. `git mv` into `jobs/tada/<yyyy>/<mm>/<dd>/<base>.md`. If the add commit
   cannot be found (history rewrite, or genuinely no add commit), the entry
   goes to `jobs/tada/undated/<base>.md` instead — NEVER skipped, NEVER
   guessed. This bucket should end up empty or near-empty; if it's not, that
   is itself worth flagging in your report, not silently accepted.
4. Commit the WHOLE set as ONE commit (all ~4,500+ renames in one tree
   object — git handles this trivially), pushed via the same rebase-CAS retry
   loop `complete-job.sh` uses. A lost race just re-syncs and re-runs;
   already-sharded entries are skipped on re-run (idempotent).
5. Repeat until zero flat entries remain (excluding `undated/`), then record
   completion. No fleet drain needed — read the design's own reasoning for
   why (a completion during migration lands sharded directly, via stage 2's
   already-deployed writers; migration only ever touches pre-existing flat
   entries, never something a running job is about to write).

## The one host-local side effect (design § 5, called out explicitly)

`follow-up.sh`'s seen-marker (`$GARDEN_STATE`, host-local, keyed on tada rel
path today) will otherwise treat every migrated entry as "new" and could
storm follow-up notifications for ~4,500 already-old completions. The design
recommends re-keying the seen-marker on **base** (basename) rather than rel
path as the durable fix (should already be partly done in stage 1's "Fix
follow-up.sh base extraction and re-key its seen-marker on base" — verify
this actually landed and covers this case; if not, fix it as part of this
job, before running the migration, not after).

## Report

Total entries migrated, count landed in `undated/` (investigate and explain
any non-trivial count there, don't just note it), the commit(s) sha, and
confirmation the follow-up.sh seen-marker re-keying was verified/fixed
before the migration ran (sequencing matters — check this BEFORE moving
files, so a migration-triggered follow-up storm can't happen even
transiently).

Design's stage 4 ("drop the fallback" — remove the now-unneeded flat-read
arm from the helpers once the backlog is fully sharded) is explicitly OUT OF
SCOPE for this job — it's cosmetic cleanup the design says can wait "at
leisure." Flag it as a natural follow-up in your report; do not do it here.
