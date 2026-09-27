Pushed to `main2` cleanly.

## Completion report

**Job:** Add a diagnostic ERR trap to `scripts/jobs/comment-watcher.sh` so a future silent `set -e` abort logs what failed before exiting (root-causing the 2026-09-18 21:18Z silent mid-tick rc=1 death, which produced zero diagnostic output).

**What I did**
- Added `trap 'log "FATAL: rc=$? at line $LINENO: $BASH_COMMAND"' ERR` immediately before the existing `EXIT`/`TERM`/`INT` traps (now at line ~1607, ahead of the `trap 'cleanup; write_comment_heartbeat' EXIT` line), with a comment explaining its purpose and diagnostic-only nature. The reported failure was in the top-level per-comment loop (`while … read; do … done < "$SRC"`, lines 1779–2227), which a plain ERR trap catches — so I deliberately did **not** add `set -E`/errtrace, keeping it minimal and avoiding false FATALs on guarded non-zero returns inside functions.

**Why it's diagnostic-only**
- The trap only reads `$?` (expanded into `log`'s args before `log` runs) and never calls `exit`, so the original rc is preserved: ERR fires first, then `set -e` exits and runs the existing EXIT trap (`cleanup`). No change to exit codes, control flow, or any retry/CAS semantics.

**Verification**
- `bash -n` clean.
- Synthetic forced-failure smoke test under `bash -x` (standalone harness replicating the exact trap lines, `set -euo pipefail`, and a stand-in `cleanup`, with a `false 42` injected after the mint/ack log): confirmed the sequence — `FATAL: rc=1 at line 10: false 42` (correct rc/line/command) → `cleanup ran (rc-at-entry=1)` (rc preserved into cleanup) → final process exit rc = 1; the EOF terminal log was never reached, matching the incident signature.

**Changed / follow-ups**
- 1 file changed, 12 insertions: `scripts/jobs/comment-watcher.sh`. Committed as `e5557a19bea` and pushed to `origin/main2`.
- No follow-ups. Note: this trap is a diagnostic net — it will surface the *next* such abort's rc/line/command in the captured log, but does not itself fix whatever command aborted on 2026-09-18 (unrecoverable from that capture, as expected).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-comment-watcher-endojs-endo-but-for-bots-silent-exit1-no-err-trap.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 30 tokens (809836 cached reads)
- Output: 9292 tokens
- Cost: $1.1689379999999998 (2 engagement(s) unpriced)
- Wall-clock: 154s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
