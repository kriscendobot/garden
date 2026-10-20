The code-level must-fixes from panel round 3 are pushed to PR #201 and CI is green on `d419715`. The PR still must not merge: the maintainer hasn't ruled on the authority question, and nothing in this round changes that.

**What I fixed (five commits, `0ebfe34..d419715`, pushed with `safe-push-pr-head.sh`):**
- **Origin check on the mint route** (`56cda19`, spec-keeper and wire-watcher): the old check compared only the host, so `http://minion.town` passed for the https site. When Fetch Metadata is missing, `POST /account/clips/new` now compares the full origin (scheme, host, port) with `config.resourceUrl`. Only the exact `same-origin` and `none` tokens count as proof; an unknown value like `SAME-ORIGIN` is ignored and the origin check decides. New tests cover the wrong scheme, a wrong port, `none`, and unknown tokens.
- **Double clicks in the clip page** (`d7291ca`, saboteur 1–3): entries, crumbs and Back now navigate from the view they were drawn in, so a second fast click can't open `docs/docs` or empty the app stack into the error page. The three action handlers now catch only the remote call, not the redraw after it. The browser demo now double-clicks a directory entry and Back.
- **Mint timeout** (`af67029`, corner-prober): `mint()` now gives up in time even when the response headers arrive but the body never does. A new test covers it.
- **Nested apps** (`ba139a0`, breaker 1–2):
  - Names can no longer be written or removed directly inside any app directory. A nested app's `form` and `inventory` are now protected like the root's; entries go in its inventory, and only the whole app can be removed.
  - `getForm` and `metamorphose` now accept app paths only up to the depth `appEntry` already allows, so `form` stays within the 16-segment limit.
  - New tests cover both.
- **Wording** (`ba139a0`, `d419715`, archivist 1–2): the pending-text bound now reads "1 Mi code units, 2 MiB", and the design says the gutter selects a new clip once its listing shows it.

**Declined, with reasons in the PR comment:**
- **Changeset (releaser):** the repository has no Changesets setup.
- **Benchmark (benchmarker):** the listing's batch size caps concurrent reads; it isn't a speed claim, so there's nothing to benchmark.

**Waiting on the ruling** (locksmith, purist 1, integrator, decomplector 1–2): visitors who hold the clip URL can still write through the clip power, which goes against the #85 direction. The options are unchanged: (a) accept the interim departure, (b) ship without visitor-writable creators, (c) wait for #88. Several reviewer requests touch code that (b) or (c) would remove, so I left them for after the ruling: the fast-check state-machine property, the daemon-restart test, the cross-browser run, the coverage-auditor and purist-2 items, the stylist renames, and the pruner trims.

**Checks:** `tsc --noEmit` is clean, the four affected test files pass (101 tests), and the clip bundle builds. The scribe's summary comment is posted: https://github.com/kriscendobot/minion.town/pull/201#issuecomment-6296877972. CI sat queued for about 20 minutes waiting for the self-hosted runner, then both workflows passed.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr201-screen-9b5e8df4-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 90 tokens (4302372 cached reads)
- Output: 27436 tokens
- Cost: $2.3644744000000006
- Wall-clock: 2683s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
