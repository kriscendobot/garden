Reworded `roles/botanist/AGENT.md` step 6 so fixer escalation is conditional, and pushed to `main2` as `fb951897d3`.

**What changed** (`roles/botanist/AGENT.md`, step 6 *Shepherd CI to green*):

- The old clause read as an unconditional route: "classify the failure (flake vs. real) and route it: a real in-scope failure is a `next: fixer` escalation…". A botanist that had already diagnosed and could fix the break was still nominally handing it off, burning a fixer job to re-derive a known diagnosis.
- The new clause makes self-repair the default and escalation the fallback: repair on the PR's head branch and drive CI green when the diagnosis is already in hand and the fix fits inside this PR (naming the upgrade-forced lint/type/test churn as the ordinary case), and citing that the CI-fix push is already implicit in the shepherd discipline the step reuses, per `roles/COMMON.md` § External-repo etiquette.
- The escalation path is intact verbatim for genuine blocks: a real in-scope failure the botanist cannot fix, or whose fix belongs outside this PR's diff, is `next: fixer`; a conflict is `next: weaver`; anything deeper is `next: liaison`.
- Added a reporting requirement: the verdict says which path was taken, and on escalation what stopped the botanist from landing the repair.
- Bumped the frontmatter `updated:` to 2026-07-29. Also dropped the `vs.` shorthand in the touched sentence per `skills/no-latin-shorthand`; the new prose adds no em-dashes, keeping the file compliant with `skills/em-dash-style`.

**Scope note:** kept the edit inside step 6 as the job specified. I did not add a matching *Anti-patterns* bullet ("do not escalate a break you have already solved"), which would be the file's usual companion shape; say the word and it is a one-line follow-up.

Inbox drained at completion, empty.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-endojs-endo-but-for-bots-pr867-dependabot-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 17 tokens (478468 cached reads)
- Output: 5386 tokens
- Cost: $0.8669819999999998
- Wall-clock: 87s

<!-- garden-usage-end -->
