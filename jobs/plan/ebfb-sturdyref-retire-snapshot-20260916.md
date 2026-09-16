---
gate: orchestrated
orchestrated_by: ebfb-sturdyref-stack-rebase-20260916
priority: normal
role: weaver
posted_by: weaver
posted_at: 2026-09-16T11:00:52Z
---

---
role: weaver
tier: mentor
repo: endojs/endo-but-for-bots
fallback-tier: minion
dispatch: automatic
---
Final cleanup step of the sturdyref stack modernization: retire the now-obsolete
frozen snapshot and verify the whole stack is truthfully based.

Preconditions (all 10 rebase children ran before you): #774…#704 rebased onto live
`llm` and #871 rebased onto rebased-#704. Do this:

1. `git fetch origin` in an isolated project checkout
   (/home/kris/garden/scripts/jobs/ensure-project-worktree.sh <THIS-JOB-BASE> endojs/endo-but-for-bots llm).

2. VERIFY nothing still bases on the snapshot before deleting it:
       gh pr list --repo endojs/endo-but-for-bots --state open --base llm-da209e5-endo-ascii --json number
   MUST be empty (only #774 ever used it, and it was moved to `llm`). If non-empty,
   STOP and report — do not delete.

3. Delete the obsolete snapshot branch:
       git push origin :llm-da209e5-endo-ascii
   (Equivalently `gh api -X DELETE repos/endojs/endo-but-for-bots/git/refs/heads/llm-da209e5-endo-ascii`.)

4. Do NOT touch `llm-da209e5` — it is still used by #752
   (refactor/agentry-power-attenuator-presets) and must remain.

5. Final truth audit — for each PR, confirm base field points at what it actually
   sits on and the diff shows only its own commits:
       #774 base=llm ; #737 base=build/sturdyref-shim-first-wins ;
       #541 base=build/sturdyref-pass-style-ocapn-single ;
       #698 base=build/sturdyrefs-endor-syscall-retention ;
       #700 base=build/sturdyref-bridge-1-bytes-wire-read ;
       #701 base=build/sturdyref-bridge-2-ocapn-promotions ;
       #702 base=build/sturdyref-bridge-3-daemon-mint-export ;
       #703 base=build/sturdyref-bridge-4-ocapn-singleton ;
       #704 base=build/sturdyref-bridge-5-foreign-internalization ;
       #871 base=build/sturdyref-bridge-6-three-party-roundtrip .
   For each: `gh pr view N --json baseRefName,mergeable` and spot-check
   `git diff --stat origin/<base>..origin/<head>` is only that PR's footprint.

6. Report the final per-PR base + head SHA table and mergeability. Do NOT merge or
   undraft anything.
