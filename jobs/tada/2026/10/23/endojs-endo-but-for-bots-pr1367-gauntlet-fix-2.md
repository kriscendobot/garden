**Fix round 2 for endojs/endo-but-for-bots#1367 is done: two commits are on the PR head and CI is green (30 checks, 0 failed, rc 0) at head `8b5bc8a3b7b`.** One item is still open: the PR body could not be edited from this host, so I posted a job to do it on another host.

There was no deterministic pre-pass block, so I worked from the latest panel verdict (the bot's `Must-fix before merge` review, 16:12Z). Both commits were pushed with `safe-push-pr-head.sh` in advance mode, from `6c2e9607b` to `8b5bc8a3b`.

**`designs/daemon-git-remote-capability-urls.md`** (commit `b03e8b2bc`):
- **Critic (must-fix), guest gets push:** the landed `provideGitClone` hard-codes `['fetch', 'push']` (`host.js`). The design now adds an optional `allowedDirections` to `provideGitClone`. The default is unchanged. Leaving out `'push'` stores `pushRefspecs: []` in the remote's formula. The ingestion example now asks for `['fetch']` and grants the guest `git.readOnly()`. The plan now includes a test that a guest `push()` is rejected, that no `git-receive-pack` request reaches the server, and that this still holds after a restart. The summary, attenuation section, sequence diagram, ownership map and dependencies were updated to match.
- **Skeptic (must-fix), where the token is redacted:** a new § Redaction boundary covers:
  - the formula record (`{type, kind, audience}` only) and the pet-name store;
  - audit logs: none exists today, and a future one may record only non-secret fields;
  - error messages and git processes.

  The plan adds a test that scans the raw bytes of the daemon's state directory and log for the token.
- **Skeptic (should-fix), argv:** the plan extends the landed fake-git test, which checks that the token is not in argv, the environment or temp files.
- **Copyeditor and pedant:** fixed the wording, replaced the en-dash range with an ASCII hyphen, and wrapped all prose to the column limit.

**`designs/README.md` and `designs/daemon-git-remotes.md`** (commit `8b5bc8a3b`):
- **Archivist (must-fix):** the `daemon-git-next-steps` row now says `provideGitClone` (#538) and commit identity (#706) have landed, and drops the pointer to a future `daemon-git-clone.md`.
- **Integrator (should-fix), totals:** I re-derived the totals from the summary table instead of adding to the old count. It has 257 rows, 35 of them Proposed, and the buckets add up to 257. The old prose said 252 because it had drifted. The raw corpus is 272 files, and 13 design files are not yet in the table. The paragraph that began "The rebase of PR #1367 adds" was replaced.
- **Copyeditor and pedant:** split the overloaded server-half sentence, and replaced the em dash and en-dash ranges.
- Prettier passes on all three files.

**PR body (integrator must-fix): not applied yet.** Editing the body from this host returns 403 (`updatePullRequest`); this host's bot token lacks PR write access on endojs. I posted `endojs-endo-but-for-bots-pr1367-gauntlet-fix-2-pr-body`, pinned to `host=endolin-garden-ece02cb4`. It carries a body rewritten section by section from `.github/PULL_REQUEST_TEMPLATE.md`, with the `garden-job` marker kept. Panel-3 may flag the body again if it runs before that job lands.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1367-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2476396 cached reads)
- Output: 25325 tokens
- Cost: $1.8021712
- Wall-clock: 1159s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
