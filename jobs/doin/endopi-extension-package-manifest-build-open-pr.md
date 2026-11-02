---
posted_at: 2026-11-02T16:58:13Z
requires: host=endolin-garden-ece02cb4
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Relay from `endopi-extension-package-manifest-build`: the build is finished and pushed, but host oros-studio's PAT gets a 403 on `createPullRequest`. Open the DRAFT PR and do nothing else.

- Repo: `endojs/endo-but-for-bots`
- Head: `feat/endopi-extension-package-manifest` at `6836200e1845959f79dabb336047ecb679aced50`
- Base: `llm-48d6f3e` (frozen, already on the remote)
- Title: `feat(cli): install packages of skills and prompts with one command`

Steps:

1. `/Users/dom/garden/scripts/jobs/ensure-project-worktree.sh endopi-extension-package-manifest-build-open-pr endojs/endo-but-for-bots feat/endopi-extension-package-manifest`, then `cd` to the path it prints. `ensure-pr.sh` must run from that project worktree.
2. Save everything between the BODY markers below to a file, without the markers.
3. Run `scripts/jobs/gardening/ensure-pr.sh endopi-extension-package-manifest-build endojs/endo-but-for-bots feat/endopi-extension-package-manifest llm-48d6f3e --title '<the title>' --body-file <file>` from the garden root path. Keep the job base `endopi-extension-package-manifest-build` so the durable marker matches the original job.
4. Name the PR number and affected packages (`@endo/cli`, `@endo/tar`) in your completion report, so the gauntlet is staged. Do not change the code, run the panel, or un-draft.

The PR is an `orchestrated-slice`. Its successor, `endopi-extension-package-guest-provider-kinds`, is parked in `plan/` awaiting the maintainer's go-ahead. After the PR opens, replace `the matching PR` in that parked job's body with the PR number if that is simple.

----- BODY -----
Refs: `designs/endopi-extension-package-manifest.md` (M10), endojs/endo-but-for-bots#265 (endopi design raft)

## Description

One `package.json` key and one command now install a package's skills and prompts, so an author no longer needs a separate distribution channel for each.

- **Manifest.** `packages/cli/src/packages/manifest.js` reads the `endo` key. Without that key, it discovers the conventional directories. Unknown keys are ignored, so the manifest stays forward-compatible.
- **Sources.** `packages/cli/src/packages/fetch.js` resolves `npm:<name>[@version]`, `git:<host>/<path>[@reference]`, and local paths.
- **Placement and lifecycle.** `packages/cli/src/packages/store.js` copies skills to `.agents/skills/<name>/` and prompts to `.agents/prompts/<name>.md`, under the home directory or, with `--project`, the current directory. It records each install in `.agents/endo-packages/packages.json`. The verbs are `endo install`, `endo list packages`, `endo remove <source>`, `endo config [enable|disable <source>]`, and `endo update [sources...]`.
- **`@endo/tar`.** Entries now report `mode`, because a skill's helper script has to stay executable after unpacking. Its entry types moved to a hand-written `types.d.ts`, as the typedef probe requires of a touched types module.

The most important file to review is `store.js`, which holds the refusal rules and the rollback.

### Decisions for the maintainer

1. **Where should guests go?** The design calls `endo install` "the existing path" and names a guest-plugin store. Commit 8a1f07d38 removed both in March, before the design was written. This PR reintroduces the verb only for this manifest and does not revive weblet installation; say so if the verb should stay retired. `guests/` is reported and recorded as pending, and a store has not been invented for it.
2. **Is shadowing a `packages` directory acceptable?** `endo list packages` is the design's spelling, so a daemon directory with the pet name `packages` can no longer be listed by that exact command. `endo remove npm:foo` similarly treats a pet name beginning `npm:`, `git:`, or `file:` as a package. A separate `endo packages` verb would avoid both.

### Security Considerations

Installing runs no package code: `npm pack` gets `--ignore-scripts`, and `git clone` gets no submodules and `GIT_TERMINAL_PROMPT=0`. Source patterns admit only ordinary names and references, so a source cannot reach `npm` or `git` as an option or a transport URL, and git sources are always https.

A package is treated as an untrusted tree. A symbolic link or special file inside a resource refuses the whole install, as does a declared directory that leaves the package lexically or through a parent link. A tar entry that traverses or is a link is also refused, and inflated npm archives are capped at 256 MiB.

Installing never overwrites a resource that another package or the user put in place. `endo remove` deletes only names in the package's record, and those names are revalidated when the ledger is read, so an edited ledger cannot direct a deletion outside the scope.

### Scaling Considerations

These are one-shot, user-driven commands that copy small trees. Concurrent `endo install` runs in one scope are not locked against each other, and the later ledger write wins.

### Documentation Considerations

The CLI README gains a Packages section. The design now records that guests and providers have no destination, and its status moves to In Progress here and in `designs/README.md`.

### Testing Considerations

`packages/cli/test/packages.test.js` has 46 cases, including end-to-end CLI runs against a temporary home directory with no daemon. `packages/tar/test/reader.test.js` gains a case for `mode`. Disabling the symlink refusal, the parent-link check, the rollback, the ledger validation, the tar link refusal, and the parent-command `--project` lookup each failed the matching test.

Real `npm:is-odd@3.0.1` and `git:github.com/jonschlinkert/is-odd` runs fetched, unpacked, and correctly refused those packages for having nothing to install. No real registry or git package with skills has been installed; the placement path is covered through local paths and an injected command runner.

Lint was scoped to the changed files because repo-wide lint outlasts the tool limit on the build host, so CI is the first full lint. The rollback does not cover a process crash mid-install, which can leave moved resources and a `staging-*` directory behind.

### Compatibility Considerations

Additive except for the two shadowing cases above. `TarEntry` gains a field, and `@endo/tar`'s runtime exports are unchanged. `install` moves from the help screen's Execution group, where it had been a stale listing, to a new Packages group.

### Upgrade Considerations

None. There is no prior install ledger to migrate.

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Design: `designs/endopi-extension-package-manifest.md`
Also touched: `designs/README.md` (status row only)
Disposition: orchestrated-slice
Successor: endopi-extension-package-guest-provider-kinds
Phase 1: partial | manifest read and skill installs are done and tested; the guest step is open because 8a1f07d38 removed its store and the maintainer must name a destination
Phase 2: partial | prompts are done and tested; providers are open pending the registry in endojs/endo-but-for-bots#1587
Phase 3: satisfied | `endo list packages` and `endo remove`, exercised end to end in `packages/cli/test/packages.test.js`
Phase 4: satisfied | `endo config enable|disable`, exercised end to end in the same test file
Phase 5: satisfied | pinned sources and `endo update`, with the skip exercised end to end; only the local-path update path has run for real
Acceptance: partial | the design names no acceptance section; 46 CLI tests and 25 tar tests pass locally, and CI has not run yet
<!-- /garden-phase-evidence-ledger -->

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END BODY -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-02T22:37:16Z
