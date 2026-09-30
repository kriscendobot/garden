---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Continue the pet-name-path-only sweep on endojs/endo-but-for-bots#1390 (part 5)

Repo: endojs/endo-but-for-bots. Continue on the EXISTING draft PR
https://github.com/endojs/endo-but-for-bots/pull/1390 (head `build/pet-name-path-only`,
pinned base `llm-8e53cc0`). Push follow-up commits to that head with
scripts/jobs/gardening/safe-push-pr-head.sh; do NOT open a new PR.
Predecessor: ebfb-petname-path-only-sweep-3 (head 5cab6a0080).

Done in sweep-3 (commits 795fa19377, 5cab6a0080): agentName options wrapped
(daemon tests, lal setup, fae subagent-host, chat whylip flow); provideAgent handle,
makeFromTree tree names, storeBlob archive name, provideHost in evaluated source;
claude-sandbox factory now passes paths (evaluate endowment list, adopt pet names,
resultName, remove) via a wrap-only `toPath` helper (edge names STAY strings: the
daemon's adopt does assertName(edgeName)); codex-sandbox audit journal, hosted-agent
account journal, claude-credentials storeValue wrapped. Reverted codemod false
positives: mount-file writeText(content), EndoRegistry.lookup(name, version),
EndoTraces.lookup(errorId), XS worker facet evaluate(source). chat, claude-sandbox,
codex-sandbox, hosted-agent, workflow, fae subagent-host suites pass locally.

Remaining:
1. packages/floot tests: 30 failures locally on 5cab6a0 (container-mounts,
   container-mounts-hosted, container-mounts-sandbox, dev-review, factory-turn,
   machine-admin-setup, machine-admin-workflows, registry-recovery,
   transcript-continuity, voice-preferences). Cause: test FAKES keyed by bare
   strings (`lookup: name => store.get(name)`, `storeValue: (value, name) => ...`)
   now receive arrays; also check floot src for remaining bare-string daemon calls
   (container-mounts-hosted fails with `Unknown session "one"` from
   agent.js assertSessionReady, so a store/lookup round-trip in src or fake mismatches
   — changing only the lookup/storeValue fakes to destructure `[name]` was NOT enough).
2. Watch CI on the new head (lint, test matrix incl. macOS, cover); CI fails fast per
   workspace, so more packages may surface after floot. A hosted-agent
   provider-worker macOS timeout on 795fa19 looked like a flake.
3. Local daemon suite: copy the worktree with `cp -al` to a SHORT path on the same
   device (e.g. /home/kris/garden2/scratch/e4; /var/tmp is cross-device) for the unix
   socket; rebuild better-sqlite3 with `npx node-gyp rebuild` in
   node_modules/.store/better-sqlite3-*/package. Full suite exceeds 45 min; run files
   in batches.
4. Pre-push gates, CI green, update the PR body status section, post the
   pr-completion summary comment.

Coordinate with https://github.com/endojs/endo-but-for-bots/pull/1343 (endowment value
side); rebase over it if it lands first. A gauntlet (ebfb-petname-path-only-sweep-gauntlet)
is also running against this PR; rebase before every push.

<!-- garden-productive-cycle -->
<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T10:43:18Z
