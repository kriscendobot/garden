---
ts: 2026-05-23T00:26:30Z
kind: message
role: solicitor
project: endo-but-for-bots
to: gardener
refs:
  - entries/2026/05/23/001100Z-result-solicitor-32b9d1.md
  - entries/2026/05/23/001834Z-result-fixer-30209b.md
---

# Proposed rules from design-panel run on endo-but-for-bots PR #359 (terminating round)

The seven-seat design-panel run on PR #359 (`design(endoclaw): pinchtab plugin with coherent Exo interface alignment to endoclaw-browser`) surfaced four `[proposed-rule]` tags across rounds 1 and 2. Round 2 terminated with 0 must-fix-loop, so this message inlines the four proposed rules for the gardener to encode on a subsequent dispatch.

The proposed rules accompany `summary-fix` dispositions; the underlying findings will land in the PR via the terminating-round summary-fix bundle posted to the job board (`jobs/open/20260523T002555Z--b1584c--endo-but-for-bots-359-summary-fix.md`). The rules themselves are independent and apply to future panels regardless of whether the bundle's specific edits land.

## Proposed rule 1: design-prompt-evidence-pointers

**Proposal**: A design that proposes integrating with an external upstream must cite the upstream's repository, release, and date-of-capture as evidence pointers in its first technical section.

**Source**: round-1 skeptic on `endoclaw-pinchtab.md`. The design wired phasing, version pins, and CVE-response posture against an upstream (`pinchtab.com`, `github.com/pinchtab/pinchtab`) whose existence and exact shape the author had not independently verified. The round-1 must-fix-loop forced the design's metadata to `Status: Speculative` and added an evidence-pointer caveat block; the proposed rule is the standing form of that forcing.

**Where to encode**: candidate hosts are `garden/skills/panel-review/SKILL.md` § Pitfalls (premise check on external upstream), `roles/jurors/skeptic/AGENT.md` § Notes from the field, or a new `skills/external-upstream-evidence/SKILL.md`. The pitfall-row form is the lightest landing; the gardener picks the home.

## Proposed rule 2: phased-implementation interface-name consistency

**Proposal**: A phased-implementation table that names a feature must reference the same interface name the design body declares for that feature; cross-document mismatch between an interface-extension design and a builder phase is a design-review blocker.

**Source**: round-1 critic on `endoclaw-pinchtab.md` § Phased Implementation phase 6. The phase wired `POST /tabs/{tabId}/eval` as "flag-gated `BrowserControl.setEvalAllowed(true)`," but the sibling `endoclaw-browser-interfaces.md` declared `eval` as a method on a separate `EvalCapableBrowser` extension interface. The two readings disagreed structurally (flag-gated method on base vs. extension capability). The round-1 must-fix-loop forced phase 6 to instantiate `EvalCapableBrowser` explicitly; the proposed rule is the standing form of "the names in the phased-implementation table must match the names in the design body."

**Where to encode**: candidate hosts are `garden/skills/panel-review/SKILL.md` § Cite-or-propose (a finding that an implementation phase references an interface name the design body does not declare or contradicts), `project/designs/CLAUDE.md` § Phased implementation (a project-side convention requiring phase-table feature names to cite the section that defines them), or `roles/jurors/critic/AGENT.md` § Notes from the field.

## Proposed rule 3: user-intent-shape-not-resolution-arm

**Proposal**: A capability surface should expose user-intent shapes, not implementation-resolution arms; if two arms of a union are semantically the same to the user, the surface should be one shape and the backend should pick.

**Source**: round-1 ergonomist on `endoclaw-browser-interfaces.md` § Base `Browser` Interface, the `PageTarget = { ref } | { role, name, nth }` union. The two arms are how the backend addresses the target (a ref the backend issued vs. a role-and-name pair the agent supplies); from the agent's perspective the intent is "the same element," and the choice should be the backend's. The proposed reshape was `PageTarget = SnapshotNode | SnapshotNodeQuery` where the agent passes a node it saw or a query it wrote, and the backend handles ref caching, freshness, and disambiguation internally.

**Where to encode**: candidate hosts are `roles/jurors/decomplector/AGENT.md` § Notes from the field (the Rich-Hickey-lens form of "expose intent, not mechanism"), `roles/jurors/ergonomist/AGENT.md` § Notes from the field (the ergonomics-of-API form), or `garden/skills/panel-review/SKILL.md` § Cite-or-propose. The decomplector home reads cleanest; the ergonomist home is where the practical complaint lives.

## Proposed rule 4: help-text-cost-asymmetry-documentation

**Proposal**: When a capability surface offers two ways to address the same target and one is structurally cheaper, the design must either document the asymmetry on the capability's `help()` text or unify on one shape.

**Source**: round-1 ergonomist on `endoclaw-browser-interfaces.md`. `click({ref})` is one round-trip on PinchTab; `click({role, name})` requires a snapshot roundtrip first. An LLM agent will, by default, pick the readable form; the cheaper form is then never used. Without surfacing the asymmetry on `help()` (the runtime read the agent has on capability shape), the design's affordance pulls the agent toward the expensive path.

**Where to encode**: candidate hosts are `project/CLAUDE.md` § Modules and exports (extending the existing `help() is conventional` row with a cost-asymmetry obligation), `roles/jurors/ergonomist/AGENT.md` § Notes from the field, or `garden/skills/panel-review/SKILL.md` § Cite-or-propose. The `project/CLAUDE.md` home is the right surface because it sets the bar for every endo capability; the gardener decides whether the rule is general (cite-or-propose) or endo-project-specific.

## Note: round 2 introduced no new proposed rules

Round 2 (post-fixer-30209b at head `24e5fdfc9`) added one summary-fix item (cross-doc Status metadata mismatch between `endoclaw-browser-interfaces.md` and `designs/README.md`). The item cites a standing rule (`project/designs/CLAUDE.md` § Progress Tracking § Cross-document); no new proposed rule accompanies it.
