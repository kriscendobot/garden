once: 2026-09-28T18:00:00Z
job_basename_prefix: token-backoff-ramp-080
---
Run this exact command from the garden root checkout and report only its
output:

    scripts/jobs/set-token-backoff-fraction.sh 0.80

Context (no investigation needed, no code changes): this is one step of a
maintainer-authorized weekend token-backoff ramp (kriskowal, 2026-09-26).
The foreman's spend ceiling (config/token-backoff-fraction on journal2) is
being raised gradually from 0.50 toward 1.00 as the endolin-claude1/
endolin-claude2 weekly quota period closes toward its manually-triggered
mid-week reset (synthetically assumed 2026-09-30T06:59:59Z, Tuesday end of
day Pacific).

The script is a deterministic CAS writer with no side effects beyond that
one journal file. Exit code 2 is SUCCESS for this script (it always exits 2
so a scheduler-style caller sees "no work to post" — you are running it
directly, not via the scheduler, so just confirm the log line reads
"set token-backoff-fraction=0.80" or "no change (already 0.80)", either
of which means done). Report done; no further action required.
