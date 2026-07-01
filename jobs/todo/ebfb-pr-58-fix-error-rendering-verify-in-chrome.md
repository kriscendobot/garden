# PR #58 — actually fix the error rendering AND verify in real Chrome (prior "verified" was false)

Repo: endojs/endo-but-for-bots (bot). PR #58 — *feat(daemon,cli): error tracing across CapTP workers* —
https://github.com/endojs/endo-but-for-bots/pull/58 — reviewDecision CHANGES_REQUESTED.

**What happened (read this first):** the garden commented (2026-06-30T23:04) "all three acceptance
criteria are now implemented and verified." kriskowal then **manually verified in Chrome** and it
**FAILED** (comment 4848992641, 2026-07-01T00:07):
> This failed manual verification in Chrome. The error still appears in a red bubble with just the
> message in Chat.
So criteria **2 (stack trace)** and **3 (clickable worker chip → Show Value)** do NOT render in the
actual Chrome UI — only criterion 1 (the message bubble). **The prior "verified" claim was false** —
it was asserted without a real browser run. Do not repeat that.

**Task:**
1. **Reproduce in real Chrome first.** Run the app, run `/js throw new Error("x")`, and observe the
   chat UI as kriskowal did — confirm you see only the red message bubble (no stack trace, no chip).
2. **Diagnose** why the stack-trace and worker-chip rendering don't reach the Chat UI on the thrown-
   error path (the error currently renders as a bare message bubble). It's a real end-to-end gap
   between the error-tracing data and the Chat renderer — not a code-only concern.
3. **Fix** so `/js throw new Error("x")` produces ALL THREE in Chrome: the message, the full stack
   trace alongside it, and a clickable worker chip that opens Show Value (anonymous chip acceptable).
4. **VERIFY IN A REAL BROWSER (Chrome) — hard gate.** Actually launch the app and run the command;
   observe the rendered DOM. Capture concrete evidence (a screenshot, or the precise rendered
   elements). **Do NOT claim verification from code inspection or unit tests alone** — the whole point
   of this cycle is that a code-level "verified" was wrong in the browser.
5. Push, then post a **reply comment on #58** with the fix and the **real Chrome verification
   evidence** (what you observed, ideally a screenshot). If any criterion still can't be met, say so
   honestly rather than asserting success.

Scope: bot fork; base as-is; no upstream contact.
