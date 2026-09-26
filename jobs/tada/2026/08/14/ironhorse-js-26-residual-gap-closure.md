---
handed-off: ironhorse-js-26-residual-closure
deliverable-complete: false
---
Confirmed via js-25's dead-letter reply: js-25 genuinely completed (final head `b3c3ae93b8`, `cargo test --workspace --release` passed) — my measurement was on the correct final head, no collision. Everything is validated. Writing the completion report.

I completed the measurement-and-decomposition mandate of this job, but the core deliverable — closing every residual gap — is a multi-week engine effort I've durably handed to a named orchestration that owns all of it.

---

## Completion report — js-26 residual-gap-closure

**Situation on claim.** js-26 is the residual-closer in the serial arc `ironhorse-test262-implementation-completion-resume-6`. Its predecessor `ironhorse-js-25-temporal-integration` had terminated **unreported** (still in `jobs/doin/`, inbox dead-lettered). I confirmed via its dead-letter reply that js-25 genuinely finished — final pushed head `b3c3ae93b8` on `feat/ironhorse-262-language-completion` (PR endojs/endo-but-for-bots#970), `cargo test --workspace --release` passing — so I measured on the correct, quiescent final head with no collision.

**What I did.**
1. Set up an isolated project worktree, initialized the Moddable oracle submodule at the pinned `23b4d6b0`, built the workspace (release), and smoke-tested the XS-differential harness end-to-end.
2. **Ran the authoritative full-suite report** on PR head `b3c3ae93` at the exact required pins (test262 `be13516fb`, XS oracle `23b4d6b0`), whole `test/` tree, `full-run.sh --jobs 16 --oracle on`, 1930 batches.
3. Clustered every residual by causal reason and cross-tabbed against the 08-08 baseline.

**Totals (full 52,092-case tree), baseline 08-08 → current head `b3c3ae93`:**
- covered **4,740 → 23,496**
- unsupported **38,400 → 23,233**
- ironhorse-failure **19 → 194**
- skipped **8,932 → 4,406**, infrastructure **1 → 647**

**Residual = 23,427 actionable cases**, dominated by exactly the generic reasons the acceptance bar forbids: `unsupported-opcode:*` 10,313 (of which `u/v flag` 2,870, `with` 935, exotic-object MOP ~1,200, `eval:string-source` 664, dynamic-import 361, …), `ironhorse-aborted` 9,510, `abort-value-differs` 1,825, `parse-or-decode` 512, `non-primitive-completion` 351. This is a multi-week, multi-engineer engine-completion effort — categorically beyond a 7,200s handler budget.

**Decision (per the job's explicit directive).** I did **not** partially relabel, suppress, or add expectations. I posted a **serial, halt-on-failure nested orchestration** `ironhorse-js-26-residual-closure` with **15 data-grounded bounded causal children** (`ironhorse-js-26-ca…cz`) covering all 23,427 cases — each carrying its reason-family histogram, top subtrees, example paths, the shared branch/PR + pins, the full acceptance bar (real XS-oracle execution + Rust tests, no relabeling), the regression invariant, and a recursive "sub-decompose if too large" clause. Verified present on `origin/journal2` (orch + all 15 children).

**Regressions surfaced (accumulated across js-00–25; I made zero commits):** 6 genuine covered-path regressions (`Set.prototype.keys`, String `trimLeft`/`trimRight` refs, 3 strict `abort-value-differs`) + 19 `harness/*` reclassified; 194 new ironhorse-failures (185 = RegExp negative over-acceptances / missing regex early-error validation). All folded into the causal children (regex ones → cluster `ca`).

**Reported to maintainer** (via message-user): the scope escalation; a request to re-block `js-27-full-suite-report-refresh` and `js-28-issue-summary` on `ironhorse-js-26-residual-closure` so the report isn't refreshed before residuals close; and that `js-25` needs reaping out of `doin`.

**Head SHA:** `b3c3ae93b81c0f266458cd25f2f27d94ef80cc5b`. **PR:** endojs/endo-but-for-bots#970 — OPEN, draft, not merged. **Pins unchanged.**

**Follow-ups owned by the handoff:** all 15 causal clusters; the branch regressions; ordering of js-27/js-28 (needs maintainer/liaison action).

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-26-residual-gap-closure.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 129 tokens (5726055 cached reads)
- Output: 55561 tokens
- Cost: $5.467317500000001
- Wall-clock: 1279s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
