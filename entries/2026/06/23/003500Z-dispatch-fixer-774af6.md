---
kind: dispatch
role: fixer
host: endolinbot
at: 2026-06-23T00:35:00Z
short_id: 774af6
dispatch_root: /home/kris/dispatches/fixer--774af6
repo: endojs/endo-but-for-bots
base_branch: master
model: claude-sonnet-4-6
authorizations:
  identity_switch: false
---

# fixer 774af6 — mirror endojs/endo#3099 onto endo-but-for-bots

Maintainer: "Please mirror https://github.com/endojs/endo/pull/3099 in the bots repo."

Upstream PR: endojs/endo#3099 by turadg, "perf(bundle-source): cut multi-entry agoric bundling time and add detailed profiling". +3199/-382, base `master`, head branch `codex/bundle-source-profiling`, mergeStateStatus BEHIND, reviewDecision REVIEW_REQUIRED.

Mirror procedure: fetch the upstream branch into the endo-but-for-bots worktree, port the commits onto current endo-but-for-bots master, push to a topic branch on origin (`mirror-endo-3099` or similar), open a DRAFT PR. The bot has direct push to endo-but-for-bots; no cross-fork compare-URL workaround needed. After PR opens the steward's per-cycle survey will pick it up for the gauntlet (cleaner → barrister → fixer-loop → appellate → un-draft).

Skipping researcher precedence with reason: this is a mechanical port of an existing upstream PR, not new design or implementation work. The fixer reads the upstream PR body, ports the commits, and opens the mirror. Researcher precedence applies to designer and builder dispatches per `roles/liaison/AGENT.md` § Researcher precedence on designer and builder dispatches.
