Inbox empty. Work complete.

## Completion report

**Bug fixed.** `scripts/jobs/usage-meter.sh` had a dropped positional-argument binding in `meter_journal_host_tokens` (line 298): `local dir="$1" host="$2" cutoff files` declared `cutoff` but never assigned it, so its `jq --argjson cutoff "$cutoff"` threw `cutoff: unbound variable` under `set -u` — exactly the live failure reported from `post-job.sh` on 2026-08-23. Changed to `cutoff="$3"`.

**Second, identical miss found and fixed.** Per the "confirm there isn't a second similarly-shaped miss" instruction, I grepped every `local` declaration in the file against its call sites. `meter_journal_provider_usd` (line 381) had the exact same drop — `cutoff` declared unassigned while its sole call site (`usage-meter.sh:442`) passes `$cutoff` as the third positional. Fixed to `cutoff="$3"`. No other declarations had the pattern.

**Regression test added.** `scripts/jobs/test/meter-journal-cutoff-test.sh` — a hermetic test (modeled on `live-budget-admission-test.sh`) that seeds a usage ledger and asserts both functions return a real *summed* number given a live cutoff (343 tokens / $3.75), not merely that they exit without error, and that the pre-cutoff row is correctly excluded. I verified it genuinely catches the bug: against the un-fixed source it fails with `rc=127 … cutoff: unbound variable`; against the fix it passes.

**Verification:** `bash -n` clean on both files; `shellcheck -S warning` clean on the new test; the new test passes 2/2; the adjacent `live-budget-admission-test.sh` still passes 14/14.

**Committed and pushed:** `dc35c6f057` landed on `main2` (clean push, no rebase needed).

**Scope:** No other usage-meter/budget-level behavior changed, per the job's out-of-scope note.

**Follow-ups:** None. Note the impact-while-unfixed observation stands — remote-account budget-gating via the journal fallback path (`meter_journal_host_tokens`/`meter_journal_provider_usd`, used when a leader cannot read another host's `~/.claude`) was silently non-functional since this landed; it is now restored and covered by the regression test.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-usage-meter-cutoff-unbound-var.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 52 tokens (1589949 cached reads)
- Output: 10645 tokens
- Cost: $1.6383975 (1 engagement(s) unpriced)
- Wall-clock: 163s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
