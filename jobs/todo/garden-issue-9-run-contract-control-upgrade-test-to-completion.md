# #9 — RUN mhofman's contract-control-upgrade test TO COMPLETION and reply (prior run stalled mid-step-1)
Repo: kriskowal/garden issue #9 — ymax0 XS value-stack overflow. **Single owner; run the whole thing.**
**Why re-posted:** the prior protocol job (`garden-issue-9-mhofman-contract-control-upgrade-test-protocol`)
was **marked done while still mid-step-1** — its entire report was "I'll stop polling and let the
background monitor notify me… Waiting." It set up a background monitor for the baseline upgrade and its
session ended before any step completed. No result, no #9 reply. Do NOT repeat that.
**mhofman's protocol** (comment 4849982001) — run all three steps to actual completion:
1. **Baseline:** null-upgrade ymax0 to the current bundle (release `ymax-v0.3.2606-beta2`) via inquisitor
   contract control; confirm success = **incarnation number increases + expected log message**.
2. **Reproduce:** install the beta3 bundle first, upgrade via contract control; confirm it **FAILS** on the
   stack overflow (capture the overflow / exit-12).
3. **Verify fix:** install the **patched beta3 bundle (flatMap fix)**, upgrade; report success/failure.
**HARD run-to-completion gate:**
- Do **NOT** set up a background monitor and then finish/complete the job while it runs. **Poll each
  upgrade to its actual terminal state within this job** and record the real observed result before moving
  on. The job is complete only when **all three steps have real observed outcomes AND you have posted a
  reply comment on #9** to mhofman with the evidence (incarnation numbers, log messages, the overflow on
  step 2, the step-3 result).
- If a step genuinely cannot finish in one working session, **post a follow-on job that RESUMES from the
  captured chain/swing-store state** — do NOT mark the whole protocol done with partial/"waiting" results.
- Verification-integrity: cite real execution; never assert an outcome you didn't observe.
Scope: bot repro infra / inquisitor; the Agoric release tag + bundles are read-only reference; no upstream
Agoric/agoric-sdk comments or artifact links. Preserve/resume any baseline state the prior run established.

<!-- garden-reaped: 1 -->
