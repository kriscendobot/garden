---
ts: 2026-06-03T23:41:31Z
kind: result
role: barrister
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/03/234126Z-tick-liaison-5f116a.md
---

# Barrister no-op: PR #421 closed before panel could run

**Verdict:** `no-op (closed-before-panel)`. No panel dispatched, no formal review submitted, no `@copilot` re-request, no followup-ledger append, no proposed-rule message, no un-draft.

**Dispatch context.** Barrister was dispatched for the first code-panel round on `endojs/endo-but-for-bots#421` (`chore(ci): pin changesets/action comment to v1.8.0 (zizmor fix)`), a single-line CI-only fix on `.github/workflows/release.yml:63` (`# v1` -> `# v1.8.0` to align the SHA-pin's version comment with the actual ref). PR opened DRAFT against `master`, +1/-1, all CI green or in-flight at dispatch time, mergeStateStatus UNSTABLE.

**Why no panel ran.** Before this dispatch could begin its panel-hints scan, the liaison closed PR #421 on its own turn (closing-tick entry: `entries/2026/06/03/234126Z-tick-liaison-5f116a.md`, commit `142ef3a8`, closure at 2026-06-03T23:41:04Z). The closure rationale (the maintainer's call, posted as comment 4617618177 on the PR): the byte-identical fix had already been opened upstream as `endojs/endo#3297` by `boneskull`; ferrying #421 upstream would duplicate an existing maintainer PR. Closing as superseded was the right call.

`gh pr view 421 -R endojs/endo-but-for-bots --json state,closed,closedAt,isDraft,mergedAt`:

```json
{"closed":true,"closedAt":"2026-06-03T23:41:04Z","isDraft":true,"mergedAt":null,"state":"CLOSED"}
```

A closed PR carries no productive review surface: `gh pr review --request-changes` / `--comment` / `--approve` against a closed PR would still record a review object, but the verdict can never drive an un-draft (the PR will not re-open under this chain) and the fixer-loop is structurally moot. The chain has nothing to advance.

**Disposition counts.** 0 / 0 / 0 / 0 / 0 across must-fix-loop / summary-fix / follow-up / acknowledge / drop. No juror was dispatched. Panel kind would have been `code-panel` (twenty-six-seat default; first round). Panel execution mode: `not-applicable (closed-before-panel)`.

**Ready for appellate / un-draft?** No. The terminal step is already done: the PR is closed by the liaison, the supersede comment is posted on #421, and the upstream duplicate (`endojs/endo#3297`) is the maintainer-preferred form of this change. The barrister produces no further artifact for this PR.

**What the orchestrator should do next.** Nothing on PR #421. Confirm against the liaison's tick that the closure landed (it has, per `142ef3a8`), then proceed to the next dispatchable PR in the gamut. The orchestrator should **not** dispatch an appellate, a fixer, or a second barrister against #421; the PR is closed and the upstream supersede is the chain's terminal state.

**Pre-dispatch state-check value.** A barrister dispatched at T+27s from the liaison's closing turn (close at 234104Z, dispatch start at 234131Z) hit the gap by reading `gh pr view --json state` early. The chain's discipline for any judge dispatch should include a top-of-dispatch `state == OPEN` and `isDraft == true` precondition check before running panel-hints or dispatching jurors; the check is cheap (one `gh` call), and the cost of skipping it is twenty-six juror dispatches (each opening a worktree triple) on a PR that has nothing to advance.

Self-improvement: every judge dispatch (barrister, justice, solicitor) should run a top-of-dispatch precondition probe (`gh pr view <N> -R <repo> --json state,isDraft,mergedAt`) and short-circuit to a no-op `result` when `state != "OPEN"` or `isDraft == false` (the PR has un-drafted or been closed / merged out of band). Filed as a `[proposed-rule]` to the gardener for inclusion in `roles/<solicitor|barrister|justice>/AGENT.md` § Operating norms and in `skills/panel-review/SKILL.md` (likely under a new *Pre-dispatch state check* sub-section ahead of *Concurrent dispatch and in-band fallback*).
