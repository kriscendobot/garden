Clean stage for kriscendobot/minion.town PR #200 is done: I added test coverage, removed two orphaned exports, and CI is green at the new head `bfd0d8b`.

- **Starting point:** The PR was a draft with CI green at `12d9505`. The new routes, the bond store methods and the settings menu already had tests, but nothing tested the deletion state files.
- **Coverage added:** a new `test/web/deletion-state-files.test.ts` with 6 tests covering:
  - the account-deletion audit log, which writes one JSON line to its file and to stderr, and rejects if the file can't be written, so deletion is refused;
  - the one-way guest tag, which never contains the credential;
  - the deleted-guest file, which skips malformed lines, appends new entries, survives a reload, treats a missing file as empty, and rethrows any other read error;
  - where both files go: an explicit override first, then the first systemd `STATE_DIRECTORY`, otherwise none.
- **Dead code removed:**
  - `guestUrl` in `deploy/aws/www/home.js`. Its only caller was the copy-guest-URL panel this PR deletes, so I also removed its test and type entry in `test/home-page.test.ts`.
  - `ADD_RECOVERY_URL` in `deploy/aws/www/settings.js`. This PR added it but nothing uses it, since `index.html` hard-codes the link.
- **Local checks:** typecheck is clean. The full suite had 1243 passing and one failure, in `test/git-remote/capability.test.ts`, a file this PR doesn't touch. That failure is the known local-only git-wrapper false failure, and CI passes it.
- **Push:** one commit, `bfd0d8b`, pushed with `safe-push-pr-head.sh` as a fast-forward from `12d9505`.
- **CI:** all three checks passed (`test`, Claude harness amd64 and arm64), and `ci-wait-merge.sh --no-merge` returned rc 0. I ran it as three short waits in the foreground. The full wait took about 70 minutes, a little over the 3600s budget, because the repo has a single ephemeral self-hosted runner with several PRs queued ahead.

**Follow-up:** that one runner is a bottleneck for minion.town CI; runs from 08:48 were still queued at 09:45, so later gauntlet stages will be slow to get CI too.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr200-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (2673801 cached reads)
- Output: 13569 tokens
- Cost: $1.5043802000000002
- Wall-clock: 4462s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
