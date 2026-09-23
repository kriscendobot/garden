Inbox empty. Done.

## Completion report

**Built the missing standing audit for uncovered design PRs** — the third gauntlet-coverage layer that `auto-gauntlet-handoff.sh` and `assert-design-pr-gauntlet.sh` already presuppose ("left for the design-gauntlet sensor/audit") but which never existed. Grounding incident: `kriscendobot/minion.town#47`, a security-critical ocap-redesign design PR opened **non-draft** on 2026-08-16 that sat over a day with zero review and no gauntlet — the exact non-draft-at-birth case both completion-time scripts deliberately decline (the #671/#867 force-draft hazard).

**What changed** (7 new files, pushed to `main2` as `e08fcc809a`):
- `scripts/jobs/design-pr-gauntlet-coverage-audit.sh` — deterministic, no-LLM sweep: walks open PRs across the journal's `comment-repos/` watch set, keeps bot-authored/OPEN/design-only PRs (reusing `design_only_paths`), skips probes and the garden's own repo, and stages a gauntlet (`post-gauntlet.sh`) for any with no coverage — **regardless of draft state and never touching it** (staging a record neither drafts nor un-drafts, so the under-review hazard the two sibling scripts guard against doesn't arise here). Coverage check mirrors the sensor's exact triple: PR-keyed `gauntlet_record_for_pr` (active, any base) **plus** base-keyed `gauntlet/` and `tada/` (a completed run) so a finished gauntlet isn't re-staged every tick.
- `scripts/systemd/garden-design-pr-gauntlet-audit.{service,timer}` — hourly (`*:37`), leader-gated via `ExecCondition=is-main-host.sh`, self-heal-wrapped, auto-installed by `install-units.sh`'s glob (no registry edit needed).
- Test + 3 committed stubs (`design-pr-gauntlet-coverage-audit-test.sh` and PR-source/gh/stager-spy stubs, committed rather than generated under `/tmp` because it's mounted noexec). Asserts the audit stages exactly the uncovered non-draft, draft cases; leaves covered/completed/code/non-bot/probe/own-repo PRs alone; and is idempotent on re-run. Passes; sibling bypass test still passes; shellcheck + `bash -n` clean.

**Live acceptance test** (the job invited staging any real gaps found): the audit surfaced **4 more uncovered minion.town design PRs** beyond #47. I staged the two genuine gaps — **#37** (`ocap-mailboxes`) and **#21** (`weblet-gateway`) — for real; **#41** (`git-remote-capability`, another non-draft miss) and **#39** (`git-content-substrate`) already had **completed** gauntlets in `tada/` (which drove the `tada/`-check fix above). A fresh real sweep now reports all 5 minion.town design PRs covered, zero false re-stages.

**Follow-up:** the units deploy on the next deliberate `deploy-garden` (not done from this job). Once deployed and leader-gated, the timer will catch fleet-wide gaps on its cadence; I limited real staging to the grounding repo (minion.town) rather than mass-staging every watched repo from a single gardener job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-pr-gauntlet-coverage-audit.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 120 tokens (7076551 cached reads)
- Output: 61952 tokens
- Cost: $6.561968500000001
- Wall-clock: 1022s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
