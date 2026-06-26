# Fix the conductor spine: after merging onto a FROZEN base, do step-2 unfreeze-to-live-llm automatically

Wear the **mentor** role. The conductor spine **`scripts/jobs/gardening/ci-wait-merge.sh`** merges
a PR onto its base and stops — but when the base is a **FROZEN snapshot** (e.g. `llm-65b0abe`, a
pinned point used so a stacked PR's base does not move under it), the conductor role brief's
**step 2 is to UNFREEZE: forward the merged content to live `llm`**. The spine **skips step 2**, so
content **strands on the stale snapshot** and never reaches live `llm` (observed: #510 merged onto
`llm-65b0abe`, 186 commits behind live `llm`; its design content never reached live `llm`).
Infrastructure on `main2` (bot identity; isolated worktree off `origin/main2`; redeploy).

## Fix

- After a successful merge onto a base that is a **frozen snapshot** (detect via the
  `frozen-base-branch` convention — a base name like `<branch>-<sha>` pinned off `<branch>`), the
  spine must perform the **conductor step-2 unfreeze**: forward the just-merged content to **live
  `<branch>`** (here `llm`), per `roles/conductor/AGENT.md` and `skills/frozen-base-branch`.
- **Handle shared-stack safety:** if other OPEN PRs share the same frozen base (a stack), forwarding
  one alone would fork it off the shared base. Detect this case and either weave the stack forward
  together or, when that is not safe to do unilaterally, **alert the maintainer with the specific
  stack** (the #510/#521 situation) rather than silently stranding OR silently forking. Do not
  unilaterally rebase a shared base when siblings still sit on it without surfacing it.
- This is the THIRD ci-wait-merge.sh reliability gap today (with `fix-ci-wait-merge-gh-path` and
  `harden-conductor-ci-wait-complete-merge`); coordinate with those — the spine should reliably
  (a) find its tools, (b) complete the merge, and (c) unfreeze to live branch.

## Tests & verification

- Simulate a merge onto a frozen `<branch>-<sha>` base with no siblings → content appears on live
  `<branch>`. With an open sibling sharing the base → the maintainer is alerted (not stranded, not
  force-forked). `shellcheck`/`bash -n` clean.

## Definition of done

ci-wait-merge.sh performs the step-2 unfreeze to the live branch after merging onto a frozen base
(forwarding content, or alerting on a shared stack), so content no longer strands on stale
snapshots — committed/pushed to `origin/main2`, redeployed, tests added. Report the SHA and the
unfreeze/shared-stack behavior.

Posted by the liaison on behalf of the maintainer (#510 stranded on llm-65b0abe).

---
claim:
  host: endolinbot
  gardener: 83
  claimed_at: 2026-06-26T01:37:29Z
