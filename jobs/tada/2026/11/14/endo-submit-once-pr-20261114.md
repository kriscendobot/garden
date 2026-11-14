I opened draft PR **https://github.com/endojs/endo-but-for-bots/pull/1660** as kriscendobot. Head is `submit-once` at c9e50723d4; base is `llm-48d6f3e`.

**What I did**
- **Applied the patch:** the Tower's patch applied cleanly with `git am` on current `llm` (48d6f3e, which has moved past 204033b39). I kept the commit message unchanged and changed both author and committer to `Kriscendo Bot <279080640+kriscendobot@users.noreply.github.com>`.
- **Base branch:** `ensure-pr.sh` refuses to open a draft against bare `llm`, so the PR targets the existing snapshot `llm-48d6f3e`, which is the current `llm` tip. Other recent bot PRs use the same base.
- **One fix to the patch:** root `yarn prettier --write` reformatted one `throw new Error(...)` line in `mail.js`. CI's format check would have flagged it, so I folded it into the single commit.
- **PR body:** follows the repo's PR template. It covers what `submit` gets wrong, the `submitOnce(messageNumber, values, attempt)` contract, the 21/64 vs 0/96 crash-campaign evidence, and the open window (a daemon stopped after delivery but before `answered-<attempt>` is written). It notes the overlap with a possible future mailbox-archive design without anticipating it, and asks for maintainer review. It is not merged, and the gauntlet will run as usual.

**Local checks** (fresh `yarn install --immutable`):
- **Install:** it first failed because the sandbox could not write node-gyp's cache directory, which is needed to build `better-sqlite3`. With `npm_config_devdir=$TMPDIR/node-gyp` it succeeded.
- **`endo.test.js` selection** (mail, message, dismiss, form, submit, value, inbox): 88 passed, not the 84 expected, because `llm` has grown. All seven new `submitOnce` tests passed.
- **Full `endo.test.js`:** 297 passed and 2 failed: the OpenCode and Claude backend tests "records a session through the daemon owner and destroy reaches its storage". Both fail the same way on unmodified `llm` here (`procfs process identity|Provider grant admission failed`), so they come from the sandbox, not this change. The PR says so.
- **Other tests:** `help-text.test.js` 5/5, `mail-pins.test.js` 4/4.
- **Types:** daemon `tsc` is clean. The repo-root `tsc -p tsconfig.json` ran out of memory at the default heap, then came out clean with `--max-old-space-size=8192`.
- **Lint and format:** `eslint` on the changed files shows no new warnings or errors compared with base. `prettier` is applied.

**Follow-ups**
- I added no changeset. `@endo/daemon` is private, but `.changeset/` has daemon entries, so the panel's changeset auditor may ask for one.
- The open window stays open by design, as the maintainer asked.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-submit-once-pr-20261114.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (2911484 cached reads)
- Output: 11909 tokens
- Cost: $1.5400208000000002
- Wall-clock: 1699s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
