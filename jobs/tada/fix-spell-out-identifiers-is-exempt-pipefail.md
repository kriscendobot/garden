Pushed cleanly to `main2`.

## Completion report

**Job:** Fix the `head|grep -q` SIGPIPE gotcha in `is_exempt` (spell-out-identifiers probe) and guard it against regression.

**What I found:** The core code fix was already in place — commit `1e8732f83c` (4 days ago, from the same PR #1014 fix round) had already replaced the buggy `printf '%s\n' "$content" | head -5 | grep -q` with the here-string form `head -5 <<<"$content" | grep -q`. That fix also covered the two sibling probes that shared the exact bad shape: `prefer-endo-primitives.sh` and `no-inline-import-jsdoc.sh`. What was missing was a regression test — the job explicitly required one.

**Sibling probe audit (all clear):**
- `prefer-endo-primitives.sh`, `no-inline-import-jsdoc.sh` — already fixed to the here-string form in the same commit.
- `typist-friendly-code-points.sh` — uses `head -5 "$1" | grep -q`, reading the file directly; `head` is a tiny 5-line producer that fits the pipe buffer, so there is no big-producer SIGPIPE. Not the bug.
- `typedefs-belong-in-dts.sh` — pipes `printf | is_types_only_module`, an awk that drains all of stdin (never exits early), so the producer never takes SIGPIPE. Not the bug.

**What I changed:** Added a regression test to `scripts/jobs/test/pre-push-gates-test.sh` matching the PR #1014 repro shape — a `spell-out-exempt` file with the marker in the first 5 lines, padded past the 64 KiB pipe buffer (5000 filler lines) and carrying an abbreviated identifier (`pendingIdx`). A voided exemption would fail the probe; the honored exemption passes.

**Verification:** Ran the suite against the current (fixed) probe → passes. Temporarily reverted `is_exempt` to the buggy `printf|head|grep` pipeline → the new test fails (`not ok - long spell-out-exempt file was rejected`); restored → passes. So the test genuinely locks the fix in.

**Commit:** `346cb75239` pushed to `origin/main2`, one file changed (+29 lines).

**Follow-ups:** None. No further probe carries the big-producer-into-`head` SIGPIPE pattern.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-spell-out-identifiers-is-exempt-pipefail.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 27 tokens (798529 cached reads)
- Output: 11590 tokens
- Cost: $1.2426535
- Wall-clock: 163s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
