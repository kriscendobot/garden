FIX round 1 complete. Applied the round-1 gauntlet panel's must-fix items to PR #1310, pushed as a review-feedback follow-up, and CI is terminal green.

**What I did** — in an isolated project checkout of the PR head (`endojs/endo-but-for-bots:bot/build/guest-native-accept`), applied the panel's must-fix items in one commit (`4b47a61aa`), pushed via `safe-push-pr-head.sh` (`6e841a9a7..4b47a61aa`), and watched CI to terminal.

**What changed** (`packages/daemon/src/{manager,guest,host,types.d.ts}`, `packages/cli/src/commands/accept.js`, tests, + a changeset):

1. **Security — unauthenticated routing-table poisoning (breaker/engine-realist/locksmith/saboteur/spec-keeper/warden/wire-watcher):** in `acceptInvitation`, assert `formulaType === 'invitation'` and `assertNodeNumber(fromNode)` at the input edge; defer `writeRemoteAgentKey` until after `E(invitation).accept()` proves the invitation and make it additive-only (never redirect a mapped key); register peers only when unknown and non-empty (add-a-route, never redirect/blank); bind the correspondent before the irreversible consume so a bad name path can't strand a spent invitation.
2. **Inviter-side empty-`@nets` clobber:** skip `addPeerInfo` when the acceptor advertised no addresses.
3. **Overclaiming docstrings (locksmith/warden/spec-keeper):** restated the bounded additive routing effect.
4. **`correspondentName` rename sweep (archivist/integrator/purist/duality-auditor):** host + guest `invite`/`accept`, `types.d.ts` signatures, CLI comment — one shared subject end to end.
5. **Missing changeset (changeset-auditor/curator/migrator/packager/releaser):** added `@endo/daemon: minor`.
6. **prover coverage:** pinned that a same-daemon accept writes no known-peer entry.
7. **Hygiene (typist/purist/saboteur et al.):** straight-quoted new assertion messages; per-process token on test socket paths.

**Verification:** daemon `lint:types`, `lint:eslint` (0 errors), root `tsc -p tsconfig.json`, `build:types:check`, CLI lint, and targeted daemon tests all passed locally; PR CI rollup is 32 checks, 0 failed → **GREEN**.

**Follow-ups deferred** (not must-fix, out of a single fix round): several comment-only items remain — a fast-check property test for the socket-length invariant (needs a new devDependency), the `t.throwsAsync({message:/…/})` tightening, the `any[]`→`unknown[]`/`StampedMessage[]` cast narrowing, and the internal `formulateInvitation`/`makeInvitation` `guestName` naming (left as-is to avoid churning ~15 comment sites; the public surface now reads `correspondentName`). The panel driver re-posts panel-2 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1310-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s)
- Input: 274 tokens (17406848 cached reads)
- Output: 84035 tokens
- Cost: $13.769711999999997
- Wall-clock: 2400s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
