Undraft complete for endojs/endo-but-for-bots#1582 ("ci: run Browser Tests on any base and pin runners to Ubuntu 24.04"). The PR is now ready for review on the head the panel passed.

**Advisory appellate pass.** I ran a short `claude -p` review of the 2-file diff (+7/−3). It is advisory only and did not block the undraft. Points worth knowing:
- Dropping the `branches: [master]` filter means Browser Tests will now run on PRs against frozen bases and `llm`. Their first runs there may go red for reasons the PR itself didn't cause.
- Other workflows that still use `ubuntu-latest` and rely on `tred`, Playwright or `bwrap` may hit the same breakage. They should be checked with a grep.
- The new `ubuntu-24.04` pins have no exit plan. They need a TODO or a tracking issue so they don't stay forever.
- For depcheck, installing whatever provides `tred` (or dropping the dependency on it) would last longer than pinning the runner.
- The "Playwright 1.60.0" in a code comment will go stale when Playwright is bumped.
- Minor: the new trigger comment sits between `name:` and `on:`. It belongs just above `pull_request:`.

**Gate and mutation.**
- **Before:** the PR was OPEN, `isDraft=true`, and `headRefOid=55f7733e83fc94b140259b61436e8c364a8e123a`, which matches the panel-passed head.
- **Action:** ran `gh pr ready`, which succeeded.
- **After:** `isDraft=false`, and the head is still `55f7733e83fc94b140259b61436e8c364a8e123a`.

**Follow-ups (optional):**
- Sweep the remaining workflows for `ubuntu-latest`.
- Add tracking notes to the two pins.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1582-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (176384 cached reads)
- Output: 1258 tokens
- Cost: $0.41144479999999994
- Wall-clock: 47s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
