Worktree clean, build tree restored to the on-chain default, inbox empty. Work complete.

---

# Completion report — `deadmail-issue-comment-4839140138`

**Intent.** Dead-lettered issue-inbox message: a maintainer (kriskowal) comment on `kriskowal/garden#9` asking for a precise slot-consumption accounting of the v320 ymax0 XS value-stack overflow (8 questions). Intended recipient `issue-kriskowal-garden-9` had completed.

**Key finding on pickup.** The original doer had **already posted a thorough answer** to all 8 questions at 01:57:59Z (comment 4839211965's predecessor). I did **not** duplicate it. That answer explicitly flagged one open number: *"the patched bundle's own overflow threshold... needs a downward stackCount bisection... a cheap follow-up if you want the baseline pinned to a number."*

**What I did (fresh on-host measurement).** I independently reproduced the live overflow trace and then closed that exact gap. From-source instrumented `xsnap-worker` rebuilt per `stackCount` (seconds, not hours), real v320 bundle, two zips byte-identical except `hex.js` decodings (`flatMap` vs `for`-loop):
- **flatMap peak demand: ~4129–4144 slots** — overflows the on-chain default 4096 by only ~33–48 (refines the prior coarse "~128").
- **loop peak demand: ~3457–3488 slots** — clears 4096 with ~610–640 slots headroom.
- The loop reclaims **~660 slots net** (not the full 1238-slot hex frame), because removing hex **uncovers the next-tallest consumer**: a deep exo-class/interface-guard recursion during vow-tools setup (`prepareBasicVowTools`→`defendPrototypeKit`→`makeMatcher`→`confirmPattern`→`passStyleOfRecur`), riding on the **same ~2000-closure module-lexical baseline** that sat under the flatMap peak. This sharpens the "defer a turn?" answer: not a one-turn deferral, but the durable lever remains shrinking the single-flat-functor module scope.

**What changed.**
- Posted follow-up comment: https://github.com/kriskowal/garden/issues/9#issuecomment-4839211965 (issue-scoped reply, authorized by the issue-inbox contract; bot-fork/garden-repo only, no upstream agoric/agoric-sdk interaction).
- Updated durable memory `reference_xsnap_xs_repro_without_agoric_build` with the bisected thresholds, the STORED-zip/`__syncModuleProgram__`-patch reproduction recipe, and the next-consumer identity.
- No garden code changes (analysis/comment job); worktree clean, build tree restored to `stackCount=4096`.

**Follow-ups (unchanged, already tracked).** Q8 empirical confirmation (real swing-store + Inquisitor: control overflow / hex-fix completes / snapshot-compat across stackCount) stays queued on `verify-ymax0-hex-fix-inquisitor` / `reproduce-ymax0-v320-real-chain-state-20260630`, gated on a captured Polkachu snapshot.

Self-improvement: nothing this time (the reproduction-recipe gotchas — endo STORED-only zip, `__syncModuleProgram__` patching, seconds-not-hours worker rebuild — are captured in the reference memory where the next investigator will find them).
