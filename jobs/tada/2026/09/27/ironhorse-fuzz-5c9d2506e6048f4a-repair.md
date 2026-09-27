I've stopped without changing any code: finding `5c9d2506e6048f4a` (target `differential_regexp_surface`) does not reproduce at the project SHA under test, `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`. Step 3 of the job says to report that and stop.

**What I checked**
- I copied the reproducer from the saved finding on the leader host to a scratch file in the job worktree. Its sha256 matches the expected `cf677bd6…8302` (4 bytes, `d4 d4 08 88`), and it agrees with the `input_base64` in the journal finding.
- The fuzz service's copy of the project is a clean checkout at `38ca1d1893`. At that SHA the target uses the strict check (`differential_check_with_symbols`), not the lenient check the standing branch uses now. That strict check is the one that should catch a divergence.
- I ran the service's `differential_regexp_surface` binary on the input with `-runs=1`, five times. That binary was rebuilt today (12:05Z) from that same checkout. Every run finished in about 19 ms with no panic or divergence, so it is not a timeout, an out-of-memory or an intermittent failure.
- The finding was recorded on 2026-08-30 and the service log has no line for this input, so I can't tell why it failed then. Its pinned SHA gives a clean pass now.

**What changed**
- Nothing. No regression test, no engine fix and no push to `ironhorse-fuzz-findings`, so the standing PR endojs/endo-but-for-bots#1298 was not amended.
- The only side effect is an isolated project worktree created by `ensure-project-worktree.sh` at the current standing-branch tip, `76502b5911`.

**Follow-ups**
- Mark this finding "does not reproduce at the recorded SHA" in the journal, so the fuzz service doesn't post it again.
- If the maintainer wants a regression lock anyway, it would follow the recent advisory-finding locks: a test in `ironhorse-vm` that needs no submodule, replaying these bytes and checking the program completes. That is new work outside this job's stop condition.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-5c9d2506e6048f4a-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 8 on 3 host(s) (5 unmetered)
- Input: 22 tokens (572989 cached reads)
- Output: 5049 tokens
- Cost: $0.6399937999999998 (5 engagement(s) unpriced)
- Wall-clock: 7744s
- Model(s): claude-opus-4-8 ×1, claude-opus-5-5 ×2

<!-- garden-usage-end -->
