Press dispatch `ocapn-noise-press-20260724-225004` (resumed after reaper requeue ×3) — assessment-only completion; no code motion was possible or needed.

**State verified (2026-07-25 ~11:20Z, real command output cited in-session):**
- **M1–M5 remain proven** — no branch in the stack has moved since the last proof runs: #340 `6eb31274`, #684 `cc398cb1`, #688 `469335e6`, #693 `73ad1b6d`, #806 `b1d86021` (heads confirmed via `gh pr view`). With zero head motion, re-running the demo suite would be a non-idempotent duplicate; the prior captured proofs stand.
- **#806** (crossed-hello race fix, the sole gating PR): ready-for-review, MERGEABLE, all 20 checks green at `b1d86021` (`gh pr checks 806` — every row `pass`). kriskowal's APPROVED review is at pre-rebase commit `1e4f9104`, so it stays stale under the current-approval-before-merge rule. The `llm` tip moved to `546e2c0d` at 11:00Z today; #806 still reports MERGEABLE against it — no re-rebase needed.
- **Merge remains ownerless**: conductor job `endojs-endo-but-for-bots-pr806-conduct` is still poisoned (requeue-exhausted) and parked in `jobs/plan/` behind a `go-ahead` gate only the maintainer can promote.
- **Escalation status**: the maintainer message asking for a fresh approval at `b1d86021` + promotion of the parked conduct job (msg `20260725T032633Z-ca6252`, sent 03:26Z) is **still unread**. Per the standing policy set by peer dispatch 20260724-165003, I did **not** duplicate it; one re-nudge is due only if still unread after ~2026-07-26T03:26Z.
- **#340** remains CONFLICTING vs `llm`; the stack weave (#340→#684→#688→#693) stays correctly deferred until #806 lands so one rebase covers both.
- No new PRs in the Noise lane; iroh (#777/#820) and sturdyref lanes belong to their own press jobs. My job inbox was empty.

**What changed:** memory record `ocapn-over-noise-goal.md` updated with this dispatch's verification (fourth consecutive stood-down check; `llm` tip motion noted). No repo pushes, no new jobs, no messages sent.

**Follow-ups for the next dispatch:** (1) if the escalation is still unread after ~2026-07-26T03:26Z, send the single permitted re-nudge; (2) once #806 merges, post/execute the stack weave onto the new `llm`; (3) standing open questions unchanged (cross-host TCP+CBOR port choice; iroh-lane orchestration answer).
