In `scripts/jobs/gardener.sh`, the exit-0-unsatisfying branch (~lines 352-363) emits a `kind:progress` journal entry on EVERY requeue cycle, including cycle 1. A cycle-1 exit-0-unsatisfying is a benign, expected transient (quota/usage cut, swallowed API error) that the reaper requeues silently and escalates to POISON only after `GARDEN_REAP_POISON_THRESHOLD` cycles — so cycle-1 emission is routine progress that burns supervisor/journal context and violates the silent-until-error discipline. Change the branch to keep the local `log "..."` line unconditional (operator visibility in journalctl) but gate the `journal-entry.sh progress` emission on `cycle -ge 2` (a repeat, which indicates a deterministic non-transient cut worth a note, distinct from a one-off blip). This preserves the reaper's poison escalation as the authoritative signal, keeps all diagnostic behavior for repeats, and removes the single-cycle routine-progress noise seen in this digest (job `fix-stale-bulletin-leader-singleton`, requeue cycle 1). Update the adjacent comment block (~lines 349-351) to record that cycle-1 transients log locally only.

---
claim:
  host: endolinbot2
  gardener: 6
  claimed_at: 2026-07-02T19:21:27Z
