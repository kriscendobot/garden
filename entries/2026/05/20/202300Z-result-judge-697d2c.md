---
ts: 2026-05-20T20:22:43Z
kind: result
role: judge
dispatch_id: 908016
dispatch_root: /home/kris/dispatches/judge--908016
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 327
    role: source
---

# Result: design-panel review on PR #327 (request-changes)

PR #327 ("docs(designs): daemon mount and git capability plans", author 0xpatrickbot, branch `pc-daemon-mount-git-designs`).
Cross-author dispatch: the maintainer 0xpatrickdev pinged @kriscendobot at 2026-05-20T20:11:41Z requesting a panel review.
The PR is design-only (file paths under `designs/` only: `daemon-mount-capabilities.md` +725, `daemon-git-capability.md` +1083, `daemon-git-remotes.md` +1013, plus `README.md` and `daemon-agent-tools.md` updates), so the design panel of seven seats was dispatched per `roles/judge/AGENT.md` § Panel-kind discrimination.

**Panel kind:** design-panel.
**Panel execution:** in-band-fallback (the harness surfaced no `Agent` / `Task` tool; each seat block was written one at a time against the per-seat role file in `garden/roles/<seat>/AGENT.md`, then aggregated).
**Panel composition:** the seven design-panel seats: critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice.

## Verdict

`gh pr review 327 -R endojs/endo-but-for-bots --request-changes` submitted at 2026-05-20T20:22:43Z.
`reviewDecision: CHANGES_REQUESTED` confirmed.
Three `must-fix-loop` items block clean acceptance.

## Disposition counts

- **must-fix-loop:** 3
  - Sample-code bug in `daemon-git-capability.md` § Sample Use: `E(worktree).entry('README.md')` missing `await`.
  - Internal contradiction in `daemon-git-capability.md` Design Decision 7: auto-re-pin-on-first-commit vs "guests cannot mutate the pin" / "re-pinning is host-side".
  - Sibling-spelling incoherence in `daemon-mount-capabilities.md` § `EndoMount` interface: rest-parameter vs array-parameter path forms across sibling methods.
- **summary-fix:** 11 (sentence-per-line markdown style throughout; ASCII flow diagram in mount-capabilities § Snapshot Semantics → mermaid; git version-pin justification feature-cite; read-only construction-paths forward-pointer to Decision 8; bundle-trade-off symmetric-cost gloss; semicolon-chain splits; `switch()` family-coherence; `GitRemote.inspect()` shape declaration; "What you should know first" preamble on docs 2 and 3; pet-name argument gloss; copyeditor's list-parallel-structure fix).
- **follow-up:** 3 (in-flight auth-failure / transport-error tests; hidden-facet restart premise citation or prerequisite; snapshot missing-file-race semantics).
- **acknowledge:** 3 (the deliberate worktree-vs-tree shape trade-off acknowledged in § Alternatives Considered; the Entries-as-Mini-Capabilities rejection as a positive decomplecting example; the three-doc series shape with "Read in order" preamble as a positive pattern).
- **drop:** 3 (console.error sample-use consistency; em-dash policy clarification; Windows-specific procedure detail).

## Cite-or-propose ledger

Eight findings carry `[rule: ...]` citations to standing rules (project CLAUDE.md, designs/CLAUDE.md, CONTRIBUTING.md § Markdown Style Guide, skills/rename-discipline, skills/relative-paths, skills/panel-review § Cite-or-propose, roles/pedant § Layered project rules).
Five findings are tagged `[proposed-rule: ...]`, one each for: feature-versioned pin justifications, in-flight protocol test catalog completeness, multi-doc "what you should know first" preamble, design-decision symmetric-cost rationales, and API method-family suffix consistency.

A `message: panel → gardener` entry follows on this dispatch with the proposed-rule texts inlined for the gardener to consider on a subsequent dispatch.

## Drop rationales (one-line each)

- console.error in Sample Use was confirmed as project-conformant (CLAUDE.md § Diagnostic discipline).
- Em-dash usage: peer design docs in the same directory use em-dashes freely; the project does not forbid them (the garden's em-dash-style rule applies to garden-internal documents only).
- Windows-specific verification gap in the bearer-token spike: Windows is out of Phase 1 scope and the spike already names it; the procedure detail is more naturally addressed at spike-execution time.

## Recommended next stage

The orchestrator should dispatch a **fixer** against PR #327's three must-fix-loop items.
The fixer's brief should be:

1. `daemon-git-capability.md` Sample Use: add `await` to `E(worktree).entry('README.md')` or restructure the example.
2. `daemon-git-capability.md` Design Decision 7: pick one of (a) unborn-repo case auto-re-pins on first commit, with carve-out to "guests cannot mutate the pin", or (b) unborn-repo case fails-closed until host re-derives, with the "next successful commit triggers a re-pin" sentence revised.
3. `daemon-mount-capabilities.md` § `EndoMount` interface: choose one path-argument form across the surface and apply, or add an inline justification for the deliberate split.

The fixer should not address the summary-fix bundle in this round; that work happens on the terminating round per `skills/panel-review/SKILL.md` § Dispositions (summary-fix lands as a job-board post after the loop terminates).

The follow-up items are not in scope for the fixer-loop; they accumulate on the per-PR followup ledger at termination.

## Cross-PR / cross-package findings

None outside PR #327's own scope.
The trio's design content composes coherently across the three documents and with the prior `daemon-mount.md` / `daemon-capability-filesystem.md` / `platform-fs.md` design family.

## Post-loop actions

Not yet applicable; this is a non-terminating round (three must-fix-loop items).
On the terminating round, the judge will: post one `summary-fix` job to the job board bundling the eleven summary-fix items; append the three follow-up items to `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--327.md`; un-draft via `gh pr ready 327` (note: PR is already `isDraft: false`, so `gh pr ready` is a no-op if still not in draft at that point); write the proposed-rule message to the gardener.

Self-improvement: the in-band-fallback procedure absorbed the design-panel run cleanly at seven seats; the 1735-word aggregated body fit within the 900-1400 design-panel target's +25% upper bound; no role / skill changes warranted from this dispatch.
