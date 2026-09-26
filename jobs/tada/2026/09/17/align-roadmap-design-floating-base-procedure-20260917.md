Done. The work is complete and landed on `main2`.

## Completion report

**Task:** Reconcile the roadmap-design base-branch procedure across three surfaces so a designer has one explicit path, not a documented default that the deterministic gate forbids except via an undocumented env override (`GARDEN_ALLOW_FLOATING_BASE=1`). Grounding: endojs/endo-but-for-bots#1300.

**Decision — option (c):** a roadmap-design PR takes a pinned base like every other fork PR. The "floating roadmap base" was never a justified exception — just imprecise "open a draft PR against the roadmap branch" wording in the designer role that read as bare `llm`. This keeps the gate maximally meaningful (no carve-out weakening it, no override on the happy path), and the design still lands on live `llm` at merge time via the skill's existing *Unfreeze before merge* step. The frozen-base gate's whole reason for existing — a floating base reviews the wrong divergence as the trunk moves — applies to design PRs no less than feature PRs, and the agoric-sdk design PR #18 already set the frozen-base precedent for a design.

**Changes (committed `b7f6d4e749` on main2):**
- `roles/designer/AGENT.md` — roadmap default, definition-of-done, and external-repo etiquette now target a frozen `llm-<sha>` snapshot per frozen-base-branch, never bare `llm`; explicitly steer away from the override; grounded in #1300.
- `roles/groom/AGENT.md` — same frozen-snapshot wording (groom lands "exactly as a designer lands a design" and hits the identical gate; fixed to prevent the same tax recurring there).
- `skills/frozen-base-branch/SKILL.md` — hard-precondition section now states there is **no floating-base exception for designs**; dated field note (2026-09-17) recording the reconciliation.
- `scripts/jobs/gardening/ensure-pr.sh` — the refusal message now names the frozen-base remedy with a concrete create-the-frozen-base recipe, names the roadmap-design case, and marks the override as a rare exception (not the roadmap path) — the failure is now self-correcting.
- `scripts/jobs/test/assert-pinned-base-test.sh` — added a ROADMAP DESIGN regression block (4 checks): bare `llm` is refused, the refusal self-corrects (names `llm-<sha>` + recipe), and a pinned `llm-6beb4e5` snapshot creates normally. Test passes 25/25; `ensure-pr-test.sh` still passes 32/32.

**Note:** I initially edited the deployed garden root by mistake; I reverted those edits and reapplied everything in the per-job worktree — the deployed root is untouched.

**Follow-ups:** none required. The gate is unchanged in behavior (option c needed no gate weakening); only its message improved.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/align-roadmap-design-floating-base-procedure-20260917.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 98 tokens (6015729 cached reads)
- Output: 37798 tokens
- Cost: $5.3737875000000015
- Wall-clock: 627s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
