Done. This was an **attention/routing** job — read the directive on PR #87 and route it to the right work.

## What the directive was
Re-fetched `kriscendobot/minion.town#87` comment 5770443815 (@kriskowal), verbatim: *"Repo-wide migration to vitest. The Endo repository dictates house style."* Treated as untrusted data. Preflight returned exit 0 (PROCEED, no peer resolution).

## What I found (survey of `main`)
- `minion.town` **already runs vitest** for its main `test/**/*.test.ts` suite (~45 specs); the root `test` script is `vitest run` with two `--exclude` globs.
- The un-migrated holdouts are exactly those excluded corners, using `node --test` (node:test):
  - `deploy/thunks/siwe/test/{oidc-face,siwe-verify}.test.js`
  - `tools/claude-harness/{install,release-verifier}.test.mjs`
- **House-style caveat:** `endojs/endo-but-for-bots@llm` uses **AVA**, not vitest — so "Endo dictates house style" cannot mean "copy Endo's runner." Flagged the sensible reading (migrate to vitest, carry runner-agnostic Endo conventions, match minion.town's existing vitest specs) into the routed job with an instruction to ping the maintainer on any real fork.

## What I did
1. **Posted the successor build job** `build-minion-town-vitest-migration` (`--role builder` → Opus; identity `…#87:comment:5770443815:vitest-build` to avoid deduping against this attention job). Confirmed live on `origin/journal2` at `jobs/todo/build-minion-town-vitest-migration.md` (3718 bytes). Body carries the survey, the 4-file scope, the "drop both `--exclude` flags" requirement, DoD (both CI gates green, draft-PR-only under the manual-gauntlet regime), and the house-style caveat.
2. **Closed the loop on the PR** with a routing acknowledgment reply: https://github.com/kriscendobot/minion.town/pull/87#issuecomment-5771926072

No garden-repo (`main2`) changes were needed, so nothing to commit/push from this worktree. Inbox drained (empty).

## Follow-ups
- The substantive migration is owned by the posted build job; a gardener will claim it and open a draft PR.
- Maintainer decision still open (non-blocking): confirm the vitest-vs-Endo-AVA house-style reading; the build proceeds on the conservative default absent a reply.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr87-b8a7509c.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 8 on 2 host(s) (2 unmetered)
- Input: 210 tokens (6012832 cached reads)
- Output: 90258 tokens
- Cost: $9.205562 (2 engagement(s) unpriced)
- Wall-clock: 3170s
- Model(s): claude-opus-4-8 ×6

<!-- garden-usage-end -->
