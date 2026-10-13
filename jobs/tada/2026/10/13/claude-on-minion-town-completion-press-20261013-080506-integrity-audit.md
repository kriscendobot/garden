## Integrity audit of Claude-on-minion.town completion-press tick 2026-10-13 08:05:06Z (issue https://github.com/kriscendobot/garden/issues/89)

No completed job carries `orchestration-failed: true`, and every design and build deliverable I checked exists. Three things still matter for the arc. The `…-072006-split` orchestration halted while its failed child is running again. PR #183 was un-drafted with the last panel verdict still must-fix. Three gauntlet stages for #167, #183 and #186 have been waiting in todo for 3 to 4.6 hours.

This was evidence-only. I made no changes to the board, journal, issues or PRs, sent no messages and pushed nothing.

### Evidence base
- **Board commit:** fresh `origin/journal2` = `68d8db866600a7045de6cd4b6dae74b43a41535a` (commit time 2026-10-13T22:14:11Z). I fetched it at 22:14:33Z from this job's worktree with the repo lock held, using `GARDEN_FETCH_MAX_AGE_OVERRIDE=0 git fetch origin journal2`. I took a snapshot with `git archive <sha> jobs work schedules` and read that.
- **Roster:** I rebuilt it with the deterministic wrapper, which applies the parent spec's three selector rules (exact bases, prefixes and the designs orchestration; literal arc references; job-reference expansion):
  - `scripts/jobs/claude-on-minion-town-completion-report.sh --since 2026-10-13T01:50:07Z --until 2026-10-13T08:05:06Z --repo $PWD --ref 68d8db86…` (W1, the tick window; prior ref `1f526ec74e9c`)
  - the same command with `--since 2026-10-13T08:05:06Z --until 2026-10-13T22:14:11Z` (W2, the tick to HEAD; prior ref `af319386604a`)
- **Repository checks:** read-only `gh pr view`, `gh api …/pulls/N`, `…/actions/runs?head_sha=`, `…/issues/N/timeline` and `…/issues/N/comments`, and `git/trees/<branch>?recursive=1`, run 22:22–22:30Z. The bot token cannot read `statusCheckRollup` (GraphQL 403), so CI status comes from the Actions runs API, not the full check rollup.

### Counts (from the wrapper)
| | W1 | W2 |
|---|---|---|
| Roster | 627 | 641 |
| Claims | 9 | 43 |
| Completions | 6 | 36 |
| `orchestration_failed: true` | 0 | 0 |
| `absent_prior_roster` | 0 | 0 |
| New dooms (`doom_delta`) | 0 | 4 |
| Stalled claims | 0 | 2 |

- **W2 locations:** tada 622, plan 9, todo 4, doin 4, orch 1, gauntlet 1.
- **New dooms in W2:** all `requeue-exhausted`, all recorded on `endolin-garden-ece02cb4`, and all retried by their gauntlets:
  - pr183-panel-6 at 12:53:30Z
  - pr167-clean at 13:23:31Z
  - pr181-fix-6 at 13:23:31Z
  - pr167-panel-1 at 19:13:36Z
- **Stalled claims in W2:**
  - `minion-town-arc-press-20261013-152006`: oros monk-8, claimed 19:47Z, 6434s past its 2400s budget.
  - `claude-on-minion-town-completion-press-20261013-200507`: oros, claimed 21:06:35Z, 1656s past budget.

### 1. Failure declarations and halt/refusal prose
I read all 40 completion reports from W1 and W2 (`jobs/tada/2026/10/13/*.md`), grepping for halt, refuse, blocked, not done and failed.

**None has `orchestration-failed: true`.** The real halts are:
- **`jobs/tada/2026/10/13/claude-on-minion-town-press-20261013-072006-split.md`:** `orchestration-status: halted`, with `halt-failed-child: claude-on-minion-town-press-carry-20261013` (stalled 2474s against a 2400s budget on oros). `claude-on-minion-town-press-unblocks-20261013` remains parked in plan, 11h08m since 11:06:37Z. This is a halt of an arc orchestration.
  - **Integrity concern:** the halted child is running again. It was claimed by oros monk-6 at 14:15:58Z, reaped at 18:23:36Z and re-claimed by oros monk-4 at 22:01:22Z, so it is now on its second claim. Its orchestration is already closed as halted, so anything it produces will not release the unblocks child.
