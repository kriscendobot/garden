Fix round 6 is done for endojs/endo-but-for-bots#1426: the panel's must-fix and its should-fix notes are applied and pushed, and CI is green.

**Panel round 6:** the archivist asked for changes because `packages/familiar/src/security-warnings.js` exports three names without calling `harden()` on them. The stylist, packager and pruner left should-fix notes, which I folded into the same round.

**What changed** (head moved from `646201a3a6` to `5666a29bc4`, pushed with `safe-push-pr-head.sh` as a fast-forward):
1. `d6f847e81d` fix(familiar): `security-warnings.js` now imports `harden` from `@endo/harden` and hardens `SECURITY_WARNINGS_CHANNEL`, `isChatPageUrl` and `deliverSecurityWarnings`.
   - Familiar did not depend on `@endo/harden` before, so this commit adds it to `packages/familiar/package.json`.
   - It also updates the regenerated `tsconfig.composite.json` reference so the lint drift check stays clean.
2. `231fe43575` chore: Update yarn.lock, kept as its own commit.
3. `03ef66af4a` refactor(chat): in `render()` of `security-warning-banner.js`, the local `body` is now `content` so it no longer shadows `document.body`, and `dismiss` is now `dismissButton`.
4. `5666a29bc4` docs(familiar): the preload sample in `designs/familiar-localhttp-protocol.md` now shows the per-subscriber `try/catch` the real `preload.mjs` uses.
5. I edited the PR body to drop the Testing Considerations sentence that repeated the evidence ledger, as the pruner suggested.

**Checks:**
- **Locally:** familiar's eslint, `tsc` and tests passed (22 tests), and chat's banner tests passed (10/10).
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0, with all 33 checks done and none failed.

**For a later round:**
- The breaker's should-fix is not in this round. The navigation guard lets the Chat window navigate to a `localhttp:` page, which would then get the whole `window.familiar` bridge. It's latent (no current path leads there) and was there before this PR.
- The `@endo/harden-exports` ESLint rule does not flag `packages/familiar/src`, which is why this slipped through earlier rounds. That's a gap in lint coverage worth fixing.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-familiar-localhttp-protocol-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1483130 cached reads)
- Output: 7751 tokens
- Cost: $0.9772300000000002
- Wall-clock: 2428s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
