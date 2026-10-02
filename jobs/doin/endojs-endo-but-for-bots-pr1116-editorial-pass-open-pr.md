---
role: shepherd
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
---
**Role: shepherd.** Successor to job `endojs-endo-but-for-bots-pr1116-editorial-pass`. That job finished the editorial pass on `designs/guest-native-invitations.md` but could not open the PR, because host oros-studio-garden-ce242c49's PAT gets a 403 on endojs PR creation.

Already pushed to endojs/endo-but-for-bots:
- head `design/guest-native-invitations-editorial` (commit 9a054a55f, docs-only, so no changeset)
- frozen base `llm-ca1794f` (the #1116 merge ca1794f0cd on `llm`)

Task:
1. Open the PR with the following command. Do NOT use a bare `gh pr create`. The body below carries the original job's marker, so a retry adopts the existing PR instead of opening a duplicate.
   `scripts/jobs/gardening/ensure-pr.sh endojs-endo-but-for-bots-pr1116-editorial-pass endojs/endo-but-for-bots design/guest-native-invitations-editorial llm-ca1794f --title "design(guest-native-invitations): editorial pass to reduce commentary" --body-file <file containing the PR BODY below>`
2. Shepherd the PR to green CI.
3. Dispatch the conductor to merge it. The maintainer already asked for shepherd + conduct in https://github.com/endojs/endo-but-for-bots/pull/1116#pullrequestreview-5386747855 ("Then, shepherd and conduct."). Do not name a merge method.

----- PR BODY -----
Editorial follow-up to #1116 (design: guest-native invitation and acceptance), per kriskowal's approving review (https://github.com/endojs/endo-but-for-bots/pull/1116#pullrequestreview-5386747855): "Please do an editorial pass to reduce the verbosity of commentary, but without deleting the last copy of any essential information." #1116 merged before the pass ran, so it lands here against `llm`.

Docs-only (no changeset). `designs/guest-native-invitations.md` goes from about 10,500 to 7,400 words. `designs/README.md` changes only the *Updated* date.

## What was cut

- **Panel-round residue:** "an earlier draft framed the split as…", "this resolves the earlier contradiction between sections 1 and 7", "the one outcome that used to be the self-contradictory…", and the "this closes a vector the earlier ordering left open" history in section 3. The resulting rules stay.
- **Restated rationale:**
  - Section 6 no longer re-derives the `formulaGraphJobs` self-deadlock. It points to section 5 and keeps only the reentrant-depth-counter fact.
  - Section 3's two overlapping security lists (registration ordering, and the per-direction argument) are merged into one per-direction argument.
  - The `correspondentName`/help/CLI rename detail in section 1 now points to section 9 instead of repeating it.
  - Open Questions 2 and 5 point to *Implementation status* and section 5 instead of repeating them.
- **Overlong code comments:** the section 5 sketch's comments are shortened. The full reasoning stays in the prose that follows the sketch.
- **Stale claims:**
  - "Re-`invite` overwrite … is the **only** reliable revocation verb" contradicted the landed `cancel()` and was removed. The revocation verbs are now listed in section 1 and in section 5's *Revocation paths*.
  - Section 5's "the Open Questions section records the residual doubt about revoking across a restart" was removed, since Open Question 4 resolved that.
- **Test plan:** parentheticals are tightened and the two restart bullets are merged into *Durability*.

## Where each essential fact now lives

| Fact | Location |
|---|---|
| API signatures, `correspondentName` semantics and rename rationale | §1 Surface |
| `locate` `type !== 'invitation'` rule, `followNameChanges` complement | §1 *Reading invitation state* |
| Revocation verbs (`cancel`, re-`invite`, `remove`), `rename` is not revocation | §1 *Revocation*, §5 *Revocation paths* |
| Returned-vs-rejected outcome taxonomy, consumed bit, CapTP marshal rationale | §1 *Failure surface* |
| Daemon node vs agent node, locator params (`from`/`fromNode`/`handleNode`) | §2 steps 1–5 |
| Newcomer provisioning, `@nets` reciprocal precondition | §2 |
| Two public guards, injected insert-only capabilities, per-direction safety, `addPeerInfo`/`writeRemoteAgentKey` refusals | §3 |
| Same-daemon skip of both registration writes | §4 |
| Consume-once commit, `storeLocatorIfMatches`, store-controller invariants, no `formulaGraphJobs` enqueue | §5 (reconciliation note retained) |
| `withFormulaGraphLock` is not a mutex | §6 |
| Formula-store state machine, mid-accept re-drive | §7 |
| Tests and implementation artifacts (including the CLI `accept.js` sweep) | §8, §9 |
| Landed/divergence table, #1277 retirement, #399 | *Implementation status* |
| Maintainer decisions (outcome surface, #1277, OQ 1–7) | Open Questions (all seven kept) |

<!-- garden-job: endojs-endo-but-for-bots-pr1116-editorial-pass -->

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END PR BODY -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-02T04:04:54Z
