The review posted. The panel ran exactly one round, verdict is must-fix, and the aggregate is posted to the PR. This is a read-only gauntlet stage (no garden main2 changes), so nothing to commit or push.

## Completion report

Ran the PANEL stage (round 1) of the endojs/endo-but-for-bots #735 gauntlet.

- **PR:** #735 "design: Chat HTTP controller UI" — a design-only PR (`designs/chat-http-controller-ui.md` + `designs/README.md` roadmap entry), head `endojs:design/chat-http-controller-ui`, base `llm`, draft.
- **Setup:** obtained isolated project worktree of the PR head; resolved the real merge-base SHA `7746c21f9` from `gh api pulls/735 --jq .base.sha` (per the upstream-base normalization gotcha) rather than the bare `llm` branch name.
- **Panel:** ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 735 7746c21f9`. All 7 seats completed (critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice). Exit 0. Terminal disposition: **must-fix**.
- **Verdict posted:** aggregate posted to PR #735 as a `gh pr review`. `--request-changes` was rejected (GitHub forbids requesting changes on your own PR, since the head is authored by kriscendobot), so it was posted as a `--comment` review whose body leads with "round 1 verdict: **must-fix**" — the panel-verdict shape the next-stage-owed heuristic recognizes.

**Dominant finding (multiple seats):** the design is grounded in daemon infrastructure (`host.provideHttpClient` / `getHttpClientControl` / the `http-client` formula, cited as #661) that is not an ancestor of this PR's base and that the repo's own already-merged roadmap documents as superseded by the `@endo/fetch` / `@endo/confined-fetch` model — the grounding and phased plan need re-basing. Secondary must-fix/should-fix items: em-dashes and typist-hostile code points (`→ ✕ ⌘ …`), a broken inline code span, a missing Test Plan section, a revocation-detection gap for read-only viewers, and kill-switch confirm copy that overstates durability.

**Follow-ups:** this stage stops here (no fix, no un-draft). The gauntlet's next stage (fix-loop) owns the must-fix remediation.

No garden `main2` changes were needed (read-only review stage).

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr735-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 1 host(s)
- Input: 42 tokens (1327272 cached reads)
- Output: 7868 tokens
- Cost: $1.5360459999999998
- Wall-clock: 395s
- Model(s): claude-opus-4-8 ×6

<!-- garden-usage-end -->
