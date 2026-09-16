---
gate: orchestrated
orchestrated_by: ebfb-sturdyref-stack-rebase-20260916
priority: normal
role: weaver
posted_by: weaver
posted_at: 2026-09-16T11:00:47Z
---

---
role: weaver
tier: mentor
repo: endojs/endo-but-for-bots
fallback-tier: minion
dispatch: automatic
---
Rebase PR #871 (build/sturdyref-agent-surface) onto live `llm` as part of the sturdyref stack modernization.

THIS STEP'S PARAMETERS:
  PR:               #871
  BRANCH:           build/sturdyref-agent-surface
  OLD-OWN-HEAD-SHA: fbd0da9dcf792685ff179bc9a628f668c4c848c4
  NEW-PARENT-REF:   origin/build/sturdyref-bridge-6-three-party-roundtrip   (the already-rebased parent; fetch it fresh)
  OLD-PARENT-HEAD-SHA: 01a5801256ca3a5fe34b92d0daa579cc585cbe27

  Rebase command:
      git fetch origin
      git rebase --onto origin/build/sturdyref-bridge-6-three-party-roundtrip 01a5801256ca3a5fe34b92d0daa579cc585cbe27 fbd0da9dcf792685ff179bc9a628f668c4c848c4
  Force-push:
      git push --force-with-lease=build/sturdyref-agent-surface:fbd0da9dcf792685ff179bc9a628f668c4c848c4 origin HEAD:build/sturdyref-agent-surface

IMPORTANT: #871 is the TOP of the stack, not a PR on live llm. Its PR base field
wrongly says `llm`; its true parent is #704 (build/sturdyref-bridge-6-three-party-roundtrip).
Use the REAL origin branch tip fbd0da9 as OLD-OWN-HEAD (GitHub's cached PR head
2e90885 is stale). After rebase + force-push, fix the base field:
    gh pr edit 871 --repo endojs/endo-but-for-bots --base build/sturdyref-bridge-6-three-party-roundtrip

## Shared context (sturdyref stack modernization, orchestration ebfb-sturdyref-stack-rebase-20260916)

You are ONE rebase step in a serial, bottom-up modernization of the 10-PR sturdyref
bridge stack in endojs/endo-but-for-bots, moving the whole stack off the frozen
snapshot `llm-da209e5-endo-ascii` (2026-07-13) and onto live `llm`. The target
decision (rebase onto live `llm`, NOT re-cut a new snapshot) was made because:
@endo/ascii — the sole reason the `-endo-ascii` snapshot existed — has since LANDED
on live `llm` (packages/ascii present, tree matches the snapshot bar a version
bump), `llm-da209e5` is a clean ancestor of `llm`, and only #752 independently uses
`llm-da209e5` (untouched by this work) while only stack-bottom #774 used
`llm-da209e5-endo-ascii`.

The stack, bottom→top, with PRE-REBASE head SHAs (authoritative, captured
2026-09-16 from origin):
  #774 build/sturdyref-shim-first-wins                 1fb7a203a4333e94cafc2309b3a9b0dca3e0e31e  (was on llm-da209e5-endo-ascii = 103faab721eb197e3b902ca0f751d1511edabf3f)
  #737 build/sturdyref-pass-style-ocapn-single         1854bdc2475b95805e6f40e91f71b07d190aad7c
  #541 build/sturdyrefs-endor-syscall-retention        5e385385463b4626e39c3d470748e92b6e3c09cb
  #698 build/sturdyref-bridge-1-bytes-wire-read        9082faf7836f7d42fc15e317fbba8ac22acdf831
  #700 build/sturdyref-bridge-2-ocapn-promotions       e4ebfc58ec6051cfcbdfc893a7518f60752213f6
  #701 build/sturdyref-bridge-3-daemon-mint-export     664563c422f611c52f5705d5068dcd921e49477c
  #702 build/sturdyref-bridge-4-ocapn-singleton        44bdb01e0f4bb46389d579ea76ab06aaadd3787b
  #703 build/sturdyref-bridge-5-foreign-internalization c11c2e06788171de929dc5bd681b0fe8a0194b7d
  #704 build/sturdyref-bridge-6-three-party-roundtrip  01a5801256ca3a5fe34b92d0daa579cc585cbe27
  #871 build/sturdyref-agent-surface                   fbd0da9dcf792685ff179bc9a628f668c4c848c4  (NOTE: GitHub's cached PR head 2e90885 is STALE; the real origin branch tip is fbd0da9; use the live branch tip)

Because this is SERIAL and bottom-up, when your step runs your PARENT branch has
ALREADY been rebased onto live `llm` and force-pushed by the previous child. You
replay ONLY your PR's own commits onto that rebased parent.

## Procedure for THIS step

1. Get an isolated project checkout for THIS job base:
   /home/kris/garden/scripts/jobs/ensure-project-worktree.sh <THIS-JOB-BASE> endojs/endo-but-for-bots llm
   cd into the path it prints. `git fetch origin` there.
2. Rebase your PR's own commits onto the rebased parent (SHAs below), using
   --onto so only your commits replay:
       git rebase --onto <NEW-PARENT-REF> <OLD-PARENT-HEAD-SHA> <OLD-OWN-HEAD-SHA>
   Resolve conflicts with real understanding of BOTH sides — the sturdyref change
   AND ~2 months / ~2385 commits of `llm` evolution. 49 of 96 stack files also
   drifted on `llm` (heaviest in packages/daemon/{daemon,host,guest,directory,
   interfaces,types.d.ts}, packages/ocapn/*, packages/pass-style/*, marshal).
   Expect real conflicts; this is not mechanical.
3. Verify the rebased branch's diff contains ONLY your PR's own commits/files:
       git log --oneline <NEW-PARENT-REF>..HEAD
       git diff --stat <NEW-PARENT-REF>..HEAD
   The commit list must equal your PR's own commits (same count, same intent), and
   the file set must be your PR's footprint — nothing leaking from the parent.
4. Local-verify the touched packages (skills/local-verify): at minimum
   `yarn build:types:gen` if package deps changed, `yarn lint` and `yarn test` for
   the touched packages. A CI-equivalent local failure is a defect to fix here, not
   push past (see memory: CI failure = automation defect). Watch the
   composite-tsconfig drift check and the repo-root checkJs tsc.
5. Force-push with lease bound to your captured OLD head so a concurrent push is
   never clobbered:
       git push --force-with-lease=<BRANCH>:<OLD-OWN-HEAD-SHA> origin HEAD:<BRANCH>
6. Confirm on GitHub the PR is MERGEABLE and its diff shows only its own commits
   (base field points at the parent BRANCH NAME, which force-push preserves).
7. Report the new head SHA of your branch (the next child needs it as its
   NEW-PARENT-REF). If you hit an unresolvable conflict or verify failure you
   cannot close, do NOT force-push a broken branch — report the blocker so the
   serial orchestration halts cleanly.

Do NOT merge anything. Do NOT undraft. Deliverable is a cleanly-rebased,
truthfully-based branch ready for normal review.
