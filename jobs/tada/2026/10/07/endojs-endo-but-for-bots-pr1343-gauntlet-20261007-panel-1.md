I ran panel round 1 on endojs/endo-but-for-bots#1343 at head `e6963911e`, and the verdict is **must-fix**.

**What I did**
- Made an isolated checkout of `kriscendobot/endo-but-for-bots@issue982-build-special-names`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against the PR's base commit `5feadae` (branch `feat/daemon-provisioning-grants-5feadae`). All 33 seats returned `ok` and the decider said `must-fix`. panel.sh printed the single-round terminal line, which in this mode always ends in `exit 0` after a verdict.
- Posted the aggregate (`round-1.md`, about 95 KB) as a `gh pr review` at 2026-10-07T20:30:42Z. GitHub refused `--request-changes` because the bot owns the PR, so it posted as COMMENTED. The body is part 1 of 2, headed "Panel round 1 — must-fix". It went over GitHub's body size limit, so part 2 is a follow-up PR comment (issuecomment-6046276166).

**Main must-fix findings (for the fix-loop)**
- `@main` is missing from `daemonReservedSpecialNames` in `host.js`, so an endowment can silently replace the guest's main worker.
- Retained-guest policy records written before this PR store `introducedNames` and have no `endowments`. In `provision/index.js`, `retainedEndowments` then comes out `undefined` and reconnect throws a `TypeError`. Either migrate the old field, default it, or state that the base branch is unreleased.
- No changeset covers `@endo/agentry`, whose behavior changes.
- The PR title understates a breaking change. Suggested: `feat(daemon)!: endow guests through one @-partitioned endowments map`.
- The PR body doesn't follow the project template: no Refs/Closes line and no Upgrade Considerations section.
- The rename sweep missed agentry prose: `packages/agentry/README.md:381-384` and `code-mode-provision-host.js:74` still describe `introducedNames`.
- One seat asks the PR body to say why `packages/lal` has `test:xs: "exit 0"`.
- Should-fix items include reconnect failing on a rebound or unbound special-name source, type-narrowing of `assertEndowments`, and `opts` → `options`.

**Follow-ups:** none from this stage. The gauntlet driver posts the fixer next.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1343-gauntlet-20261007-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (851802 cached reads)
- Output: 4714 tokens
- Cost: $0.6915524
- Wall-clock: 419s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
