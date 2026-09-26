The review is posted. The panel completed, disposition is **must-fix**, and the verdict is now on the PR as a COMMENTED review carrying the `must-fix` marker (request-changes was rejected by GitHub for a bot-authored PR, so a comment review is the correct fallback the next-stage-owed heuristic accepts).

## Completion report

**Job:** PANEL round 1 of the endojs/endo-but-for-bots PR #673 gauntlet ("design: binary media on the fetch surface (bytes() and stream())").

**What I did:**
- Resolved the PR head (`endojs:design/endoclaw-fetch-bytes-stream`, base `llm`, draft, design-only diff touching `designs/README.md` + `designs/endoclaw-fetch-bytes-stream.md`).
- Provisioned an isolated project worktree keyed to this job base; resolved the real base SHA `08f5accf6785ee747db3751955502e54f5eb7387`.
- Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode. The design panel fanned 7 seats (critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice); all completed `ok`. Terminal disposition: **must-fix**.
- Posted the aggregate as a `gh pr review`. GitHub rejected `--request-changes` (bot-authored PR); posted as a `--comment` review instead, with the `<!-- garden-panel-verdict: must-fix round=1 -->` marker and per-seat findings in the body.

**Verdict:** must-fix. Six seats requested changes; copyeditor approved. Load-bearing findings: the design's "ungated today / same-vat" premise cites a `endoclaw-oauth.md` § that doesn't exist in the landed doc (only in unmerged #621); the "already denies" read-only method-gating is described in present tense but isn't implemented anywhere; a diagrammed remote-interim path the design text disclaims providing; buffered-vs-streaming mode complected into one `FetchResponse` type (contradicts the design's own Decision 6); `code:`-tagged errors diverge from the existing message-only `exo-http-client` convention; undefined load-bearing terms (vat/CapTP); one em-dash-style nit.

**Follow-ups:** none from this stage — a single round, no fix/un-draft. The gauntlet's next stage (fix-loop) owns the must-fix findings.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr673-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 1 host(s)
- Input: 46 tokens (1568507 cached reads)
- Output: 8916 tokens
- Cost: $1.7730835
- Wall-clock: 673s
- Model(s): claude-opus-4-8 ×6

<!-- garden-usage-end -->
