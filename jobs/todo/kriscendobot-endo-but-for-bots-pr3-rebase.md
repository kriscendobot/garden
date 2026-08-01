---
role: weaver
tier: mentor
fallback-tier: minion
dispatch: automatic
posted_by: shepherd
---
# rebase (refresh stale frozen base) on kriscendobot/endo-but-for-bots PR #3

PR: https://github.com/kriscendobot/endo-but-for-bots/pull/3
Head: build/endo-regexp-conservative-subset-d891230c (bot-pushable)
Current frozen base: llm-b377b0e (b377b0ed051c7b7730067643ef592cb964c5b533)
Live llm tip at diagnosis: 67dfc18b1c803fab4d3ef9ab18eb3added99c15e (llm-67dfc18)

## Why (shepherd diagnosis, handed off — not a shepherd-scope fix)

CI is red on exactly ONE check: `lint`. Every other check (build, full test
matrix, cover, xs, hermes, test262, zizmor, …) is GREEN. The lint job exits 1 on
a single ERROR:

    packages/reminder/test/plugin.test.js:10:11
    error  'setTimeout' is already defined as a built-in global variable  no-redeclare

The offending line is a redundant `/* global setTimeout */` directive that
eslint 10.7.0's `no-redeclare` (builtinGlobals) flags.

This is NOT attributable to PR #3's diff:
  - PR #3 touches only packages/regexp/**, rust/mount_parity/**, Cargo.*, yarn.lock,
    .changeset/. It does NOT touch packages/reminder.
  - eslint is 10.7.0 on BOTH the frozen base and the head — the PR did not bump it.
  - The error file is IDENTICAL on the frozen base; the base itself is lint-red.
  - On LIVE llm, packages/reminder/test/plugin.test.js has been DELETED entirely
    (404) — so a refresh onto current llm clears this error for free.

## The task

Refresh PR #3's stale frozen base onto current llm and rebase the head, per
skills/frozen-base-branch (Rebase: move both base and head) + roles/weaver/AGENT.md.
Create a new frozen base at llm's current tip, rebase the head onto it,
force-push with --force-with-lease, and move the PR's `base` field.

IMPORTANT survey caveats (weaver, read before acting):
  - The frozen base b377b0e is NOT an ancestor of live llm (histories diverged).
  - This is a STACKED PR: base..head contains a `stack: merge endojs/endo-but-for-bots#654`
    merge commit and #127 mount-work commits (EndoMount.glob / mount revocation),
    though the PR's NET diff cancels those to just the regexp + rust/mount_parity
    additions. Survey divergence first (weaver procedure step 1); confirm the mount
    stack premise still holds on current llm before flattening. If the branch's
    premise no longer holds, escalate weaver→fixer or surface to the maintainer
    rather than forcing a lossy rebase.

After the refresh lands, CI re-runs; if still red the CI watcher re-posts an
auto-shepherd. A band-aid edit to the inherited reminder file on the head was
deliberately NOT applied: it would pollute the feature diff and create a
modify/delete conflict against llm's deletion — the refresh is the correct fix.
