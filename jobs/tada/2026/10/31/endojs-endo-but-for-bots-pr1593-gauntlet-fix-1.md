orchestration-failed: true

## Gauntlet FIX round 1: PR #1593

**Fix pushed, but CI is red.** `ci-wait-merge.sh` returned rc 3 with `lint = FAILURE` (1 of 36 checks failed). I stopped there, as the job says. I did not dig into the lint failure: the one log grep I tried returned nothing useful. The next stage needs to read the failing lint log.

**What I changed** (commit `2e6118cff9`, pushed with `safe-push-pr-head.sh`, advancing from `c85ead3775`):
- **Must-fix (archivist):** `designs/daemon-agent-tools.md` no longer lists `makeHttpTool` as future work. I updated the Status, Remaining list, tool-group table row, network-tier paragraph, Implementation Plan intro and Phase 3.6 checkbox. Network plugin provisioning stays listed as remaining.
- **Should-fix (archivist):** the `workspace.js` header now describes the full set of composed capabilities (filesystem, Git, GitRemote, Shell, HttpClient) instead of "the trio".
- **Changeset-auditor:** I rewrote `.changeset/agent-tools-workspace-provisioning.md` as concise sentence-per-line release notes and dropped the M3 test-sequence commentary.
- **Corner-prober:** I added two tests in `workspace.test.js`: `filesystem + git + shell + http` composing without a name collision, and `provisionWorkspaceTools` combining `http` with a Git-derived filesystem. The workspace tests pass locally (14 passed).

**Not done:** the purist's should-fix, to disambiguate colliding tool names (`fetch` between HTTP and GitRemote, `inspect` between Shell and GitRemote) inside the workspace catalog. It needs a tool-naming decision across several makers, so it is a follow-up for the maintainer or the next round. The collision still fails closed.

I did not re-run the panel.

<!-- gauntlet-stage-result: fix=still-pending -->

Note on the marker: none of the three allowed values describes a red result, and the job asks for `orchestration-failed: true` instead of `fix=done`. `fix=still-pending` is the least-wrong marker, but the driver should read the red lint result, not the marker.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1593-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 28 tokens (881322 cached reads)
- Output: 5414 tokens
- Cost: $0.3887042 (1 engagement(s) unpriced)
- Wall-clock: 1261s

<!-- garden-usage-end -->
