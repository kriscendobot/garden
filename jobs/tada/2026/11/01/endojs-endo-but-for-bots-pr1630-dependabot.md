# Botanist report: endojs/endo-but-for-bots#1630 (zizmorcore/zizmor-action v0.7.1 → v0.8.0)

**Verdict: MERGE-NOW. Done:** the PR merged at 2026-11-01T20:14:42Z as merge commit `bcbde90bee97ed7c25ec2d76b1092563bda955f0`. `llm` now pins `zizmorcore/zizmor-action@53290bad… # v0.8.0`.

**Checks:**
- **Base census:** `llm` uses this action in one place, `.github/workflows/zizmor.yml:41`, still at v0.7.1 (`85b2b9fb`). The base was behind the target, so the PR was not superseded. The watcher had already found no sibling PR.
- **Pin check:** the v0.8.0 tag points to `53290badfa369cb0bf7ad16342cb62c2fa47ac7b`, the same hash as the diff, and the `# v0.8.0` comment matches. The release was published 2026-10-23T06:13:19Z.
- **Upstream source** (4 commits ahead, 0 behind):
  - `action.sh` adds a `prerelease` option and accepts prerelease version strings.
  - Inside the action, `github/codeql-action/upload-sarif` moves to v4.38.3 (`24c54180`). That step never runs here because our workflow sets `advanced-security: 'false'`.
  - The rest is new pinned prerelease lockfiles, README edits and upstream-only CI.
  - `zizmor-latest.txt` did not change, so our default `version: latest` installs the same zizmor as before.
  - Nothing new runs at install time or touches the network.
- **Maturity:** the newest moved version is v0.8.0 itself. Its 7-day floor was 2026-10-30T06:13Z, which has passed.
- **Advisories:** none for zizmor-action. The one `github/codeql-action` advisory (GHSA-vqf5-2xx6-9wfm) only affects versions up to 3.28.2, so v4.38.3 is clear.
- **CI:** merged through `ci-wait-merge.sh --dependabot-auto-merge`, which waits for green CI on the checked head.

**What changed:**
- Posted the verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1630#issuecomment-6563171571
- Merged the PR.
- No garden repo changes.

**Follow-ups:** none. Nothing was embargoed, so no ledger row or recheck schedule was needed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1630-dependabot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (737510 cached reads)
- Output: 5172 tokens
- Cost: $0.7499979999999998
- Wall-clock: 709s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
