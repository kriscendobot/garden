Worktree removed cleanly and the change is on `origin/main2`. Job complete.

---

## Completion report

**Job:** `improve-gardener-empty-output-classifier-rc-gate`

**What was wrong:** In `scripts/jobs/gardener.sh`, the empty-capture branch of the transient-vs-real handler-failure classifier set `transient=1` for *any* empty output (`[ ! -s "$capture" ]`), ignoring the handler exit code `$rc`. This silently requeued deterministic failures — `rc=127`/`rc=126` (missing/non-executable external tool, the jq-outage signature) and bare `rc=1`/`rc=2` — as transient blips, deferring human escalation to the reaper's multi-hour poison cycle. The block's "mirrors self-heal-run.sh" comment overstated the parity.

**What I changed** (committed `68f699cc8`, pushed to `origin/main2`):
- **`scripts/jobs/common.sh`** — added a pure helper `is_transient_empty_failure <rc>`: returns transient (0) only for signal/clean-shutdown codes (143 SIGTERM, 130 SIGINT, 137 SIGKILL) or the offline rc (`${GARDEN_OFFLINE_RC:-75}`); returns deterministic (1) otherwise. Mirrors the discrimination at `self-heal-run.sh:121`.
- **`scripts/jobs/gardener.sh`** — the empty-capture branch now gates `transient=1` on `is_transient_empty_failure "$rc"`. A non-signal, non-offline non-zero rc with empty output falls through to the existing capture-by-hash + gardener-inbox escalation, so a missing-tool/exec defect surfaces immediately. The `is_transient_claude_signature` content match is unchanged (exit-code-agnostic by design). Refined the leading classifier comment so it no longer claims empty output is unconditionally transient, realigning it with the self-heal-run parity it cites.
- **`scripts/jobs/test/empty-output-classifier-test.sh`** (new) — asserts rc=143/130/137/75 empty → transient/no-escalation; rc=127/126/1/2 empty → escalated; plus a configurable-`GARDEN_OFFLINE_RC` case proving the helper reads the env var rather than hardcoding 75. All 10 assertions pass; both modified scripts pass `bash -n`.

**Method:** Built in an isolated worktree off `origin/main2` (per the garden-infra convention), committed explicit pathspecs under the `endolinbot` bot identity, rebased on latest `main2`, pushed `HEAD:main2`, and removed the worktree. Inbox was empty at the final checkpoint.

**Follow-ups:** None required. The two shellcheck notes on the new test (SC2046 on the env-scrub `unset`, SC1091 on the sourced path) are the same intentional idioms already present in sibling tests like `clone-keeper-test.sh`. The `gardener.sh` "OPEN — failed-job lane" design question (immediate requeue vs. dedicated `jobs/failed/` lane vs. current doin/reaper) remains out of scope and untouched.
