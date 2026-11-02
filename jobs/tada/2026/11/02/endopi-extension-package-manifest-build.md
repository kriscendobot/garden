---
handed-off: endopi-extension-package-manifest-build-open-pr
deliverable-complete: false
---
**Handed off: the code is pushed, but the draft PR isn't open yet, and the design is only partly delivered.** This host's PAT gets a 403 on `createPullRequest`, so I posted `endopi-extension-package-manifest-build-open-pr`, pinned to `endolin-garden-ece02cb4`, to open it. Affected packages are `@endo/cli` and `@endo/tar`.

**Branch:** `feat/endopi-extension-package-manifest` at `6836200e18`, on the frozen base `llm-48d6f3e`, which is the current `llm` tip. It has three commits: `feat(tar)`, `feat(cli)`, and a separate `chore: Update yarn.lock`.

## What changed
- **Install:** `endo install` reads the `endo` key in `package.json`, or discovers the conventional directories if the key is absent. It takes `npm:`, `git:` or a local path, with `--project` for project-local installs.
- **Where files go:** skills go to `.agents/skills/` and prompts to `.agents/prompts/`. Installs are recorded in `.agents/endo-packages/packages.json`.
- **Lifecycle:** `endo list packages`, `endo remove <source>`, `endo config [enable|disable]` and `endo update`, which skips pinned installs.
- **Safety:**
  - npm lifecycle scripts stay off.
  - Symlinks, path traversal and unusual source strings are refused.
  - Inflated npm archives are capped at 256 MiB.
  - Installs won't overwrite resources owned by the user or another package, and a failed install rolls back.
- **`@endo/tar`:** entries now report `mode`, so packaged scripts stay executable. Its types moved to `types.d.ts`, as the probe requires.
- **Docs:** added a CLI README section and a changeset, and moved the design to In Progress in `designs/README.md`.

## Not delivered
The PR ledger marks this `orchestrated-slice`, so it can go through the gauntlet but stays draft until the rest lands.
- **Guests:** the design relies on an "existing `endo install` path" and guest store, but commit `8a1f07d38` removed both before the design was written. `guests/` is reported as pending, and I didn't invent a store.
- **Providers:** these wait on the provider registry in endojs/endo-but-for-bots#1587, so they are also reported as pending.
- **Successor:** `endopi-extension-package-guest-provider-kinds` owns both and is parked in `plan/` awaiting go-ahead.

## Decisions for the maintainer (also in the PR body)
1. Where should guests go, and is it right to bring back the `endo install` verb that the March commit removed?
2. Is it acceptable that `endo list packages` shadows a daemon directory with the pet name `packages`, and that `endo remove` treats pet names starting `npm:`, `git:` or `file:` as packages? A separate `endo packages` verb would avoid both.

## Verification
- **Tests:** 46 new CLI tests pass, including end-to-end runs with no daemon, and all 25 `@endo/tar` tests pass, including one new `mode` case. Disabling each of six safeguards made its matching test fail.
- **Static checks:** scoped ESLint has no errors, `tsc` passes for both packages, and the pre-push probes pass. The one advisory is a comment I kept on purpose. The probes ran with `--no-auto-fix --probes-only`, because repo-wide lint outlasts tool limits on this host.
- **Not yet run:** CI hasn't run, so it will be the first full lint and full test run. The wider CLI suite wasn't run; beyond the new tests I only ran its `paths-command` and `list-grouping` tests.
- **Real fetches:** `npm:is-odd@3.0.1` and `git:github.com/jonschlinkert/is-odd` fetched and were correctly refused for having nothing to install. No real npm or git package with skills has been installed; placement is only tested through local paths.

## Known gaps
- Concurrent installs in one scope aren't locked against each other.
- A process crash mid-install can leave moved resources and a `staging-*` directory behind.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endopi-extension-package-manifest-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (4619004 cached reads)
- Output: 78780 tokens
- Cost: $4.0532408
- Wall-clock: 3581s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
