---
handed-off: endojs-endo-but-for-bots-pr1633-dependabot-conduct-endolin
deliverable-complete: false
---
**Verdict on PR #1633 (`preact` 10.29.8 → 11.0.2): MERGE-NOW. The PR is not merged yet.** This host's token gets a 403 when writing to endojs PRs, so I handed the merge to a successor job pinned to an endolin host.

**Review:**
- **Not superseded.** The base `llm` still resolves `preact@10.29.8`, and no other Dependabot PR moves preact.
- **Lockfile:** only `preact@11.0.2` moves, across 13 workspace manifests. No packages are added, it has no dependencies or install scripts, and the license stays MIT. The optional peer `preact-render-to-string` moves to `>=6.7.0`, but that package isn't in the tree. `@endo/preact-container` and `@endo/preact-social` already accept `^10 || ^11` as peers.
- **Maturity:** 11.0.2 was published 2026-10-23T15:47Z and is the only moved version, so the waiting period ended 2026-10-30T15:47Z. Both versions were published the same way (npm trusted publishing from GitHub Actions, approved by `jdecroock`, with attestations), so there's no publisher change.
- **Advisories:** OSV and GHSA show none on 10.29.8 or 11.0.2. The two known preact advisories cover other 10.x ranges only.
- **Source read:** I compared the two tarballs and found nothing suspicious: no `child_process`, network calls or `eval`. Preact 11 removes these:
  - automatic `px` on numeric style values;
  - `defaultProps`;
  - `Component#base`;
  - the `render(…, replaceNode)` argument.

  It also changes the `RefObject` type. None of the consuming packages use any of the removed APIs.
- **Main risk checked:** `@endo/preact-container` relies on preact's internal short names `options.__r`, `options.__e` and vnode `__`, plus the `vnode`, `diffed` and `unmount` hooks. All of them keep the same names in the 11.0.2 build, so the code's assumption still holds.
- **CI:** 28 of 28 checks passed on head `d562aea8` (run 41345250038), including lint, build, cover on Node 22 and 24, browser tests and the full test matrix. No migration commits were needed.

**What I did:**
- **Verdict comment:** posting it failed with 403 (`addComment`).
- **Successor job:** posted `endojs-endo-but-for-bots-pr1633-dependabot-conduct-endolin`, pinned to `endolin-garden-ece02cb4`; it's confirmed in `jobs/todo` on journal2. It re-checks the PR head, posts the verdict comment verbatim, merges with `ci-wait-merge.sh --dependabot-auto-merge`, checks the PR reads MERGED, and writes the final ledger row.
- **Ledger:** recorded an open row, `entries/2026/11/01/223452Z-message-botanist-6f758a.md` (`project: endo-but-for-bots`, `# Dependabotany` heading), naming the successor job.

**Follow-ups:**
- **Paused daily recheck:** the daily backstop recheck for this repo, `dependabotany-recheck-endo-but-for-bots`, is in `paused-schedules/`. I left it paused because someone paused it deliberately. If the endolin job stalls (endolin hosts have sat over their token cap before), nothing re-checks this PR automatically.
- **Durable fix:** the token on oros-studio still lacks pull-request write access on endojs.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1633-dependabot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 100 tokens (4317112 cached reads)
- Output: 19906 tokens
- Cost: $2.0803264
- Wall-clock: 5918s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
