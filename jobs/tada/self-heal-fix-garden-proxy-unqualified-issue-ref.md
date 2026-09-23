The requested fix is present in `HEAD` (`origin/main2`) and verified by the dedicated test suite. No new work was needed.

## Completion report

**Finding:** The fix this self-heal job asks for is **already implemented and merged to `origin/main2`** (which is also this worktree's HEAD, `0fcdcafe90`). It landed in two commits authored ~7–9 minutes before I claimed the job:

- **`f1affecf58`** — `fix(proxy): validate generated ANSWER before delivery, repair-or-defer bad refs`. This is exactly the requested fix to `answer_question()`/`flush()` in `scripts/jobs/handlers/proxy-claude.sh`:
  - `validate_reply()` runs the same deterministic `check-issue-refs.sh` gate on the drafted reply **before** delivery.
  - On rejection: one bounded `repair_reply()` pass (re-prompts the agent to fully-qualify bare `#N` refs), re-validate; if still bad, `defer_unqualified_reply()` posts a deduplicated maintainer note (deterministic `GARDEN_MSG_ID`) instead of dying.
  - `answer_question()` now delivers with `GARDEN_SKIP_REF_CHECK=1` (already validated), so `maintainer-reply.sh` can no longer `die` mid-handler under `set -euo pipefail`. Every path exits 0, breaking the every-five-minutes crash-loop.
  - Adds `scripts/jobs/test/proxy-qualified-reply-test.sh` (repair-fixes / repair-fails-then-defer / clean paths).
- **`0fcdcafe90`** — `fix(proxy): quarantine malformed generated replies`. Companion hardening in `proxy.sh` so a wedged digest is quarantined (marker advanced, one actionable notice, no retry loop).

**Verification I ran:**
- `proxy-qualified-reply-test.sh` → **14 passed, 0 failed** (never delivers the bare-`#N` reply; defers-and-dedups when repair fails; delivers a clean reply unchanged).
- Full `run-test.sh` → **376 passed, 1 failed**. The one failure is **SUBTEST 26 — ISSUE INBOX** (`issue-inbox-watcher.sh` swallowing definitive-source-enumeration stderr), entirely unrelated to the proxy handler this job covers. All proxy subtests (13b/c/d, 15c malformed-reference quarantine, 29 issue-ref gate) pass.

**Changes I made:** none — the deliverable already exists, is correct, and is verified. Working tree is clean; nothing to commit or push.

**Follow-ups:**
- Pre-existing, out-of-scope test failure: `run-test.sh` SUBTEST 26 (ISSUE INBOX) — "definitive source enumeration stderr was swallowed" in `issue-inbox-watcher.sh`. Worth a separate self-heal/fix job; it is not a regression from the proxy fix and does not touch the proxy tick.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-proxy-unqualified-issue-ref.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (982695 cached reads)
- Output: 6175 tokens
- Cost: $1.1108505
- Wall-clock: 620s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
