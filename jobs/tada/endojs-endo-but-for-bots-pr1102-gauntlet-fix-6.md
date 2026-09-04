Gauntlet FIX round 6 for endojs/endo-but-for-bots PR #1102 (`design/claude-agents-capability`, a design-doc PR) — applied the panel-6 must-fix items, pushed as a review-feedback follow-up commit, CI green.

## What I did

Read the panel-6 verdict (round 6, must-fix; request-changes from critic, skeptic, decomplector, copyeditor, novice) and applied every finding to `designs/introduced-special-names.md` + `designs/README.md`:

- **critic** (assertion timing/coverage): pinned the reservation assertion as a **lazy per-agent-kind runtime backstop** (not a boot-time gate, since the hardcoded literals are only assembled at construction), with the forward-compat guarantee enforced at **build time** by a per-variant fixture set (guest, root host, child host, host+mail-hub).
- **skeptic 1** (host-path widening): named a concrete **root-host (`isRootHost`) test** asserting an introduced name binds indelibly with no interaction with `@secrets`, so the deliberate widening onto `provideHost` is covered rather than assumed by symmetry.
- **skeptic 2** (provider-side recreation): stated the provider re-minting a source capability under the same pet name → reject is an **accepted operational constraint** (provision once; use a stable forwarder to survive recreation), not a gap.
- **decomplector** (reincarnation): pinned "agent construction" to **include reincarnation**, with the reincarnation-time failure mode stated explicitly.
- **copyeditor**: resolved the three-way terminology drift (consistent "halves"; renamed the inner "daemon-owned half" → "hardcoded half"); replaced the undefined "same-round test" with "dedicated drift test (Phase 3)"; restructured the ambiguous README appositive.
- **novice**: relocated the #982 detour out of the problem statement into a new `## Relationship to #982` section; defined the pet-sitter at first substantive use; normalized the "assembled special-name set" label.
- **bonus** (ergonomist approve-seat + pedant comment-only, cheap): added a type-surface reject-vs-skip TSDoc note and a distinguishable-error-identity requirement; normalized `->` spacing.

Kept the doc's deliberate **em-dash-free** discipline (rewrote all 11 em-dashes I initially introduced into periods/parens/colons per the em-dash-style rule; verified zero remain).

## What changed
- `designs/introduced-special-names.md`, `designs/README.md` — commit `e1fa35ad3`, pushed via `safe-push-pr-head.sh` (`255f50f41..e1fa35ad3`).

## CI
`ci-wait-merge.sh --no-merge` → **rc 0, CI GREEN** (5/5 checks, 0 failed).

## Follow-ups
None for this stage. Per the gauntlet contract I did **not** re-run the panel; the driver re-posts panel-7.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1102-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 102 tokens (4213320 cached reads)
- Output: 34159 tokens
- Cost: $3.9829479999999986
- Wall-clock: 997s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
