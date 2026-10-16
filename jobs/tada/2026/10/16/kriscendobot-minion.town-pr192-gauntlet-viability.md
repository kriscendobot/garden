**PR #192 viability check: proceed**

PR #192 is open, still a draft, and not merged. Nothing newer has replaced it, and the problem it fixes is still present on `main`, so the gauntlet can start.

Deciding question: Does current `main` still unpack the Node tarball into `/usr/local` with a plain `sudo tar` (no `--no-same-owner` and no ownership repair afterwards), with no other merged or open PR fixing that?

Answer: yes.

Evidence:
- **PR state:** `gh pr view` reports OPEN, isDraft=true and mergedAt=null. The PR was opened 2026-10-16T00:22Z by job `kriscendobot-minion-town-node-install-root-ownership`, as a follow-up to review comments on #171 (breaker #1, wire-watcher #5). It has no comments or reviews yet.
- **Base is current:** the PR's base `main-30a4c62` matches today's `main` (the comparison reports `identical`, 0 commits ahead). No newer base history could have displaced it.
- **The problem is still on `main`:** all three scripts still unpack Node with a bare `sudo tar -C /usr/local --strip-components=1 -xf /tmp/node.tar.xz`:
  - `deploy-app.sh:171`
  - `deploy-endo-daemon.sh:116`
  - `deploy-npm-registry.sh:115`

  None of them use `--no-same-owner` or follow up with a `chown`/`chmod`. `deploy/aws/scripts/lib/` on `main` has no `install-node22.sh` helper.
- **Not superseded:**
  - A search of the repo's PRs turns up only #122, which is merged and dealt with the checksum work this PR builds on, not with file ownership.
  - #171 is still open, and this PR's held-back step 2 is deliberately parked behind it rather than competing with it.
  - #154 (moving deploy scripts to JavaScript) is still open and unmerged, so it has not replaced these shell scripts.

I spent no clean, panel, fix, CI-wait or un-draft budget, and made no changes to the garden or the project repo.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr192-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (152105 cached reads)
- Output: 1725 tokens
- Cost: $0.369065
- Wall-clock: 34s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
