#!/bin/bash
# signal-kill-handler-stub.sh — a gardener job handler that flushes PARTIAL
# output (to its own stdout, which gardener.sh diverts into $capture, AND to
# $report) and then exits with a signal-kill rc, emulating a gardener killed
# mid-job by a deploy-window restart / drain / OOM / claim-TTL kill AFTER it had
# already produced some output. Exit code is GARDEN_STUB_RC (default 143/SIGTERM).
# Used by signal-kill-classifier-test.sh to prove the classifier treats a
# signal-kill as transient REGARDLESS of capture content.
set -uo pipefail
base="${1:?base}"; jobfile="${2:?jobfile}"; report="${3:?report}"
# A side sentinel (outside $capture, which the gardener discards on a transient
# classification) so the test can confirm the handler genuinely flushed non-empty
# output before the kill — i.e. that $capture was non-empty when the classifier ran.
[ -n "${GARDEN_STUB_SENTINEL:-}" ] && echo "handler ran and flushed output for $base" >> "$GARDEN_STUB_SENTINEL"
# partial progress on stdout/stderr → folded into $capture by gardener.sh
echo "stub handler for $base: started working, flushed a progress line before the kill"
echo "stub handler: a folded report tail would also be non-empty" >&2
# partial work product in $report → gardener folds its tail into $capture too
printf '# partial report for %s\nwork in progress when the signal arrived\n' "$base" > "$report"
exit "${GARDEN_STUB_RC:-143}"
