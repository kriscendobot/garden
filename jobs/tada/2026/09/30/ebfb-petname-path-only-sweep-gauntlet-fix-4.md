# Fix round 4 for endojs/endo-but-for-bots#1390: all must-fix items applied, CI green

I applied the panel-4 must-fix items and most of the should-fix items, pushed four commits to `build/pet-name-path-only` (257db20fe5 → b915238ab3e), and CI finished green (33 checks, 0 failed).

The first push went red on `lint`, and the cause was my own change. `share-modal.js`'s local `lookup` typedef still took a `string`, so the new `[targetChannelPetName]` argument failed with TS2345. Prettier also flagged `endo.test.js`. I fixed both in a fourth commit, re-pushed, and that head came back green.

## Must-fix
1. **Bare strings still reaching the strict daemon surface** (commits `2d84a89ec0` and `b915238ab3e`):
   - **`use-file-explorer.js`:** `resolveProfileHost`, `openByPetName` and the inventory classifier now wrap each lookup segment in an array.
   - **Channel-mode `post` calls:** `send-form.js` and `command-executor.js` now pass `petNames.map(n => n.split('/'))`, matching how the inbox-mode sibling calls were migrated.
   - **`share-modal.js`:** `post(..., [[channelPetName]])`, `send([agentPetName], ...)`, and both lookups are wrapped. The new-channel lookup at line 662 was an extra bare-string site the panel didn't list. The local `lookup` typedefs are now `(petNamePath: string[])`.
   - **`outliner/controller-intents.js`:** its two `post` calls passed a flat `parsed.petNames`. This was another unlisted site, now converted the same way.
   - **Typedefs:** in `chat/chat.js`, `channel-utils.js`, `send-form.js` and `command-executor.js`, `petNamesOrPaths: string[]` is now `petNamePaths: string[][]`.
   - **Test:** the one assertion in `chat/test/unit/command-executor-channel.test.js` that expected the flat array was updated.
2. **One name for the raw argument** (commit `51f3cc0efc`): the raw argument is now `petNamePath` everywhere, and the validated result is `namePath`. This replaced `namePathArgument`, `pathArgument` and `petNamePathArgument` in `host.js`, `guest.js` and `mail.js`. `directory.js` and `manager.js` already used this form.
3. **Test variable name:** `srcDir` → `sourceDirectory` in the two new `makeUnconfinedFromTree` refusal tests.
4. **Docs:** `lal/primer/tools.md` now documents `adopt(messageNumber, edgeName, petNamePath)`.
5. **Spelling:** `host.js` `cancel` now uses `'Canceled'`.

## Should-fix
- **saboteur:** the channel member's `post` now runs `checkAccess()` before validating `petNamePaths`.
- **changeset-auditor and packager:** I folded `daemon-type-guards-export.md` into `pet-name-path-only.md`. That changeset now also calls out the `@endo/lal` tool-call key rename from `petNameOrPath` to `petNamePath`.

## Verification
- **Passed:** the `chat` tests (896) and `space-file-explorer` tests (80). `tsc --noEmit` is clean for `space-channel`, `spaces-util`, `space-file-explorer` and `chat`.
- **Not run locally:** the daemon integration tests. The daemon can't start on this host because `better-sqlite3` was built for a different Node version (NODE_MODULE_VERSION 137 vs 127). CI's green run covers them.

## Follow-ups (not done)
- **corner-prober:** a refusal test for `lal/tool-dispatch.js`, and making the `search-tools.test.js` stub strict.
- **fast-checker:** property tests for `namePathFrom` and `toPetNamePath`.
- **scribe:** a summary comment covering commits `ab42d2de95` and `09350117e6`.
- **PR-body probe:** trim the body from 343 words to under 300.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 100 tokens (3779619 cached reads)
- Output: 17852 tokens
- Cost: $1.8017078000000002
- Wall-clock: 4209s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
