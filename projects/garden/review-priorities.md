# Review priorities

Your review queue, in priority order. Order follows your stack of 2026-10-01: minion.town over MCP and OCapN, then git remote, then the UI with clips, then background Endo work (SturdyRef, byte arrays, streams, OCapN), then moonshots, then the Endo backlog.

Updated 2026-10-04T05:15Z by the liaison on endolin-garden2-5bcdff64, from the 2026-10-04 panel-summary jobs. Every PR below is a draft. Each one reached its six-round review budget, or never had a gauntlet. CI is green unless a row says otherwise.

**How merging works.** The conductor merges only a PR that carries your GitHub **Approve** review. A CHANGES_REQUESTED review from you blocks the merge until you approve again. Once you approve, the approval reconciler posts the merge job by itself. "Your act" below means something only you can do.

## 1. minion.town over MCP and OCapN

| PR | What it is | Verdict | Your act | Garden act |
|---|---|---|---|---|
| [kriscendobot/minion.town#137](https://github.com/kriscendobot/minion.town/pull/137) | reap the endo-daemon port orphan before every start | **merge as is**. No gauntlet ran. One commit, CI green. | Approve. | Follow-up: limit the reaper to the endo-daemon uid. |
| [kriscendobot/minion.town#148](https://github.com/kriscendobot/minion.town/pull/148) | confined inference via the Claude CLI backend | **merge after a small fix** | Re-review commits `533aabb…7c08ffa`, five of them, unreviewed, including a change to how the child hosts' capabilities are structured. Then clear your CHANGES_REQUESTED. Before production, accept the root-socket relay leftover on [kriscendobot/minion.town#149](https://github.com/kriscendobot/minion.town/issues/149). | Fixer: memoize `ensureDirectory` per path to fix a race, and make `activate` required. |
| [kriscendobot/minion.town#147](https://github.com/kriscendobot/minion.town/pull/147) | design: MCP resources and a getting-started guide for a cold agent | **merge after a small fix** | Approve after the fix. Answer the three open questions in § 9: an eval principal, publishing the guide outside MCP, and how a confined Claude gets the guide. | Fixer: correct the § 4 rule so it compares against the commit each copy was cut from. |
| [endojs/endo-but-for-bots#1412](https://github.com/endojs/endo-but-for-bots/pull/1412) | endo-claude CLI and Agent SDK backends, phase 2 | **merge as is**, but only after [endojs/endo-but-for-bots#1403](https://github.com/endojs/endo-but-for-bots/pull/1403) (phase 1, draft) lands and a weave shrinks the stack | Review #1403 first. | Four small follow-ups. Credential inheritance blocks deployment to multiple principals until the broker ships in phase 3. |
| [endojs/endo-but-for-bots#1407](https://github.com/endojs/endo-but-for-bots/pull/1407) | guest-scoped daemon bootstrap for the confined turn. Upstream groundwork for closing #149. | **merge as is** | Approve. Optionally skim `a49568bb9`, which no panel has reviewed. | Follow-up: fix the order of revoke and unlink, and share one socket-name helper. |
| [endojs/endo-but-for-bots#1408](https://github.com/endojs/endo-but-for-bots/pull/1408) | run the confined Claude in a bwrap slice | **merge after a one-line doc fix**, squashed | Approve, and squash on merge. | Fixer: add `sandbox` to the stale example in the `runConfinedTurn` header. |
| [endojs/endo-but-for-bots#1406](https://github.com/endojs/endo-but-for-bots/pull/1406) | pin Claude Code 2.1.280, with dontAsk and no built-in plugins | **merge as is** | Approve. | Follow-up PR: an allowlist of known flags in `assertConfinedArgv`. |
| [endojs/endo-but-for-bots#1409](https://github.com/endojs/endo-but-for-bots/pull/1409) | prune the confined tool catalog at the guest broker | **merge as is**. Both security objections are resolved. | Approve. | none |
| [endojs/endo-but-for-bots#1404](https://github.com/endojs/endo-but-for-bots/pull/1404) | guests neither produce nor consume identifiers or locators | **merge as is**, if you accept the fix round's rebuttal of the warden's move/copy objection | Decide that rebuttal. Decide whether `loadContent` web seeds should still reach guests. Note the conflict with the minion.town guest-locator federation design in #1332. | One follow-up hardening job. |
| [endojs/endo-but-for-bots#1390](https://github.com/endojs/endo-but-for-bots/pull/1390) | accept only pet-name paths, and reject bare pet-name strings | **merge after four must-fixes**: `lal`/`fae` evaluate, slash-joined channel edge names, an unhardened result path, and the changeset note | Approve after the fix. | Fixer, once you approve this row. |

## 2. Git remote

Nothing is waiting on your review.

## 3. UI: clip gutter, clip iframe, ocap.site

| PR | What it is | Verdict | Your act | Garden act |
|---|---|---|---|---|
| [kriscendobot/minion.town#85](https://github.com/kriscendobot/minion.town/pull/85) | in-place clip upgrade, authorized by capability | **merge as is**, squash-ready | Clear your CHANGES_REQUESTED and approve. Optionally skim the rollback hunk at `publish.ts` lines 395–425. Merging adopts the stable-id interim. The fresh-id model stays in draft [kriscendobot/minion.town#88](https://github.com/kriscendobot/minion.town/pull/88). | Follow-up: brand `PowerReference`, and harden the grant reads and fsync during unpublish. |
| [endojs/endo-but-for-bots#1417](https://github.com/endojs/endo-but-for-bots/pull/1417) | `makeTreeReadPowers`, phase 1 of the confined application makers | **merge after regrouping commits** | Approve after the regroup. | Fixer: regroup into feat, test, docs, and one yarn.lock commit. |
| [endojs/endo-but-for-bots#1419](https://github.com/endojs/endo-but-for-bots/pull/1419) | `makeFromTree` node_modules layouts, a partial phase 2 that runs under the Node supervisor only | **merge after a small fix**, if you accept a slice that works on Node only | Decide: merge on Node only now, or wait for XS parity. | Fixer: restack onto the final #1417, rename `canonical` to `canonicalSegments` (a silent bug), and regroup the commits. Phases 3–5 stay parked until #1417 lands. |

## 4. Background Endo: SturdyRef, byte arrays, streams, OCapN

**SturdyRef stack. You are reviewing it manually (2026-10-04).** Merge order: [#774](https://github.com/endojs/endo-but-for-bots/pull/774) (L1, draft) → [#1391](https://github.com/endojs/endo-but-for-bots/pull/1391) (L2, draft) → [#1392](https://github.com/endojs/endo-but-for-bots/pull/1392) (L3) → [#1393](https://github.com/endojs/endo-but-for-bots/pull/1393) (L4) → [#1394](https://github.com/endojs/endo-but-for-bots/pull/1394) (L5, out of draft) → [#1396](https://github.com/endojs/endo-but-for-bots/pull/1396) (L6) → [#1397](https://github.com/endojs/endo-but-for-bots/pull/1397) (L7).

| PR | Verdict |
|---|---|
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
| [kriscendobot/minion.town#145](https://github.com/kriscendobot/minion.town/pull/145), self-hosted ephemeral runner for ci.minion.town | **merge after named steps**. The code is done. | **First rotate `minion/ci-runner-github-token`.** It still holds the bot's broad gh OAuth token (scopes repo, workflow, gist, read:org) and should be the fine-grained PAT. Rotate with `provision-ci-runner.sh --seed-token-stdin`. Then approve and squash. |
| [endojs/endo-but-for-bots#1418](https://github.com/endojs/endo-but-for-bots/pull/1418), stop teardown leaks behind the red @endo/daemon CI cells | fixes the flakes that turned six gauntlets red. CI is green. No gauntlet ran. | Approve, or ask for a gauntlet. |
