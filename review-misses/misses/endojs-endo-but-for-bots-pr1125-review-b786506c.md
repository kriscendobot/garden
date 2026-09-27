---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1125-review-b786506c
verdict: miss
category: correctness-bug
pr: 1125
cluster: vestigial-mechanism-unquestioned
review_at: 2026-09-17T05:43:56Z
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1125#pullrequestreview-5231650842
identity: endojs/endo-but-for-bots#1125:review:5231650842:retro
producing_role: builder
producing_job: endojs-endo-but-for-bots-pr1125-guest-restart-durable-integration-test-gauntlet
missed_by: code panel seats that reviewed the readable-directory type across 6 rounds (stylist, purist, prover, engine-realist); decomplector's minimum-viable-abstraction lens (design panel only) never applied
severity: minor
grounds: |
  Paraphrase: the maintainer (CHANGES_REQUESTED, body only, no inline comments)
  said he wants fewer formula types. He suspected that the readable directory
  the PR added as its own `readable-directory` formula type is an attenuation
  that an evaluation formula could express trivially: take a hub and call
  readOnly() on it.

  World check: the idiom already existed on llm before #1125. Mounts and files
  already expose readOnly() attenuated views (help-text-data.js on llm, before
  2026-09-10), and the eval formula is a long-standing primitive. So the
  simplification needs no new infrastructure. The primary's expanded-window
  child (tada 2026-09-17) implemented it in commit 42bad92360 ("express
  read-only directory as eval"). That commit removed the dedicated formula
  type plus its formula-record, type, manager, and inspector wiring. The split
  stack slice #1304 (read-only directory attenuation) then merged on that
  basis.

  Why it counts as a miss and not new direction: the gauntlet's code panel
  reviewed the `readable-directory` formula type in every round and polished
  it instead of asking whether it was needed. Fix-4 renamed
  formulateReadOnlyDirectory to formulateReadableDirectory to match the type,
  and purist documented the attenuation-unwrap in getAllNetworkAddresses.
  Panel-5's prover asked for coverage of that unwrap branch, and fix-1 carried
  readOnly() memoization and the unwrap as follow-ups. Adding a durable
  formula type widens persisted schema, the inspector, and type surface. It
  duplicated what composing existing primitives already did, which is the
  "job an existing mechanism already does, review hardens it instead of
  asking" shape of the vestigial-mechanism-unquestioned cluster (its first
  member is also from #1125: the redundant guest retention pin). No written
  standing rule says "minimize formula types". The garden's
  minimum-viable-abstraction lens (decomplector (f)) exists but runs only on
  the design panel, so no code seat asks it. That is why this is minor, not
  major. It is not evaluator-gaming, because no measurement moved.
---

The PR added a dedicated `readable-directory` durable formula type for a
read-only view of a directory hub. Composing existing primitives already covered
that job: an eval formula calling the hub's `readOnly()`, the same attenuation
idiom that mounts and files already expose. Six code-panel rounds renamed,
documented, and asked for tests of the new type's plumbing, but no seat asked
whether a new formula type was warranted. The maintainer asked, and the primary
removed the type in favor of eval + readOnly().
