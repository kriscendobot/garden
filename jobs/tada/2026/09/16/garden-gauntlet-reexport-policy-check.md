Done. The design is landed and the review PR is open, marked, draft, and notified. Writing the completion report.

## Completion report

**Job:** `garden-gauntlet-reexport-policy-check` (designer, garden's own repo)

**What was asked:** @erights, on `endojs/endo-but-for-bots#475` (comment `3450576324`), asked the garden to propose standing machinery that prevents every plain-re-export policy violation and stops the fleet from authoring new ones — reviewed by both @kriskowal and @erights before landing.

**What I did:**
- Studied the existing gauntlet plumbing to reuse established patterns rather than invent: the cost-gated seat-gate model (`seat-gate-orthographer.sh` + `orthographer-divergence-grep.sh`, wired into `panel.sh`'s `seat_review`) and the author-time `pre-push-gates/probes/*.sh` shape (`no-inline-import-jsdoc.sh`).
- Wrote **`designs/reexport-deprecation-policy-gauntlet.md`** — a proposal with defense-in-depth around one policy skill:
  - `skills/re-export-deprecation-policy/SKILL.md` — the policy home (statement, the `export … from` forms, what a compliant `@deprecated` shim is, exemptions, `reexport-policy-exempt` opt-out marker).
  - `scripts/jobs/gardening/pre-push-gates/probes/no-plain-reexport.sh` — a deterministic no-LLM **author-time** probe that fails the push gate on an added bare re-export lacking a deprecation.
  - `roles/jurors/reexport-auditor/AGENT.md` + `seat-gate-reexport-auditor.sh` — a cost-gated code-panel seat (orthographer pattern) reusing the probe as its pre-pass for **review-time** adjudication.
  - Author-facing norm lines for builder/fixer/web-builder.
  - Scope, test plan, alternatives, and 5 explicit Open questions for the maintainers.
- Validated the mermaid diagram parses (`OK flowchart-v2`, via `mermaid.parse`).
- Landed the design on `main2` (commit `a6c25be`, rebase-CAS push).
- Per the garden's own-repo open-questions carve-out: snapshotted the pre-design commit as frozen base `main2-a57dd05`, put the design commit on `design/reexport-deprecation-policy-gauntlet`, and opened **`kriscendobot/garden#95`** via `ensure-pr.sh` — draft, marked `<!-- garden-design-open-questions -->`, diff = exactly the one design file, body @-mentioning both maintainers with the open questions inlined.
- Messaged the maintainer (via liaison) naming the PR and the two-reviewer request.

**Verified (real execution):** mermaid parse OK; `git push … main2` accepted; `gh pr view 95` → draft, base `main2-a57dd05`, head `design/…`; `gh pr diff 95 --name-only` → only `designs/reexport-deprecation-policy-gauntlet.md`; `ensure-pr` recorded `#95`; inbox drained (empty); maintainer message delivered.

**Deliberately not done (proposal stage):** the probe/seat/skill are specified but **not implemented**, `reexport-auditor` is **not** wired into `GARDEN_CODE_SEATS`, `#475`'s `compare.js` re-export is **not** fixed (separate fixer concern). PR left **draft**; no gauntlet posted (manual-gauntlet regime).

**Follow-ups (owned by the maintainers / a later build):** answer the 5 open questions on `kriscendobot/garden#95`; a follow-up `build` then implements the probe, seat, gate, and skill and lands the role norm edits. No successor job posted — the ball is with the reviewers, as @erights requested.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-gauntlet-reexport-policy-check.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1814849 cached reads)
- Output: 25044 tokens
- Cost: $2.556597499999999
- Wall-clock: 397s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
