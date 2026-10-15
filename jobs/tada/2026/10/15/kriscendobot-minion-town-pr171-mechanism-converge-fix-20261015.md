I finished the work on PR #171 last session. I emitted the completion signal with an extra `<`, so it didn't register. I checked the PR again just now and nothing has changed: head `22ca484`, base `main-30a4c62`, still a draft, and both CI runs on that head passed.

**What I did:**
- **Rebased onto a new frozen base.** `main` had moved and conflicted with the PR in `.github/workflows/prod-probe.yml` and `DEPLOYMENT.md`. I froze `main` at `main-30a4c62`, rebased the PR onto it and moved the PR's base there.
  - The `probe` job keeps `needs: harness` and takes `main`'s `PROBE_RUNS_ON` runner setting.
  - The `harness` job now follows `PROBE_RUNS_ON` too. Otherwise, when hosted Actions minutes run out, `probe` would wait on a `harness` job that never starts.
  - The failure-issue reporter is `main`'s version, plus the PR's reference to issue #89.
  - Every other PR file is byte-identical to the old head `f5b24a4`.
- **The repeated mechanism stays as built.** The decomplector finding came from round 8; round 9 had no decomplector seat. Neither simpler form it suggested keeps the guarantee:
  - Passing the path list as an SSM parameter would let the caller choose what root reads.
  - Keying the probe's sign-in to the `main` branch would let one token assume either the probe role or the deploy role.

  The PR body now says this in one sentence, and I trimmed it to 296 words, under the 300-word limit a reviewer seat flagged in round 8.
- **Round-9 findings.** There were no correctness or security must-fixes from the saboteur, breaker, locksmith or wire-watcher. The stylist's renames had already been fixed in `f5b24a4`. The breaker and wire-watcher both noted that root runs `/usr/local/bin/node`, which the check doesn't cover. Commit `02033b1` documents it as trusted rather than checked. The deploy scripts unpack the Node tarball with its archive owner (`iojs`), so adding it to the strict root-ownership check now would probably fail every run. I confirmed the owner from the tarball listing, not on the live box.
- **Pre-push gate.** The `prefer-endo-primitives` probe failed on the PR's `node:crypto` SHA-256 calls. Commit `22ca484` adds justified exempt markers: `@endo/sha256` is unpublished, and the on-box observer uses Node built-ins only by design.
- **Verification.** The pre-push gates (11 stages), the node tests (37/37), the vitest tests and typecheck all pass. The workflow linter isn't installed on this host, so the workflow wasn't linted locally. I posted a summary comment on the PR and resumed the gauntlet at the panel stage (round 10, 2 extra rounds).

I left the comment-only hardening suggestions alone. These are re-checking the environment's branch policy on each run, tying the sign-in to the workflow file, and the account-wide grant to read SSM command output.

**Follow-up job posted:** `kriscendobot-minion-town-node-install-root-ownership`. It installs Node root-owned at all three install sites. After #171 merges, it adds the interpreter and its directories to the check and removes the "trusted" paragraph.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr171-mechanism-converge-fix-20261015.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 134 tokens (6719832 cached reads)
- Output: 30034 tokens
- Cost: $5.839410599999999
- Wall-clock: 2333s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