- **`jobs/tada/2026/09/29/endojs-endo-but-for-bots-pr1015-gauntlet-20260929.md`:** halted because the PR was on a floating base. This is historical: endo#1015 later merged into `llm` on 2026-09-29, as the press-audit report confirms.
- **Gauntlet roots with `gauntlet-status: review-budget-reached` (not failures):**
  - pr180, 8/8 rounds, $18.62
  - pr181, 6/6 rounds, $14.37
  - pr183, 7/7 rounds, $15.71

  Each report says "Unaddressed must-fix: unknown · list unavailable". The pr180 and pr183 roots each completed twice in W2 (08:44/16:20 and 15:29/16:41) because extra rounds were granted.
- **"Not done" and "refused" in fix and panel reports:** these name should-fix items left for a later round. "Refused" in the pr183 reports means GitHub rejecting request-changes on a PR the bot authored, or the feature's own `needs-containment` refusal. None of it is a job refusing work. Every fix and panel stage ends with a `gauntlet-stage-result` of `fix=done`, `panel=must-fix` or `panel=pass`.
- **"Blocked" in the `minion-town-arc-press-*` reports (030506, 060506, 090507, 120507):** these refer to issue-58's #93, which waits on the halted rolling deploy. That is sibling-arc context, not issue-89 work.

### 2. Orchestration progress
| Orchestration | State | Advanced since the prior window? |
|---|---|---|
| `claude-on-minion-town-designs` | complete since 2026-09-08 (`jobs/tada/2026/09/08/claude-on-minion-town-designs.md`); all 7 children tada with no failure declaration | Nothing left to advance (terminal) |
| `endojs-endo-but-for-bots-pr1015-gauntlet-20260929` | halted 2026-09-29; the PR later merged | No (historical) |
| `claude-on-minion-town-press-20261013-072006-split` | halted 14:57:17Z at child 2/3 | No. The unblocks child has waited 11h08m; carry is re-running (see §1) |
| `claude-on-minion-town-completion-press-20261013-080506-split` (`jobs/orch/`) | running, serial, halt policy | Yes. Roster-audit finished 15:48:29Z. This job was promoted about 15:51Z and claimed at 21:56:55Z, so it waited about 6h in todo. `…-080506-publish` is still in plan |

- **Out of roster:** `jobs/orch/endo-minion-town-guest-locator-federation.md` is also running, but none of the three roster rules selects it (no issue-89 URL), so I did not audit it.

### 3. Deliverable spot-checks
**Designs** (the seven designs-orchestration children):
- **minion.town `main`:** `designs/claude-agents-capability.md`, `claude-agent-credential-reauth.md` and `claude-on-minion-town-evaluation.md` all present.
- **endo `llm`:** `designs/endo-guest-stdio-mcp.md`, `daemon-guest-bot-incarnation.md`, `endo-claude.md` (the bare caplet) and `endo-claude-inference-backends.md` all present.
- **garden `main2`:** `designs/claude-harness-provisioning.md` present.

**PRs in kriscendobot/minion.town:**
| PR | State | Head | Base | CI (Actions) |
|---|---|---|---|---|
| #183 | OPEN, **not draft**, MERGEABLE | `78df7d858b` | `main-bc11010` | success |
| #167 | OPEN, draft, MERGEABLE | `8368f8c66a` | `main-a5a557a` | success |
| #186 | OPEN, draft, MERGEABLE | `f10693fcb6` | `design/root-canary-principal-8368f8c` | success |
| #180 | OPEN, draft, MERGEABLE | `d38139ce5a` | — | success |
| #181 | OPEN, draft, MERGEABLE | `51ac555ee5` | — | success |

