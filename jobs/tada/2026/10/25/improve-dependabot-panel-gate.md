## Completion report: `improve-dependabot-panel-gate`

On the verified Dependabot path, `ci-wait-merge.sh` no longer requires an agent panel that never runs; a deterministic check replaces it. All 144 tests in `scripts/jobs/test/ci-wait-merge-test.sh` pass, and shellcheck reports nothing new. It's pushed to main2 as `daaa3d299a4`. PR #1550 won't merge until the root checkout picks up that commit.

**Why it stalled.** `--dependabot-auto-merge` still required an exact-head panel record before merging. No agent panel is ever staged for a Dependabot bump, so the validated MERGE-NOW on endojs/endo-but-for-bots#1550 stalled with `panel-head-blocked reason=missing`.

**What changed in `scripts/jobs/gardening/ci-wait-merge.sh`**
- **When the new check applies:** only when the existing check already passed — the live author is Dependabot and the repo is in the bot-owned scope. In that case a new `dependabot_head_gate` runs instead of the panel check.
- **What it checks:** one live read of `headRefOid,author,commits` at the final merge point must show all of:
  - the author is still Dependabot (both the `dependabot[bot]` and `app/dependabot` forms are accepted);
  - the head is exactly the post-rebase commit whose CI was accepted;
  - every commit has at least one author, and every author is `dependabot[bot]` or the garden bot. The garden bot is allowed so the botanist's own fix-up commits don't block the merge.
- **On failure:** it refuses to merge, alerts the maintainer, and prints `dependabot-head-blocked reason=unreadable|author-changed|head-changed|foreign-commit-author`. The merge job stays claimable.
- **Merge pinned to the checked commit:** on this path the merge, and the auto-merge fallback, now pass `--match-head-commit <verified head>`. Nothing pushed between the check and the merge can land.
- **Unchanged:** the CI, author, rebase, CHANGES_REQUESTED and approval checks all still run. Every other mode, including a Dependabot call that fails the author or repo check, still requires panel coverage.
- I updated the header comments and the exit-code list to match.

**Tests (T51–T58, beside T47–T50).** The stub `gh` now answers the new read; by default it returns one Dependabot-authored commit at the head.

| Test | Scenario | Result |
| --- | --- | --- |
| T51 | Verified Dependabot PR, no panel, no approval | Merges, pinned to the head; panel sensor never called |
| T52 | Dependabot mode, human author | No merge |
| T53 | Ordinary merge mode, Dependabot author, no panel | Still blocked with `panel-head-blocked reason=missing` |
| T54 | A commit by another author | No merge |
| T55 | Head moved after CI | No merge |
| T56 | Final read fails | No merge |
| T57 | Extra commit by the garden bot | Merges |
| T58 | CHANGES_REQUESTED | No merge |

I also added a note to `roles/botanist/AGENT.md` § MERGE-NOW describing the new check.

**Follow-ups**
- Once the deploy lands, re-run or requeue the #1550 botanist conduct: `ci-wait-merge.sh endojs/endo-but-for-bots 1550 --dependabot-auto-merge`. Its single commit is authored by `dependabot[bot]`, which I confirmed with a live read, so it should pass the check.
- If a human pushes a commit to a Dependabot branch, the PR will block with `foreign-commit-author`. That's deliberate: the maintainer has to step in rather than the merge going ahead without review.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-dependabot-panel-gate.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1353267 cached reads)
- Output: 13702 tokens
- Cost: $1.2504534
- Wall-clock: 163s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
