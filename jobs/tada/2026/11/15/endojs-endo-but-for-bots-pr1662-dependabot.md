I've put PR #1662 (endojs/endo-but-for-bots) under embargo until 2026-11-16. It isn't old enough to merge yet. Everything else checks out, and CI is green after one small fix I pushed.

- **Change:** bumps `peter-evans/create-pull-request` from 8.1.1 to 8.1.2 in two workflow files, `update-action-pins.yml` and `update-action-pins-major.yml`.
- **Already on the base?** No. The `llm` branch pins 8.1.1 at both places, so this PR isn't redundant. The 27 commits between the two versions are 1 ahead and 0 behind the base.
- **Security advisories:** none for this action, so this isn't a security fix and the 7-day waiting period applies.
- **Upstream code:** 27 commits, nothing suspicious:
  - The `uuid` package is replaced by Node's built-in `crypto.randomUUID`.
  - A fix lets submodule deletions work when commits are signed.
  - The rest is development-dependency bumps and a regenerated build output.
- **CI:** the zizmor check (a workflow security scanner) failed on Dependabot's version. The `# v8` comment next to the pinned hash no longer matched, because the `v8` tag now points at 8.1.3. I pushed commit `f5dfab4e` to the PR branch, changing both comments to `# v8.1.2`, which is how the repo labels its other pins. All checks pass on that commit: 9 succeeded, 24 skipped.
- **Waiting period:** 8.1.2 was released 2026-11-09T08:46:04Z, so it reaches 7 days at 2026-11-16T08:46:04Z. It's the only version this PR moves.

What's in place:
1. **Verdict comment** posted on the PR: https://github.com/endojs/endo-but-for-bots/pull/1662#issuecomment-6900813348
2. **Ledger entry** recorded in the journal at `entries/2026/11/15/202539Z-message-botanist-48713a.md`.
3. **Recheck scheduled:** a one-time job, `dependabotany-recheck-endo-but-for-bots-pr1662`, runs at 2026-11-16T09:15:00Z. The existing daily recheck, `dependabotany-recheck-endo-but-for-bots`, is a backup.

When the recheck runs, it should merge the PR through the Dependabot auto-merge path, unless a new advisory appears or something supersedes the PR first. Version 8.1.3 (released 2026-11-10) also exists. Dependabot can propose it as a separate PR once this one lands.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1662-dependabot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1817807 cached reads)
- Output: 9645 tokens
- Cost: $1.1996453999999999
- Wall-clock: 726s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
