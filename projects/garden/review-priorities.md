# Review priorities

Your review queue, in priority order. Order follows your stack of 2026-10-01: minion.town over MCP and OCapN, then git remote, then the UI with clips, then background Endo work (SturdyRef, byte arrays, streams, OCapN), then moonshots, then the Endo backlog.

Updated 2026-10-04T05:15Z (fix status refreshed 05:45Z) by the liaison on endolin-garden2-5bcdff64, from the 2026-10-04 panel-summary jobs. Every PR below is a draft. Each one reached its six-round review budget, or never had a gauntlet. CI is green unless a row says otherwise.

**How merging works.** The conductor merges only a PR that carries your GitHub **Approve** review. A CHANGES_REQUESTED review from you blocks the merge until you approve again. Once you approve, the approval reconciler posts the merge job by itself. "Your act" below means something only you can do.

## 1. minion.town over MCP and OCapN

| PR | What it is | Verdict | Your act | Garden act |
|---|---|---|---|---|
| [kriscendobot/minion.town#137](https://github.com/kriscendobot/minion.town/pull/137) | reap the endo-daemon port orphan before every start | **MERGED** 2026-10-04T15:23Z (`75c32159`) | none | Follow-up: limit the reaper to the endo-daemon uid. |
| [kriscendobot/minion.town#148](https://github.com/kriscendobot/minion.town/pull/148) | confined inference via the Claude CLI backend | **MERGED** 2026-10-04T15:39Z (`a378bb3d`), after a shepherd fix for the ses import and banners | Production stays off until you accept the root-socket relay leftover on [kriscendobot/minion.town#149](https://github.com/kriscendobot/minion.town/issues/149); then the paused rollout (canary) can resume. | Follow-ups from the summary: a process-wide spawn ceiling, eviction for the minted and fullIdentifiers maps, and merging the host types. |
| [kriscendobot/minion.town#160](https://github.com/kriscendobot/minion.town/pull/160) | reach each guest through the upstream broker, never the root socket: the fix for the [#149](https://github.com/kriscendobot/minion.town/issues/149) leftover (+932/−199) | **review budget reached 2026-10-05**: six panel/fix rounds, CI green, head `a9740e1cf`, out of draft. No summary yet. | Review and approve. This unblocks the paused Claude production canary. | Panel summary on request. |
| [kriscendobot/minion.town#165](https://github.com/kriscendobot/minion.town/pull/165) | pin per-guest inbox responders | **Blocked by its design, not its code.** It used all six panel/fix rounds (2026-10-06); CI green; still a draft. Panels can never pass while designs/claude-agents-capability.md Phase 1 (Endo substrate) is blocked and Phases 3–6 and Acceptance are open. | Keep it as a draft until Phase 1 lands and the root canary and inbox-watch acceptance are recorded, or reclassify it as a probe. | none |
| [kriscendobot/minion.town#147](https://github.com/kriscendobot/minion.town/pull/147) | design: MCP resources and a getting-started guide for a cold agent | **merge after a small fix** | Approve after the fix. Answer the three open questions in § 9: an eval principal, publishing the guide outside MCP, and how a confined Claude gets the guide. | **Done 05:03Z:** § 4 now compares against the commit each copy was cut from. Head is `19091663`. |
| [endojs/endo-but-for-bots#1412](https://github.com/endojs/endo-but-for-bots/pull/1412) | endo-claude CLI and Agent SDK backends, phase 2 | **merge as is**, but only after [endojs/endo-but-for-bots#1403](https://github.com/endojs/endo-but-for-bots/pull/1403) (phase 1, draft) lands and a weave shrinks the stack | Review #1403 first. | Four small follow-ups. Credential inheritance blocks deployment to multiple principals until the broker ships in phase 3. |
| [endojs/endo-but-for-bots#1407](https://github.com/endojs/endo-but-for-bots/pull/1407) | was the guest-scoped daemon bootstrap; **after its fix (2026-10-05) it changes only `designs/endo-guest-stdio-mcp.md`**, because the bootstrap code is already on the base | **merge the doc, or close as superseded** | Decide: merge the doc-only PR (clear your CHANGES_REQUESTED and approve), or close it as superseded. Either one unblocks the M3 MCP/OCapN path and [kriscendobot/minion.town#149](https://github.com/kriscendobot/minion.town/issues/149). | none until you decide |
| [endojs/endo-but-for-bots#1408](https://github.com/endojs/endo-but-for-bots/pull/1408) | run the confined Claude in a bwrap slice | **merge after a one-line doc fix**, squashed | Approve, and squash on merge. | Fixer: add `sandbox` to the stale example in the `runConfinedTurn` header. |
| [endojs/endo-but-for-bots#1406](https://github.com/endojs/endo-but-for-bots/pull/1406) | pin Claude Code 2.1.280, with dontAsk and no built-in plugins | **merge as is** | Approve. | Follow-up PR: an allowlist of known flags in `assertConfinedArgv`. |
| [endojs/endo-but-for-bots#1409](https://github.com/endojs/endo-but-for-bots/pull/1409) | prune the confined tool catalog at the guest broker | **merge as is**. Both security objections are resolved. | Approve. | none |
| [endojs/endo-but-for-bots#1404](https://github.com/endojs/endo-but-for-bots/pull/1404) | guests neither produce nor consume identifiers or locators | **merge as is**, if you accept the fix round's rebuttal of the warden's move/copy objection | Decide that rebuttal. Decide whether `loadContent` web seeds should still reach guests. Note the conflict with the minion.town guest-locator federation design in #1332. | One follow-up hardening job. |
| [endojs/endo-but-for-bots#1390](https://github.com/endojs/endo-but-for-bots/pull/1390) | accept only pet-name paths, and reject bare pet-name strings | **merge after four must-fixes**: `lal`/`fae` evaluate, slash-joined channel edge names, an unhardened result path, and the changeset note | Approve after the fix. | Fixer, once you approve this row. |

## 2. Git remote

| PR | What it is | Your act |
|---|---|---|
| [endojs/endo-but-for-bots#1367](https://github.com/endojs/endo-but-for-bots/pull/1367) | design: adopt git capability URLs as GitRemotes (the next daemon-git-remotes slice). Draft. | **The foreman's M3 git-remote path is blocked here (2026-10-05).** Decide how capability URLs are scoped, what form the locator takes, and whether credentials persist. Implementation waits on your answers. |

## 3. UI: clip gutter, clip iframe, ocap.site

| PR | What it is | Verdict | Your act | Garden act |
|---|---|---|---|---|
| [kriscendobot/minion.town#85](https://github.com/kriscendobot/minion.town/pull/85) | in-place clip upgrade, authorized by capability | **merge as is**, squash-ready | Clear your CHANGES_REQUESTED and approve. Optionally skim the rollback hunk at `publish.ts` lines 395–425. Merging adopts the stable-id interim. The fresh-id model stays in draft [kriscendobot/minion.town#88](https://github.com/kriscendobot/minion.town/pull/88). | Follow-up: brand `PowerReference`, and harden the grant reads and fsync during unpublish. |
| [endojs/endo-but-for-bots#1417](https://github.com/endojs/endo-but-for-bots/pull/1417) | `makeTreeReadPowers`, phase 1 of the confined application makers | **merge after regrouping commits** | Approve after the regroup. | Fixer: regroup into feat, test, docs, and one yarn.lock commit. |
| [endojs/endo-but-for-bots#1419](https://github.com/endojs/endo-but-for-bots/pull/1419) | `makeFromTree` node_modules layouts, a partial phase 2 that runs under the Node supervisor only | **merge after a small fix**, if you accept a slice that works on Node only | Decide: merge on Node only now, or wait for XS parity. | Fixer: restack onto the final #1417, rename `canonical` to `canonicalSegments` (a silent bug), and regroup the commits. Phases 3–5 stay parked until #1417 lands. |
| [endojs/endo-but-for-bots#1426](https://github.com/endojs/endo-but-for-bots/pull/1426) | render the Familiar security-warning banner (`familiar-localhttp-protocol`, +845/−34) | **Review budget reached twice** (10-05 and again 10-06, after the coverage audit re-staged it), 12 panel/fix rounds in all. CI green, review did not converge. No summary yet. | Review, or ask for a panel summary. | Panel summary on request. |

## 4. Background Endo: SturdyRef, byte arrays, streams, OCapN

**SturdyRef stack. You are reviewing it manually (2026-10-04).** Merge order: [#774](https://github.com/endojs/endo-but-for-bots/pull/774) (L1, draft) → [#1391](https://github.com/endojs/endo-but-for-bots/pull/1391) (L2, draft) → [#1392](https://github.com/endojs/endo-but-for-bots/pull/1392) (L3) → [#1393](https://github.com/endojs/endo-but-for-bots/pull/1393) (L4) → [#1394](https://github.com/endojs/endo-but-for-bots/pull/1394) (L5, out of draft) → [#1396](https://github.com/endojs/endo-but-for-bots/pull/1396) (L6) → [#1397](https://github.com/endojs/endo-but-for-bots/pull/1397) (L7).

| PR | Verdict |
|---|---|
| L2 #1391, ses SturdyRef shim | gauntlet 2026-10-05 used all six panel/fix rounds without converging; CI green, head `19e56526f`, still draft. Ready for your manual review. |
| L3 #1392, pass-style | merge as is once L1 and L2 land |
| L4 #1393, marshal | merge after a retcon that regroups about 26 rework commits, plus a weave onto the landed L3 |
| L6 #1396, captp construct | merge as is after L5 |
| L7 #1397, ocapn enliven | merge as is |

Every layer needs a weave once the layer below it lands, because the frozen bases have drifted. No layer needs a redesign. None of the latest heads has had a panel review, and the unreviewed deltas are small.

## 5. Moonshots

| PR | Verdict | Your act |
|---|---|---|
| [endojs/endo-but-for-bots#1379](https://github.com/endojs/endo-but-for-bots/pull/1379), slot-machine host calls | Its gauntlet halted at fix-1. It is blocked on [#1370](https://github.com/endojs/endo-but-for-bots/pull/1370) (ironhorse panic recovery design, draft, never reviewed). | Review #1370, request a summary of it, or leave both parked. |
| [endojs/endo-but-for-bots#1380](https://github.com/endojs/endo-but-for-bots/pull/1380), xsnap native-handle re-seat | **needs a redesign** to become a mergeable deliverable. It declares itself a non-deliverable probe that is missing supervisor attach and the replay driver. | Keep it as a draft probe, or commission the acceptance path. |

## 6. Infrastructure and upkeep

| PR | Verdict | Your act |
|---|---|---|
| [kriscendobot/minion.town#163](https://github.com/kriscendobot/minion.town/pull/163), restart Caddy when its gate-token environment is stale (+917/−37) | The deploy-script fix behind the Caddy gate-token incident; production was already repaired by hand. **Not yet review-clean (corrected 2026-10-06 05:2xZ).** Two gauntlets ran at once. One passed its panel at `4d5fd6f` and took the PR out of draft. The other then pushed three more fix rounds, and its last panel (at `e40b9f4`) said must-fix. The current head `7c172b0` (CI green) has had no passing panel. | Review `7c172b0` directly, or ask for one fresh panel on that head. |
| [kriscendobot/minion.town#145](https://github.com/kriscendobot/minion.town/pull/145), self-hosted ephemeral runner for ci.minion.town | **merge after named steps**. The code is done. | **First rotate `minion/ci-runner-github-token`.** It still holds the bot's broad gh OAuth token (scopes repo, workflow, gist, read:org) and should be the fine-grained PAT. Rotate with `provision-ci-runner.sh --seed-token-stdin`. Then approve and squash. |
| [endojs/endo-but-for-bots#1428](https://github.com/endojs/endo-but-for-bots/pull/1428), restore hardened yarn install and preserve install state across git clean (+121/−13) | Six panel/fix rounds used, gauntlet ended 2026-10-06. The round-6 must-fixes were applied. CI went green after the macOS `endo › lifecycle` daemon flake was rerun. Still a draft. The last panel ran on the previous head. | Review, or ask for one fresh panel. |
| [endojs/endo-but-for-bots#1418](https://github.com/endojs/endo-but-for-bots/pull/1418), stop teardown leaks behind the red @endo/daemon CI cells | fixes the flakes that turned six gauntlets red. CI is green. No gauntlet ran. | Approve, or ask for a gauntlet. |
