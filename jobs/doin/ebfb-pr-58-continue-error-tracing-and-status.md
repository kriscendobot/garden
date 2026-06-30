# PR #58 — continue error-tracing toward acceptance criteria + answer kriskowal's status question

**Repo:** `endojs/endo-but-for-bots` (bot direct push; bot identity).
**PR:** https://github.com/endojs/endo-but-for-bots/pull/58 — *feat(daemon,cli): error
tracing across CapTP workers (#1879)* — OPEN, head `feat/error-tracing-implementation`,
base **`llm-a1dcc70`** (frozen base — honor frozen-base discipline).

**Why this job exists:** kriskowal asked **"What's the status of this effort?"**
(comment 4848100199, 2026-06-30T21:34Z) with acceptance criteria, and the garden only
👀-acknowledged it — no reply comment, no active job. The maintainer is waiting.

**Acceptance criteria (kriskowal).** Running `/js throw new Error("x")` should produce in
the chat UI **all** of:
1. **The error message** — `x` in the error bubble (already works today).
2. **A stack trace** — the full trace surfaced alongside the message, not just the bare message.
3. **A clickable worker chip** — a button/chip identifying the worker that produced the error;
   clicking it brings up **Show Value** for that worker. The chip MAY identify by reverse
   lookup or present as an **anonymous** worker for now (until a better shortest-formula-
   retention-path story).

(Context already on-branch: the `EndoHost` interface guard exceeded `@endo/patterns`' 80-method
limit and blocked daemon start; the three privileged introspection methods `getFormula`,
`getFormulaGraph`, `traces` now sit behind a `host.diagnostics()` sub-capability `EndoDiagnostics`.)

**Task:**
1. Assess #58's current state against criteria 1–3.
2. Implement the unmet criteria: surface the **stack trace** alongside the message, and add the
   **clickable worker chip → Show Value** (anonymous-worker chip is acceptable for now).
3. **Verify** by actually running `/js throw new Error("x")` and confirming all three appear in
   the chat UI (use the run/verify path; don't assert from code alone).
4. Push to the PR branch, then **post a status REPLY COMMENT on #58** answering kriskowal's
   question: what's done (criterion 1 + the diagnostics sub-cap fix), what this change adds
   (2, 3), what remains / known limitations (anonymous chip), and the verification result.

**Standing rule (this triggered the directive):** an acknowledged maintainer comment gets at
least a **reply comment**, not just a reactji — make sure the status reply lands on #58.

Scope: bot fork; frozen base `llm-a1dcc70`; no upstream-of-endo contact.

---
claim:
  host: endolinbot2
  gardener: 2
  claimed_at: 2026-06-30T22:51:10Z
