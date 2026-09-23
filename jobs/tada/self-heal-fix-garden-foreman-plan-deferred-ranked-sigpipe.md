Inbox empty. Work complete.

## Completion report

**Job:** `self-heal-fix-garden-foreman-plan-deferred-ranked-sigpipe`

**Root cause confirmed.** `scripts/jobs/foreman.sh:298` read the top-ranked deferred plan job with `top_deferred="$(plan_deferred_ranked "$DIR" | head -1)"` under `set -euo pipefail`. `plan_deferred_ranked` (common.sh:7795) ends its pipeline in `| cut -f3`; with 2+ deferred plan jobs it emits 2+ lines, so `head -1` captures the first and closes the pipe, `cut`'s pending write fails (EPIPE→exit 1 under an inherited `SIG_IGN` as with systemd — matching the 30-byte `cut: write error: Broken pipe` capture blob dbcf6b220fa… — or SIGPIPE→141 by default), `pipefail` makes the substitution nonzero, and `set -e` aborts the whole tick. A board with 2+ deferred plan jobs could never pump.

**Fix applied.** Appended `|| true` to the substitution (with an explanatory comment). The first line is captured before the pipe closes, so the value is preserved; only the writer-side broken-pipe status is discarded.

**What changed:**
- `scripts/jobs/foreman.sh` — the one-line fix + comment.
- `scripts/jobs/test/foreman-deferred-sigpipe-test.sh` (new) — a two-part regression guard:
  - **Subtest 1 (behavioral, spec's literal ask):** a real foreman tick over a board with 4 deferred plan jobs runs to completion (rc=0) and promotes at least one plan→todo.
  - **Subtest 2 (deterministic mechanism):** drives the exact idiom against the *real* `plan_deferred_ranked` with >64 KiB of ranked output and a prompt-closing one-line reader (a faithful stand-in for `head -1` that reliably forces the writer's broken pipe — GNU `head`'s large read buffer masks the race in a fast local shell). The unguarded form aborts a `pipefail` shell 3/3; the shipped `|| true` form survives and still captures the top-ranked base; plus an assertion that `foreman.sh` still carries the guard.

**Verification:** All 5 assertions pass; shellcheck clean; `bash -n` clean. Removing the `|| true` (regression check) correctly fails subtest 2c. Subtest 2's unguarded/guarded contrast (2a/2b) proves the mechanism and the fix independently of the environment's `head` behavior.

**Notes / follow-ups:**
- Subtest 1 (the end-to-end tick) passes on *both* pre- and post-fix code in this environment because GNU `head`'s large read buffer masks the pipe race there; subtest 2 is the true fail-on-regression guard. This is documented in the test's header.
- Sibling `plan_deferred_ranked | head -1`-style pipelines elsewhere under `set -e` (there are ~19 `head -1` sites in common.sh) were not audited as part of this job; only the foreman's call site was in scope. Worth a future sweep if the same class recurs.

Committed as `61019d0a22` and pushed to `origin/main2`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-foreman-plan-deferred-ranked-sigpipe.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (3401540 cached reads)
- Output: 43399 tokens
- Cost: $3.8022709999999997
- Wall-clock: 877s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
