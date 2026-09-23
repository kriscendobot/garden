Job complete. Report follows.

---

## Completion report: `design-hardened262-all-environment-runs`

**Deliverable:** Design proposal `designs/hardened262-all-environment-runs.md` in `endojs/endo-but-for-bots`, opened as **draft PR #1066** against the `llm` roadmap branch (single-file diff). This is the named follow-up to maintainer review 5045929318 on #1064; it is **not** folded into #1064.

**What the design proposes:** Retire lockdown-only test selection by deleting the `onlyLockdown` front-matter flag from all 14 flagged cases so they run in every wired environment, adding a guard against reintroduction, and re-baselining with each newly-visible outcome classified.

**Key findings (all measured on-branch, not asserted):**
- The flag is consumed **generically** by `filterOnlyRules` (`only[A-Z]` → qualifier); it is referenced nowhere in `scripts/` or the golden test. Retiring it is a **corpus edit, not a harness-code change** — no code branch to delete, no golden-test change.
- **Complete inventory:** 12 `test/harden/*`, 1 `test/lockdown/function-frozen.js`, 1 `test/Compartment/prototype/Symbol.toStringTag-lockdown.js`. The Compartment case is **inert** (all agents already excluded → stays `zeroCoverage`).
- **Measured broadening delta:** +24 newly-passing and +14 newly-failing case-agent-scenarios, all in the previously-empty `module` column; `lockdownModule` untouched.
- **Surfaced parity divergence (the "clarity" payoff):** native XS freezes primordials **lazily on first `harden()`** (not ambiently); SES-on-XS **rides native `harden`**; the pure-JS **Node shim gates `harden` on `lockdown()`** (`harden` is `ReferenceError` pre-lockdown). This is exactly what the flag hides today.
- **Failure classification:** (1) genuine broadened coverage (24 xs/sesXs harden passes); (2) unsupported combination (11 sesNode harden failures — the shim's designed contract, not a defect); (3) lockdown postcondition (`function-frozen.js`, uniform across 3 agents). None require a change to SES or XS.

The design includes migration sequence, verification plan (rectangularity + no-regression + guard checks), rollback boundary (confined to `packages/hardened262/`), and 3 open questions on failure representation (failed vs skip, whether to broaden/split `function-frozen.js`, guard mechanism).

**Process notes:**
- Mermaid diagram parse-validated (`flowchart-v2`) before commit.
- Experimental flag-removal edits used only to measure the matrix, then reverted; only the design doc is committed.
- `ensure-pr.sh` initially returned INCONCLUSIVE (200-PR page-limit truncation); re-ran with `GARDEN_ENSURE_PR_LIST_LIMIT=1000`, which opened #1066.
- PR left **draft** per designer norms; its design-panel gauntlet is auto-staged by the completion machinery — no hand-posted gauntlet, no un-drafting.

**Follow-ups:** None blocking. The design's open questions are maintainer decisions for the design panel; a later builder implements from the doc as a separate change.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-hardened262-all-environment-runs.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 103 tokens (5623912 cached reads)
- Output: 49361 tokens
- Cost: $5.338871
- Wall-clock: 822s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
