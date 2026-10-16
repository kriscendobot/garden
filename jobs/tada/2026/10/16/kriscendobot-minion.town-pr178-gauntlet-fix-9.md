I applied the round-9 panel fixes to PR #178 (`git-remote-push-caps`) and pushed them. CI is green on the new head `c46036e`: the one workflow, "test (typecheck + vitest)", run 38870521993, finished with success.

**What changed** (three follow-up commits, pushed with `safe-push-pr-head.sh`, fast-forward from `21c0c05`):
- **`62566f9` fix(git-remote):**
  - **breaker:** a probe-sized POST (unencoded, `Content-Length <= 4`) now has a 4-byte body cap, so a longer body kills the CGI instead of getting past the rate and queue caps.
  - **corner-prober:** an empty cap variable now stops startup like any other malformed value.
  - **engine-realist:** the rate limiter now drops every partition whose pushes have aged out, not just the one being checked.
- **`0ce7669` test(git-remote):**
  - **corner-prober / fast-checker:** fast-check property tests for the sliding window (checked against a model over arbitrary push schedules), pkt-line framing, and cap parsing; empty and space-only values added to the invalid-cap cases.
  - **prover:** the "skips a push abandoned while queued" test now actually checks that no CGI starts after the slot frees.
  - **pruner:** the test-file inventory is cut to one sentence.
- **`c46036e` docs(git-remote):**
  - **archivist / pruner:** removed the file-touch and provenance lines from the design doc.
  - The "increment 1 deferred item 3" wording and the long `limits.ts` header were trimmed to one sentence in the fix commit, along with a few comments that only restated names.
- **PR body (integrator / pruner):** replaced the cap table with one line per setting, and dropped the "Before this change" paragraph, the refusal and test inventory, and the "Generated with Claude Code" footer. The `garden-job` marker is kept.
- I posted a summary comment on the PR for this round.

**Not changed:**
- **releaser (changeset):** the repo has no changeset tooling (no `.changeset/` directory, no CHANGELOG), so there was nothing to add.
- **benchmarker:** I didn't run a benchmark. I said in the PR comment that the code itself shows the claim: the size walk only runs on the non-probe POST path.
- **typist and wire-watcher:** the panel record marks both as must-fix but lists no items for them, so I had nothing to act on.

**Testing:** typecheck is clean and `test/git-remote/` passes 95 of 96 locally. The one failure is `capability.test.ts`, "propagates a git failure rather than reporting the ref absent". That file isn't touched by this PR, the test fails the same way with any temp directory, and it passes in CI, so it looks like a quirk of this host.

**Follow-up:** `ci-wait-merge.sh` couldn't read CI status here (this host's token lacks checks:read, and the GitHub API rate limit was exhausted during the run). I stopped it and polled the Actions runs API directly in the foreground until the run finished.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr178-gauntlet-fix-9.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2693339 cached reads)
- Output: 16461 tokens
- Cost: $1.5887037999999996
- Wall-clock: 1663s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