- **#183:** head matches pr183-fix-7's report.
- **#167:** head matches the push reported by `kriscendobot-minion-town-pr167-record-answers-20261013`.
- **#186:** this is the `build-minion-town-root-canary-20261013` deliverable, so the claimed output exists.
- **#180 and #181:** heads match the fix-8 and fix-6 reports.

**No completed job's claimed output is missing.**

### 4. Outcomes that could block the arc, and integrity concerns
1. **#183 was un-drafted with must-fix outstanding.**
   - The timeline shows `ready_for_review` at 2026-10-13T17:42:53Z by kriscendobot. A PR comment at 17:42:56Z says "Un-drafted for the proxy screen". Panel round 7 (16:02Z) was **must-fix**, and the root report says unaddressed must-fix is "unknown".
   - The un-drafting job is **unknown**. The provenance footer says host oros, garden `9e4b600c`. The most likely candidate is `claude-on-minion-town-press-carry-20261013`, which held a claim on oros at that moment, but I have not verified it.
   - The proxy-screen gauntlet `kriscendobot-minion-town-pr183-screen-78df7d85-gauntlet` has its viability stage waiting in todo since 17:47:14Z (4h27m).
2. **Gauntlet stages unclaimed in todo:**
   - `kriscendobot-minion.town-pr186-gauntlet-viability`: since 17:35:09Z (4h39m)
   - `kriscendobot-minion.town-pr167-gauntlet-20261013-panel-1`: since its retry at 19:14:08Z (3h00m), with stage_retries 1/2. Another `requeue-exhausted` would exhaust the retry budget.
   - Both #186's gauntlet and #183's screen gauntlet fall outside the wrapper's roster, so the roster misses them.
3. **Root canary waits on the maintainer.** `validate-minion-town-root-canary-login-20261013` has been parked `awaiting-maintainer` since 17:22:40Z. It needs interactive login/MFA, and the issue #89 comment at 17:43:23Z already raised it. #186 is stacked on #167's design branch, so it depends on #167 landing.
4. **Stale and incorrect claims in completed press reports:**
   - **`claude-on-minion-town-press-20261013-133505`** says `revise-minion-town-pr167-root-canary-answers` "isn't on the board or in any record I could find". It then edited the issue #89 body based on that. In fact that job completed at 10:19:30Z, with report `jobs/tada/2026/10/13/revise-minion-town-pr167-root-canary-answers.md`, which declares `handed-off` to the pr167 gauntlet. The report blames a stale `journal` checkout.
   - **`claude-on-minion-town-press-20261013-102024`** (completed 16:45Z after about 4h25m in flight) describes #183 as "draft, … gauntlet fix round 3 active". By then fix round 7 was under way.
   - **The 17:43:23Z issue #89 comment** says the root-canary build "is running". It had completed at 17:38:21Z.
5. **Remaining doin and todo:**
   - doin `minion-town-arc-press-20261013-152006`: waited about 4h27m in todo before its claim
   - todo `claude-on-minion-town-press-20261013-193508` (2h39m)
   - todo `minion-town-arc-press-20261013-182028` (3h54m)
   - todo `minion-town-arc-press-20261013-213517` (39m)
6. **Carried board anomaly:** `kriscendobot-minion.town-pr181-gauntlet-fix-5` is still in both `plan/` and `tada/`, as the roster-audit reported.

### Open questions for the publisher
- Who un-drafted #183, and whether un-drafting at review budget with must-fix outstanding is intended under the arc's inverted-review policy.
- Whether the re-claimed carry job should run at all now that its orchestration is halted.
- Whether todo stages waiting while oros claims slowly means idle workers or a wedged host. This is not provable from the journal; the roster-audit noted the same.
- The roster rules leave out the #186 and #183-screen gauntlets.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/claude-on-minion-town-completion-press-20261013-080506-integrity-audit.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (2399187 cached reads)
- Output: 18847 tokens
- Cost: $1.5927533999999994
- Wall-clock: 720s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
