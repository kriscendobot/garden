Work complete and pushed to `main2`.

## Completion report

**Job:** `improve-proxy-qualified-replies` — validate each generated proxy ANSWER before delivery so a malformed reference cannot crash-loop `garden-proxy`.

**Root cause found:** In `scripts/jobs/handlers/proxy-claude.sh`, `answer_question` handed each `claude -p`-drafted reply straight to `maintainer-reply.sh`, which runs `check-issue-refs.sh`. A reply carrying a bare `#N` (an LLM's natural PR phrasing — "see PR #340") made that gate `die`. Under `set -euo pipefail` the die propagated out of the whole handler, so `proxy.sh` never advanced its seen-marker — and re-enumerated the same digest, re-drafted the same malformed reply, and re-died every five minutes. The blocked gardener was never answered *nor* deferred.

**What changed (`scripts/jobs/handlers/proxy-claude.sh`):**
- New `validate_reply` — runs the same deterministic `check-issue-refs.sh` gate on the drafted reply, returning the validator diagnostics on rejection.
- New `repair_reply` — one bounded repair pass: re-prompts the agent with the reply + diagnostics to fully-qualify every reference, parses a fresh ANSWER block.
- New `defer_unqualified_reply` — leaves the gating question **unread** for the maintainer (a true deferral, not archived) and posts a **deduplicated** note with a deterministic `GARDEN_MSG_ID` (`proxy-unqualified-<msgid>`), so re-runs are idempotent and never re-pile the note.
- The ANSWER branch now does **validate → (repair → re-validate) → deliver, else defer**. Both outcomes exit 0, so `proxy.sh` advances the seen-marker and the tick is never re-run on the same reply.
- `answer_question` delivers with `GARDEN_SKIP_REF_CHECK=1` (handler already validated).

**Tests:** Added `scripts/jobs/test/proxy-qualified-reply-test.sh` (14 assertions, all passing) covering repair-fixes, repair-fails-then-defer (incl. dedup across a second run), and clean-passthrough. Injects a fake `claude` via `GARDEN_CLAUDE_BIN` and includes the `noexec`-mount base probe run-test.sh documents.

**Docs:** Added a "Qualified-reply validation (crash-loop guard)" section to `roles/proxy/AGENT.md` and expanded the handler header.

**Verification:** New test 14/14 green; the sibling `proxy-park-body-hygiene-test.sh` shows one failure (reaper doom-park) that I confirmed is **pre-existing and unrelated** — it fails identically with my change stashed, and I touched neither `reaper.sh` nor `proxy.sh`. Pushed as `f1affecf58` to `origin/main2` on the first CAS attempt.

**Note / follow-up:** I briefly edited the AGENT.md in the deployed garden root by mistake; I reverted it via a plain file edit (no git in the root) and verified it is byte-identical to the base before applying the change in my worktree instead. No follow-ups required.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-proxy-qualified-replies.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 77 tokens (4441220 cached reads)
- Output: 35203 tokens
- Cost: $4.351268
- Wall-clock: 526s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
