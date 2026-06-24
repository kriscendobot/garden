# gardener.sh: capture handler failure by hash; stop completing failures as done

Per designs/self-healing-audit.md (Part A highest-value gap + Part B #1):
scripts/jobs/gardener.sh, on a job-handler non-zero exit, writes a one-line
"exited non-zero" report and completes the job doin->tada (lines ~70-74),
DISCARDING the handler's stdout/stderr (the gardening state machine's actual
failure) and recording a failed job as done.

Change the failure path to: capture the handler's combined output into the
journal via the capture helper (see self-heal-common-capture-helper), and
escalate with the SHA to the mentor/gardener inbox (see
self-heal-port-capture-skills) instead of discarding it. The failed-job
lifecycle semantics (requeue to todo vs a failed/ lane vs leave for the reaper)
is a design decision flagged for maintainer review in the audit; scope this job
to the capture+escalate change and surface the semantics question. Build in an
isolated worktree off origin/main2.
