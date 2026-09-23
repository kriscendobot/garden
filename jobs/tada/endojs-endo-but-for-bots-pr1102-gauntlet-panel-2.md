The round-2 panel review is posted (07:21:55). The job is complete.

Panel round 2 — endojs/endo-but-for-bots PR #1102 ("design: endow a new agent with indelible special names on provisioning").

**What I did**
- Resolved PR head (`kriscendobot:design/claude-agents-capability`, base `llm`) and got an isolated project checkout keyed to this job's base.
- Ran `panel.sh` in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1`, base-ref `HEAD~1` so it diffed exactly the 2-file design commit — `designs/introduced-special-names.md` new + `designs/README.md` index rows — not the stale-`llm` artifact). An earlier attempt was reaped mid-fan, so I cleared the partial rundir and re-ran clean.
- Panel disposition: **must-fix** (`panel #1102: design-panel single-round — must-fix`; 31KB aggregate in the rundir).
- Posted the aggregate to the PR. `--request-changes` is rejected by GitHub on the bot's own PR, so — exactly as round 1 did — I posted it as a `--comment` review with the disposition stated in the header (`## Design panel — round 2 — disposition: must-fix`), the shape the next-stage-owed heuristic recognizes. Confirmed live at 2026-09-04T07:21:55Z.

**Substance of the verdict (representative must-fix findings)**
- Persisting a formula identifier does not deliver the stability Design decision 4 claims: a host pet name can resolve to a late-binding `lookup` formula, so a later host rebind can silently change the recipient's "indelible" capability (defeats invariant 4).
- Conflicting re-provision silently no-ops: `provideGuest`/`makeChildHost` short-circuit to the existing (immutable-formula) agent, so a second provide with new `introducedSpecialNames` yields an agent silently missing the intended indelible capability — the exact failure §Security-invariants #3 forbids; the phase-2 "idempotent" test never covers divergent options.
- Plus should-fix/comment items: no withdrawal/GC-pinning story, dynamic per-agent-kind daemon-owned-name collision set, stale code anchors, backwards `designs/README.md` graph edge, `**Revised**` vs convention `**Updated**`, missing receiving-side example.

**Follow-ups**: none for this stage — I did not fix, un-draft, or loop, per the single-round contract. The gauntlet's fix stage owns the must-fix items.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1102-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 52 tokens (1323930 cached reads)
- Output: 9964 tokens
- Cost: $1.923415
- Wall-clock: 332s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
