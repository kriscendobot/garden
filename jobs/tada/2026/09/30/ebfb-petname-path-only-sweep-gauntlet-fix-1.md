## Gauntlet fix round 1: endojs/endo-but-for-bots PR #1390

I applied the panel's round-1 must-fix items, pushed them as three follow-up commits (head moved from `065f1344ea` to `12c61653a6`), and CI finished green: all 33 checks passed and `ci-wait-merge` returned rc 0.

**Commit `cdf00552ce`, `fix(daemon)`:**
- **Default `powersName`:** `makeUnconfined`/`makeArchive` now default `powersName` to `['@none']`. The old string default threw on every call that left it out (typist and breaker).
- **Bare strings refused everywhere:** the pet-store inspector `lookup`, `SecretManagerDirectory.lookup` and channel `post` (both the channel and member versions) now go through `namePathFrom`, so a bare string is refused on each of them (warden, spec-keeper, saboteur, surfacer, wire-watcher).
- **Old invitations still load:** an invitation record stored with a string `guestName` is now read as a one-segment path instead of failing to revive (wire-watcher, engine-realist).
- **Bug found beyond the panel:** the mail and message hub `lookup` helpers called themselves with a bare `headName`, so any multi-segment path threw. They now pass `[headName]`. Tightening the JSDoc types is what exposed this.
- **Docs:** rewrote the opening of the `NamePathArgumentShape` doc (archivist), corrected the `help.md` `lookup` text and regenerated `help-text-data.js` (stylist), and changed stale `string | string[]` JSDoc to path types.
- **Tests added:** `makeUnconfined` with no `powersName`, secret-manager `lookup('create')` refused, and channel `post` with a string refused.

**Commit `79fbcd6fb7`, fixing call sites that still passed bare strings:**
- **Named by the panel:** `AUTH_SECRET_PETNAME` in fae `subagent-host` and fae/floot factory setup, floot `powersName: [agentName]`, lal `provideGuest([name])`, floot `lookup(['llm-provider'])`, and two `resultName` values in claude-sandbox.
- **Test fakes made strict:** the lal `mock-powers` and floot `machine-admin-setup` test fakes now reject strings like the real daemon (spec-keeper, integrator). This exposed two more string callers in floot (`machine-admin-setup.js:341` and `floot-factory-setup.js:130`), now fixed.
- **Found by my own sweep:** the chat and space UI walked profile paths and looked up names with bare strings. That covers `chat.js` `makeChannel`/`lookup(channelName)`, `add-space-modal`, seven `*-component.js` files, `space-channel/share-modal` and `space-inventory-graph/graph`. The TypeScript casts for these are updated too.
- **Text:** the lal tool descriptions no longer say "string or string[]".

**Commit `12c61653a6`, changeset:** added `@endo/sandbox` minor, `@endo/agentry` minor, `@endo/agent-tools` patch and `@endo/platform` patch (curator, changeset-auditor, packager, integrator). It also notes the invitation back-compat and that mounts and the readable-tree surface deliberately still accept strings.

**Verification:**
- Daemon and chat typechecks are clean, and eslint reports no errors.
- Unit tests pass: lal 52, floot 195, daemon `secret-manager` 18.
- The daemon tests that start a real daemon could not run here, because local Node is 22 and the warm cache's `better-sqlite3` is built for Node 24. I did not rebuild the shared store. CI ran those tests instead and they passed.

**Not done (follow-ups):**
- No test for the inspector-hub refusal: hosts no longer have any way to reach the pet-store inspector since `@info` was retired.
- No test for reviving an old string-`guestName` invitation, and none for multi-segment mail-hub lookups.
- Should-fix and comment-only items left alone:
  - The integrator's request to regroup the 16 commits.
  - The pruner's cuts to the PR body.
  - Switching the error to `makeError`.
  - The fast-check property test.
  - Empty-segment checks at the UI `split('/')` sites.
  - Colliding scratch-mount names.
  - Removing the string coercion in agentry `code-mode.js`.
- There are other `lookup(name)` calls on mounts and trees (9p-server, file-explorer, zip and similar). I left them as they are because those surfaces still accept strings.
- The scribe seat didn't produce a review (it was stuck on the GitHub rate limit).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 184 tokens (11205297 cached reads)
- Output: 35256 tokens
- Cost: $4.2470914
- Wall-clock: 2393s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
