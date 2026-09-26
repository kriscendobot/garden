Panel round 4 complete.

**What I did**
- Resolved the PR head (`endojs:bot/build/1125-readonly-directory-attenuation`, base `llm-387ea66`, SHA `387ea66146a0b64d9d94a858369b0d37b09c55db`) and provisioned an isolated project worktree keyed to this job's base.
- Ran the code panel in single-round mode: `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 1304 387ea66…`. It fanned all 31 seats, aggregated, and the decider returned **must-fix** with **exit 0** (a genuine verdict, not a sensor failure).
- Posted the aggregate as a `gh pr review` on PR #1304. `--request-changes` was rejected by GitHub ("Can not request changes on your own pull request" — the PR is bot-authored by `kriscendobot`), so per the panel-review skill's self-authored fallback I posted the full 86 KB aggregate as a `--comment` review (submitted 2026-09-18T05:23:18Z; verdict preserved in the body). 10 of 31 seats returned request-changes.

**Headline finding (from the aggregate)**
- A revocation-race must-fix: in the read-only view path (`directory.js` and the `mailReadableView`/`messageReadableView` builders in `manager.js`), `context.onCancel(...)` is registered only after an `await`, and `Context.onCancel` silently drops the hook if already cancelled — a cancel landing in that window latches the view live forever, defeating the attenuation invariant the PR asserts. Plus orthographer prose divergences (`cancelled`→`canceled`, `behavioural`→`behavioral`).

**Follow-up worth surfacing to the liaison/maintainer**
- Maintainer `kriskowal` already left an `APPROVED` review "Please conduct." on this PR at 04:46:56Z — *before* this panel round posted its must-fix at 05:23:18Z. There is now a standing conduct/merge request against a PR the panel says has an unresolved revocation-race defect. Reconciling that (the driver's fix stage vs. the maintainer's merge instruction) is outside this single panel stage's lane, but the divergence should be raised before anyone conducts.

Stayed strictly in-lane: one panel round, verdict posted, no fix/un-draft/loop.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1304-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1291082 cached reads)
- Output: 8590 tokens
- Cost: $1.7404700000000002
- Wall-clock: 691s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
