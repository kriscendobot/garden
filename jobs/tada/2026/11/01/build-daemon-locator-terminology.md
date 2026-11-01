## build-daemon-locator-terminology: duplicate of the open PR #1498, so I did not open a new PR

The job said this design had no open PR, which was wrong. https://github.com/endojs/endo-but-for-bots/pull/1498 ("refactor(daemon): align locator terminology in docs, diagnostics, and CLI", branch `build/daemon-locator-terminology`, opened 2026-10-19) already delivers `designs/daemon-locator-terminology.md` and marks it Complete. That PR is out of draft, mergeable, with CI green. Its gauntlet ran three panel rounds and then halted at the undraft stage on a deadline overrun, but the PR is out of draft anyway. It is waiting on the maintainer. A second PR would duplicate it, so I opened none.

### What I did before finding #1498
Most of the design had already landed on `llm` (the new types, the hints in the locator format, `formatLocatorWithHints`, `locateWithHints`). I built the remaining rename in a worktree off `llm` at `9a14ddf660`. It overlaps #1498 heavily, but these parts are not in #1498:
- `parseLocator` also returns `peerKey` and `formulaAddress`, keeping `node` and `number` as aliases. This matches the design's dehydration example. The in-repo callers now read the new names: `manager.js`, `@endo/chat` (floot-transfer), `@endo/fae` (driver and subagent), `@endo/workflow`, `@endo/spaces-util`, and the daemon tests.
- `formula-identifier.js` error messages now say "Invalid formula key", "Invalid formula address" and "Invalid peer key".
- The unused `LOCAL_NODE` export is gone. The SQLite migration retired it.
- `docs/daemon-binary-spec.md` now writes the root file format as `{formulaAddress}:{peerKey}`.

### Test results
- **Unit tests:** the locator and formula-identifier tests pass, 60 of 60.
- **Daemon integration tests:** I ran the 34 `endo.test.js` tests that cover locate, invite/accept, adopt and the duplicate-accept race. All pass.
- **Other touched packages:** workflow (18), fae subagent tests (37) and the chat floot-transfer test (2) all pass.
- **Lint and types:** `tsc` for the daemon and for the repo root shows no errors in the touched packages. eslint reports no errors and prettier is clean.

To run the daemon tests I had to rebuild `better-sqlite3`, but only inside this job's worktree, after moving the old build aside. The warm-cache copy was built for node ABI 137, but the only node on the host is 22 (ABI 127). The worktree setup check reported "ok: loads under ABI 137" anyway, so that check reported the wrong ABI.

### Where the work is
It is one commit, `3f42eca6ca`, on the bot fork's branch `daemon-locator-terminology-followup` (kriscendobot/endo-but-for-bots). No PR is open for it.

### Follow-ups
- **#1498 needs the maintainer:** review it and merge it, or close it.
- **The extra commit:** once #1498 merges, the parts listed above could become a small follow-up PR. Rebase the commit onto `llm` and drop whatever conflicts with #1498. That is a choice for the maintainer and is not posted as a job.
- **Board record:** the board shows this design as having no PR. Whatever produced this job missed #1498, probably because #1498 has no job marker.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-locator-terminology.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 108 tokens (6011914 cached reads)
- Output: 29801 tokens
- Cost: $2.8940908
- Wall-clock: 610s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
