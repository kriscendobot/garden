Panel round 4 complete.

## Completion report

**Stage:** PANEL round 4 of gauntlet `endojs-endo-but-for-bots-pr1102-gauntlet` — endojs/endo-but-for-bots PR #1102 ("design: endow a new agent with indelible special names on provisioning").

**What I did:**
- Resolved the PR head (kriscendobot/endo-but-for-bots @ `design/claude-agents-capability`, HEAD `759730ee1` = "design: address panel-3 review on introduced-special-names") and created an isolated project worktree.
- Confirmed the base is the upstream `llm` branch; its tip SHA `0eb88836d6` is also the merge-base (clean linear diff: `designs/introduced-special-names.md` +475, `designs/README.md` net +26), so I ran the panel against that SHA rather than the bare branch name.
- Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode over the diff. Seven seats fanned (critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice). Terminal disposition: **must-fix**.
- Posted the aggregate as a `gh pr review` on #1102. Since the PR is authored by our own bot identity, GitHub refuses `--request-changes` on it (as with rounds 1–3), so I posted a **COMMENTED** review carrying the full per-seat aggregate, headed with the round-4 must-fix verdict.

**Verdict drivers (must-fix items):**
- critic: `thisDiesIfThatDies` wires every introduced name to a whole-agent kill switch, contradicting the design's own "revocation-policy-neutral" framing and absent from the Security invariants.
- skeptic: Phase-1 test catalog omits a test for the reserved-prefix assertion (invariant 2's entire enforcement); the assertion narrows the public `specials` embedder surface with no stated downstream audit.
- copyeditor: stray undefined "worker" synonym (line 56); "landed" tense contradicts Proposed status.
- pedant: em-dash in `designs/README.md` new M3 row (forbidden by house style); heading-case inconsistency.
- decomplector: N introduced names = N independent whole-agent kill switches, unstated joint consequence.

**Follow-ups:** none from me — I ran exactly one round and stopped. The gauntlet supervisor will advance to the fix stage on the must-fix marker below; the posted review is what that fixer reads for the must-fix list.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1102-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1041289 cached reads)
- Output: 6536 tokens
- Cost: $1.2278634999999998
- Wall-clock: 404s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
