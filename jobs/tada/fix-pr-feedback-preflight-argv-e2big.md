Pushed cleanly on the first attempt (rebased onto the newer main2 head `f33bdf6402`); `HEAD == origin/main2 == 4663e6ac4d`. All gates green.

One note surfaced during fetch: the shared repo has a stale `gc.log` (a failed repack citing a missing object `9ad05cc3…`) — the exact object-store-maintainability condition `garden-root-repo-guard` watches for. I did not touch it (never run git maintenance in the root); flagging it as a follow-up.

---

## Completion report

**Job:** fix `pr-feedback-preflight.sh` — large API payloads in argv blow `MAX_ARG_STRLEN` and the failure was swallowed as a finding.

**What changed** (2 files, pushed to `main2` as `4663e6ac4d`):

`scripts/jobs/gardening/pr-feedback-preflight.sh`
- **Argv fix (the mechanical bug):** `gather_evidence` no longer passes the `target`, `commits`, and `comments` API payloads to `jq` as `--argjson` argv values. Each is written to a temp file (via the `printf` builtin — no `execve`) and read with `--slurpfile`, referenced as `$name[0]`. No unbounded payload ever reaches argv, so it holds for arbitrarily large corpora — not just one bigger than today's. No corpus truncation. Reproduced the original E2BIG (209 KB argv → "Argument list too long") to confirm the diagnosis before fixing.
- **Failure-vs-empty fix (the larger bug):** `gather_evidence` now takes a reason file, captures each failing command's **stderr** (previously `2>/dev/null`), and returns nonzero with a human-readable reason. The caller distinguishes a **gather FAILURE** (infrastructure/tool/transport) from a **validly-gathered but empty corpus** (a finding) — they no longer share a log line or code path. A failure logs the full reason *including captured stderr* at WARN (never swallowed), and a **structural** failure additionally files a throttled, auditable `alert_maintainer` entry; a **transient** network blip (via the existing `is_transient_net_error`) stays WARN-only to avoid alert floods. It still fails open, as before — proceeding beats no-oping real work off an uncorrelated partial corpus.
- **Justification for still failing open silently-ish:** proceeding is retained (unchanged posture), but the event is now named as an infra failure at operator-visible WARN and, when structural, recorded on the maintainer inbox — auditable rather than masquerading as "no evidence found."

`scripts/jobs/test/pr-feedback-preflight-test.sh`
- Added a **live-path harness** (stubs `gh` on `PATH`, real `jq`; the existing fixture stub short-circuits *before* the plumbing so it could never exercise this). New tests: a **>131 KB** review-comment corpus completes without E2BIG and reaches the correct verdict (parsed, not truncated); an oversized benign corpus PROCEEDs; a forced gather failure is reported distinguishably from an empty corpus in both the log and the maintainer alert, with captured stderr surfaced; an empty corpus is handled as a finding (no failure line, no alert); a transient failure stays WARN-only. **23/23 pass** (10 pre-existing + 13 new).

**Verification:** `bash -n` clean on both files (a CI gate); pre-dispatch grep-gates clean (`run-all.sh --dry-run`); grep-gate test harness `7/7`; CI's scoped `shellcheck -S warning` list does not include these files, so their pre-existing idioms (the `ok && bad` pattern, `GARDEN_TAG`) don't gate. local-verify's project-CI steps are N/A (this is a garden `main2` change, not a fork).

**Relation to the sibling job:** I kept the diff strictly to `gather_evidence` and the fail-open caller branch. The correlation/matching logic (the exit-2 "peer already resolved" path that `investigate-pr721-review-false-peer-resolution` examines) is **untouched** — no overlap. That job wasn't present on this worktree's journal snapshot and my inbox was empty.

**Follow-ups:**
- Shared-repo `gc.log` (failed repack, missing object `9ad05cc3…`) observed during fetch — the object-store-maintainability condition `garden-root-repo-guard` exists to repair; left untouched per the no-git-in-root rule.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-pr-feedback-preflight-argv-e2big.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (2163418 cached reads)
- Output: 44516 tokens
- Cost: $3.0855329999999994
- Wall-clock: 626s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
