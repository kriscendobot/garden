---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/usage-meter.sh
scripts/jobs/usage-meter.sh:578's compound condition (`[ "$p" = "$pool" ] && ... && [ "$w" = "$cutoff" ] && [[ "$s" =~ $num ]] && ... || return 9`) collapses five distinct failure modes into one opaque rc 9, surfaced to operators only as the generic `snapshot-field-mismatch (pool/cap/window/spend)` string (usage-meter.sh:549). journalctl shows this WARN recurring for pool=claude-oros host=oros-studio-garden-ce242c49 twice 15 minutes apart (2026-09-25T00:05:06Z and 00:20:08Z), i.e. every tick, even though commit a7c06dd8 (landed 21:54Z the same day) already fixed the torn-write cause of the prior day's identical WARN — so this recurrence is either unrelated (a genuine window/cutoff drift between publisher and reader) or unfixed-on-that-host, and there is no way to tell which without re-instrumenting by hand each time. Fix: before `return 9`, log which field(s) actually diverged (e.g. `log "snapshot mismatch pool=$p/$pool cap=$c/$cap window=$w/$cutoff spend=$s at=$at now=$now"`) so a recurrence is diagnosable from the journal alone instead of requiring a fresh read of this function.
