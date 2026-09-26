The round-4 panel verdict is posted. This stage is complete.

---

**Completion report — Gauntlet PANEL round 4, kriscendobot/minion.town PR #48**

Re-derived state from a clean requeue: panel rounds 1–3 and fix rounds 1–3 had already completed (all in `jobs/tada/`); fix-3 left the PR at head `12f5eda`, and no round-4 review existed yet. This attempt ran the missing round.

What I did:
- Rediscovered the PR head (`kriscendobot/minion.town` @ `feat/git-content-substrate-serving`, draft, base `main`, head `12f5eda`) and confirmed only rounds 1–3 were posted.
- Provisioned an isolated project worktree keyed to this job's base and ran the panel in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 48 main`). 34 seats fanned; panel exited 0 with disposition **must-fix**.
- Synthesized the concatenated aggregate into a concise round-4 verdict and posted it as a `gh pr review` on PR #48. `--request-changes` is refused by GitHub on the bot's own PR (as in rounds 1–3), so it posted as a COMMENTED review carrying the must-fix wording the next-stage heuristic recognizes.

Verdict summary: six seats request changes. **Must-fix:** (1) `advanceVhostContentRoot` reports false-positive success under concurrent CAS (`vhost-table.ts:395-422`); (2) security-invariant contracts (`normalizeSourcePath`, `rootQualifyHtmlWithOffsets` sentinel-offset equivalence) need property tests + a `fast-check` devDep; (3) fresh abbreviated identifiers (`bf*`, `ct`, `attrOffsets`); (4) missing completion-summary comment for `12f5eda`. Should-fix tail: reserved-prefix case mismatch, misleading `Object.freeze(new Set)`, `srcset` `\s` vs ASCII whitespace, DEPLOYMENT.md TTL-staleness overclaim + untracked deferrals, `resolveLimits` edge tests, unverified new-line coverage.

Stopped here as instructed — no fix, no un-draft, no loop. A subsequent fixer stage owns the items.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-git-content-substrate-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 54 tokens (1577325 cached reads)
- Output: 13987 tokens
- Cost: $1.7706625000000003
- Wall-clock: 807s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
