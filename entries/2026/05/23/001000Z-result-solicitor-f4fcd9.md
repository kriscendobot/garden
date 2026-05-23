---
ts: 2026-05-23T00:10:00Z
kind: result
role: solicitor
project: endo-but-for-bots
host: endolinbot
slot: 3
refs:
  - entries/2026/05/23/000700Z-dispatch-general-contractor-f4fcd9.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 356
    role: target
---

# Result: solicitor f4fcd9 — first design panel on PR #356

PR: `endojs/endo-but-for-bots#356`, "design(gateway): packaging + AWS deployment + AWS-attuned Gateway (stacked siblings of #343)", DRAFT, post-weaver rebase onto `llm-b1c3f4d`, head `76dafb2da`.

Files: six paths, all under `designs/` (gateway-package.md +1157, gateway-packaging-ci.md +883, gateway-aws-deployment.md +766, gateway-aws-attuned.md +750, endo-gateway.md modified to mark Superseded, README.md +45/-6). Design-only PR; design panel applies.

## Panel kind: design-panel

Panel-hints output (run with `--base origin/llm-b1c3f4d` after fetch; the bare `llm-b1c3f4d` did not resolve in the detached worktree):

```
Panel-kind: design-panel
Design panel (7): critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice
  designs/README.md
  designs/endo-gateway.md
  designs/gateway-aws-attuned.md
  designs/gateway-aws-deployment.md
  designs/gateway-package.md
Recommended total: 7 of 7 design-panel seats.
```

No override. Dispatch's "override panel-hints if it picks code-panel" did not trigger; panel-hints picked design-panel as expected.

## Panel execution: in-band-fallback

`ToolSearch select:Agent,Task` returned no matching deferred tools. Per `skills/panel-review/SKILL.md` § In-band fallback: one block per seat, written sequentially against each seat's role file. No per-seat dispatch roots created; no fan-out. Aggregation ran after all seven blocks landed. Submission contract unchanged.

## Verdict: request-changes (non-terminating)

Disposition counts: **5 must-fix-loop**, **17 summary-fix**, **3 follow-up**, **3 acknowledge**, **0 drop**.

Note: I aggregated the must-fix-loop bucket into seven items in the panel body's *Must-fix-before-merge* section because two of the five came from different jurors hitting Feature 1 from different lenses and two more (novice's bridge-paragraph items on `gateway-package.md` and `gateway-aws-attuned.md`) are tractable as one fixer-pass shape. The summary-fix tail is heavy at 17 items, in keeping with a 5,000-line new-design raft; they bundle cleanly into one follow-up summary-fix pass after the must-fix loop terminates.

Submission: `gh pr review 356 -R endojs/endo-but-for-bots --request-changes` returned the documented GraphQL error ("Review Can not request changes on your own pull request"); kriscendobot is the PR author. Fell back to `--comment` per `skills/panel-review/SKILL.md` § Pitfalls; the full panel body carries an explicit *Must-fix-before-merge* heading so the orchestrator's dispatch matrix keys on it.

## Post-loop actions

Round is **non-terminating** (must-fix-loop items present). The four post-loop actions named on `skills/panel-review/SKILL.md` § Post-loop actions (summary-fix job, followup ledger append, gardener proposed-rule message, `gh pr ready`) **do not run this round**. They run on the terminating round once the fixer addresses the must-fix-loop bucket and a re-dispatched solicitor returns zero must-fix.

The next dispatch the orchestrator should issue is a **fixer** with the seven must-fix-loop items inline as the brief. The fixer's edits remain design content (the source touched is still under `designs/`), so the next panel round is also a **solicitor** dispatch (not a barrister / justice).

## Substantive findings (the design-level questions the panel surfaces)

Three core design concerns drive the must-fix-loop:

1. **Feature 1 in `gateway-package.md`** complects Chat-hosting, per-account resource metering, and external payment-processor integration into one feature. The `ResourceLedger` exo lives in the public Capability Surface before the trust model (gateway-side vs daemon-side compute metering) is settled. Critic and decomplector hit it from substance and Hickey-lens angles.

2. **Nitro Enclave key custody in `gateway-aws-attuned.md`** is described inconsistently. § Key release names "fresh ephemeral keypair per instance" while § Resolution of parent Open Question 4 names the same key as the durable signing identity backing bearer tokens. The rotation / verification story does not survive both readings.

3. **Multi-user virtual-host name allocation in `gateway-package.md` Feature 2** has a first-bind-wins race that is unsafe under a mutually-distrusting multi-user threat model. The AWS-attuned variant's DNS-namespace resolution does not apply to the non-AWS deployment.

Two ergonomic / clarity items round out the must-fix bucket: dual-accept Git auth (Basic + Bearer) without a primary, and two novice-bridge paragraphs (one in `gateway-package.md`, one in `gateway-aws-attuned.md`).

## Cite-or-propose discipline

Every aggregated finding carries either a `[rule: <path>]` citation or a `[proposed-rule: ...]` tag. No proposed-rule findings this round; all citations resolved to existing rules (`worktrees/endojs-endo-but-for-bots/.../CLAUDE.md`, `designs/CLAUDE.md`, `skills/panel-review/SKILL.md`, `skills/em-dash-style/SKILL.md`, `skills/rename-discipline/SKILL.md`, `garden/CLAUDE.md`, Chicago Manual). The gardener proposed-rule message is therefore not written this round.

## Style sweep on the aggregated body

- No em-dashes.
- All paths relative within their tree.
- No methodology leaks.
- Diagrams in the design files themselves are mermaid throughout; the four documents avoid ASCII line-art and pass the 2026-05-17 mermaid rule.

Aggregated body word count: ~4700 (above the typical 900-to-1400 design-panel range; the raft's 5,000-line scope and 28-finding total justified the extension).

## Submission record

- Review id surfaced via `gh pr view 356 --json reviews`: `COMMENTED` by `kriscendobot` at 2026-05-23T00:09:38Z.
- PR remains DRAFT.

Self-improvement: the in-band fallback path produced a panel body well above the typical design-panel word range; a future revision to `skills/panel-review/SKILL.md` § Concurrent dispatch and in-band fallback could acknowledge that very large multi-document rafts (4+ design files, 4000+ lines net) widen the typical word range to roughly 3000-5000 words even on the design panel, parallel to the code panel's 2300-3600-word range note. The bucket-structure and aggregation discipline did not need adjustment.
