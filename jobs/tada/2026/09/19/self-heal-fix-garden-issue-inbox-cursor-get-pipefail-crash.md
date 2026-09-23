Pushed cleanly on the first try (no rebase needed). Done.

## Completion report

Applied the fail-open rc-capture pattern (mirroring triager.sh's final form from commits 73c2432e89 / b320648e47) to the three unguarded `cursor-get.sh` bare-command-substitution call sites that crash the tick under `set -euo pipefail`:

- **`scripts/jobs/issue-inbox-watcher.sh:386`** — the site that produced the captured silent exit-1 crash.
- **`scripts/jobs/comment-watcher.sh:423`** — identical unguarded pattern.
- **`scripts/jobs/mention-watcher.sh:83`** — identical unguarded pattern.

Each now does `if cursor_out="$("$HERE/cursor-get.sh" "$CURSOR_KEY")"; then rc=0; else rc=$?; fi`, and on **any** nonzero rc logs `WARN: cursor read failed for <key> (rc=$rc); skipping this tick` and `exit 0` — no `is_environmental_rc` gate, no `die` fallback, exactly as instructed. The `last_seen` parse now reads from the captured `$cursor_out` via `printf ... | sed`, so the pipeline no longer straddles the subprocess exit. Added a header comment at each site explaining the outage/rc=1 failure modes and the best-effort rationale.

Verification: `bash -n` passes on all three; `set -euo pipefail` and the `log` helper are confirmed present in each.

Committed as `df83fca235` and pushed to `origin/main2` on the first attempt (clean fast-forward, no CAS rebase needed).

No follow-ups — the two other cursor reads in these files' scope (issue-inbox/comment/mention each have a single activity cursor read here; triager's sibling `failcount` read was already guarded) are covered.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-issue-inbox-cursor-get-pipefail-crash.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (231660 cached reads)
- Output: 5145 tokens
- Cost: $0.616085
- Wall-clock: 67s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
