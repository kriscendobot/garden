In scripts/jobs/handlers/triager-claude.sh, the `claude -p` invocation at line 50 (`out="$(claude -p --dangerously-skip-permissions "$prompt")"`) discards claude's exit code and stderr on failure. When it exits nonzero, set -e aborts the handler with no diagnostic, and triager.sh:62 then dies with only the generic "triage handler failed for <slug>; leaving cursor at <none> to retry" — which is exactly what happened for kriscendobot-minion.town:main (<none> → 35e9b4a53a7c7b29eb85dfe3e2397bc9fcbe9cfa), leaving the failure undiagnosable.

Fix: capture claude's combined stdout+stderr and exit status explicitly instead of letting set -e swallow it. e.g. run claude without inline command-substitution abort, capture rc, and on nonzero `log` the tail of the captured output (a bounded number of lines) before exiting nonzero, so the service log preceding the triager.sh FATAL contains the actual cause (API/DNS/quota error, auth failure, malformed prompt, etc.). Keep the successful path (parse JOB..ENDJOB from stdout, post via post-job.sh) unchanged. This is a diagnostics-only change: no behavior change on success, cursor-retry semantics preserved. Signature to reference in the commit: "triage handler failed … leaving cursor at <none> to retry" with an empty service-log tail.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 5
  claimed_at: 2026-07-10T00:40:57Z
