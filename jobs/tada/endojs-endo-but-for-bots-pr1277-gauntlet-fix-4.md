CI is GREEN (rc 0). The fix is pushed and verified. Job complete.

---

## Completion report

**Job:** `endojs-endo-but-for-bots-pr1277-gauntlet-fix-4` — FIX round 4 for PR #1277 (`design: invitation retention labels and pin lifecycle`).

**What I did.** Read the panel-4 verdict (disposition: must-fix), fetched the actual mechanism from the unlanded PR #1125 (`accept()`, the pin write, the slot rebind, `StoreController.remove`/`PetStore.remove` bookkeeping) to ground the corrections, then applied one round of fixes to `designs/daemon-retention-labels.md` and pushed as a follow-up commit (`fc6058624`) to the endojs head branch `design/daemon-retention-labels`.

**Must-fix items addressed:**
- **`inviter` terminology** (critic/copyeditor/pedant/novice): redefined *inviter* as the **issuing** agent (called `invite()`), on whose side all retention state lives; the redeeming side is untouched. Now consistent with `invitingAgent`/`invitingHandle` and `channel.js`'s `inviterMemberId`.
- **Pin lifecycle model** (critic/skeptic/novice): corrected the false two-phase "transient pin" swap. The pin is written **once** naming the local guest handle and never swapped; the invitation→`remoteHandle` swap happens on the separate `invitedName` binding. Added `localGuestHandle` as the pin's durable target (what `prune` compares) and demoted `remoteHandle` to descriptive-only.
- **`prune` bookkeeping** (critic): routed the guarded `DELETE` through a new `removeIfIdentifier(name, expectedId)` that also discharges `idsToPetNames.delete`, `publishNameRemoval`, and `removeEdgeIfUnreferenced` (so pruning collects rather than leaks); dropped the wrong formula-graph-lock rationale (PR #1125 uses per-invitation `makeSerialJobs()`); split the `missing`/`changed` tri-state into an advisory read outside the atomic boundary (decomplector/Invariant 5).
- **Place-braid** (decomplector): stated the derived state is advisory/host-side and that `prune` guards the host-controlled pin target, so a guest renaming its own `invitedName` cannot induce a spurious prune.
- **Injectivity residual** (skeptic): flagged the single-segment length-prefix collision and carried it as a test obligation + flag to #1125.

**Should-fix / mechanical also applied:** mint-time validation moved fully to `invite()` (the `-from-<n>` suffix uses the inviting handle number, fixed at mint) with `assertPetName`'s broader rejection classes noted; Phase 3 accuracy (retention-path surface already scaffolded on base as a stub, #284 supplies the real traversal); host-inviter pin scoping note; CLI paragraph comma-splice rewrite + flag definitions; `Durable Set formula` heading; removed all em-dashes and non-ASCII (house convention), de-hyphenated `-ly` adverbs, fixed wrap discipline; added collision/concurrency/`removeIfIdentifier` test-plan lines.

**Push & CI.** Committed only the design file (reverted a spurious `packages/floot/package.json` change left by the yarn warm-cache). Pushed via `safe-push-pr-head.sh` (`05d387f93 → fc6058624`). CI watched to terminal: **GREEN** — `rollup-terminal total=29 failed=0`, rc 0 (docs-only change; code lanes path-skipped, `lint`/`changes`/`zizmor` pass). Inbox empty at checkpoint.

**Follow-ups:** none blocking. The single-segment injectivity residual and the `removeIfIdentifier`/collision test obligations are flagged in-design for the eventual implementation PR and for #1125. Stage stops here; the driver re-posts panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1277-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 200 tokens (11651992 cached reads)
- Output: 62428 tokens
- Cost: $8.852129000000007
- Wall-clock: 1535s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
