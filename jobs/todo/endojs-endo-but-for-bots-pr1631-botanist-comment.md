---
posted_at: 2026-11-01T23:28:32Z
role: botanist
tier: mentor
requires: host=endolin-garden-ece02cb4
fallback-tier: minion
dispatch: automatic
---

# Post the botanist position comment on endojs/endo-but-for-bots PR #1631

Host oros-studio-garden-ce242c49's bot PAT cannot comment on endojs PRs (403). Post the comment below **verbatim** as a single PR comment:

    gh pr comment 1631 -R endojs/endo-but-for-bots --body-file <file>

First check that no comment carrying the marker `<!-- garden-job: endojs-endo-but-for-bots-pr1631-dependabot -->` already exists, so the post is idempotent. Do nothing else: no merge, no close, no push.

----- COMMENT BODY BELOW -----
<!-- garden-job: endojs-endo-but-for-bots-pr1631-dependabot -->
## Botanist position: escalated to a fixer (`next: fixer`), not yet MERGE-NOW

The supply-chain legs below all clear. The PR is held only by an ava 8.1 test-harness regression whose repair needs a project decision.

**Headline:** `all-minor-patch` group, 23 direct bumps across the root and 14 workspace manifests: typescript-eslint family 8.71.1→8.72.0, ava 8.0.1→8.1.2, eslint-plugin-jsdoc 65.3.12→65.4.2, js-yaml 5.4.3→5.5.0, turbo 2.11.7→2.11.10, type-coverage 2.30.3→2.30.4, unist-util-visit 5.1.0→5.2.0, @earendil-works/pi-tui 1.3.0→1.4.0, rollup 4.64.5→4.65.0, amaro 1.2.1→1.2.2, marked 18.1.0→18.1.1, react/react-dom 19.3.0→19.3.1, playwright/@playwright/test 1.64.0→1.64.1, @number0/iroh 1.1.0→1.2.0, openai 7.32.0→7.43.0, core-js 3.50.0→3.51.0.

**Supersession:** none. Of the other open Dependabot PRs, #1629, #1633 and #1635 each move a different dependency. Base-ref census: `llm` (`bcbde90be`) still resolves every headline at its outgoing version (ava 8.0.1, turbo 2.11.7, rollup 4.64.5, openai 7.32.0, core-js 3.50.0, …), so the base is behind everywhere and this PR is live. The head was 1 ahead, 2 behind (two zizmor-action commits, no overlap).

### Lockfile transitive set
101 resolutions added and 93 removed. Most of that count is platform binaries: 25 `@rollup/rollup-*`, 12 `@number0/iroh-*`, 6 `@turbo/*`, and 11 `@typescript-eslint/*`.
- **Packages new to the tree (4):** `@es-joy/escodegen@4.2.0` and `@es-joy/estraverse@7.1.1` (new deps of eslint-plugin-jsdoc, published by its maintainer brettz9, 2025-09/10), `marked-cjk-friendly@0.1.2` (new dep of marked 18.1.1, trusted-publishing provenance, 2026-09-19), and `word-wrap@1.2.5` (via `optionator@0.9.4`, 2023). All are MIT or BSD.
- **New major lines of packages already in the tree:** these all come in through ava 8.1.2 and eslint-plugin-jsdoc: chalk 6.0.1, ansi-styles 7.0.0, pretty-ms 10.0.0, matcher 7.0.0, @es-joy/jsdoccomment 1.0.0, argparse 3.0.4 (PSF-2.0, the same Python license family as the in-tree argparse 2.0.1), and others. No license changed on any package that moved.
- **Freshest moved version:** `unist-util-visit@5.2.0`, published 2026-10-24T18:44:36Z. That is a headline package. No moved version was under 24h old when the PR opened.
- **Maturity floor:** 2026-10-31T18:44:36Z, which has passed.
- **Publishers:** every human-published version comes from that package's long-standing maintainer (vitaly, sindresorhus, zloirock, marijn, doowb, brettz9, wooorm, plantain_00). Everything else carries npm trusted-publishing provenance (`_npmUser: GitHub Actions` with `dist.attestations`). No publisher moved from provenance to a human account.

### Advisory check (both sides)
- OSV `querybatch`: **0** advisories on the 101 incoming versions and **0** on the 93 outgoing versions.
- GHSA ranges checked by hand for turbo, rollup, marked, react, js-yaml and playwright: none covers the incoming versions.
- `yarn npm audit --all --recursive`: the only hits on packages this PR touches are on versions it does **not** move (in-tree js-yaml 3.14.2/4.1.x and picomatch 2.3.1/4.0.2, both pre-existing). The incoming js-yaml 5.5.0 and picomatch 4.0.7 are clean.

### Source read
- Install was done with scripts disabled (warm-cache `scripts-disabled` cold build at `7acf9fc2202f`).
- The only install script in the moved set is core-js's existing `postinstall` banner. Its `postinstall.js` is byte-identical between 3.50.0 and 3.51.0.
- I diffed the old and new tarballs of 16 non-provenance or high-fan-out movers (js-yaml, core-js, type-coverage(-core), emittery, unist-util-visit(-parents), picomatch, pretty-ms, matcher, globby, p-map, @es-joy/jsdoccomment, argparse, acorn, chalk), plus ava, looking for new `child_process`, network, `eval`/`Function`, `process.env` or file-write sites. None appeared. The js-yaml 5.5.0 delta is parser work (tag percent-encoding, folded scalars, a non-printable check). The unist-util-visit delta is types only. ava's `child_process` use (fork.js) is unchanged.
- No text addressed to an AI reviewer was found.
- Prose gate: the classifier was **unavailable** (`TYPESAFE_API_KEY absent`, `proceed_unclassified`), and the Dependabot PR body was read as untrusted data. I read no upstream changelogs. The findings above come from registry metadata and code.

### CI, and the migration that made it green (disclosure)
The original head `3731a28e1` was **red for a real reason** in `@endo/exo-git` (test, 3 legs) and `@endo/sandbox` (cover):

> `Cannot assign to read only property 'lastIndex' of object '[object RegExp]'`

The cause: ava 8.1.0 added `matches(regex, string) { regex.lastIndex = 0; return regex.test(string); }` in `lib/assert.js`. It writes `lastIndex` unconditionally, not only for `g`/`y` regexes. A regex frozen by `harden()` rejects that write. ava 8.3.0 (latest) keeps the same write, so the fix has to come from this repo.

It follows mechanically from the upgrade and is confined to tests. Six table-driven tests keep their expected-message regexes in a `harden()`ed case array. Commit `102154e1b` now passes ava `new RegExp(message)` at each assertion site, a writable copy with the same source and flags. The tables stay hardened, and each assertion matches exactly what it matched before. No project code or contract changes. The six files:
- `packages/exo-git/test/git-remote-policy.test.js`
- `packages/sandbox/test/podman-policy.test.js`
- `packages/codex-sandbox/test/codex-session-plan.test.js`
- `packages/opencode-sandbox/test/opencode-backend-factory.test.js`
- `packages/opencode-sandbox/test/opencode-session-plan.test.js`
- `packages/opencode-sandbox/test/opencode-session-storage.test.js`

All six pass locally on ava 8.1.2 (7, 66, 17, 18, 17 and 13 tests). The sandbox `cover` legs went green on that head.

**Rebase:** the base moved under the PR (#1635, eslint-plugin-unicorn 73 to 79), which left it `CONFLICTING`. I rebased it onto `llm` `4ae452c59` as `cedf99cd6` + `401fd7c0f`:
- The manifests had adjacent-line conflicts: I kept unicorn `^79.0.0` from #1635 and this PR's jsdoc `^65.4.2` and typescript-eslint `^8.72.0`.
- yarn.lock comes from a three-way, per-descriptor merge, then `yarn install --mode=update-lockfile`. It moves **exactly** the same 101 resolutions as the original head relative to the base. A plain re-resolve would have pulled in releases newer than the floor (rollup 4.67.4, openai 7.47.0, typescript-eslint 8.72.1, …), so I avoided it.
- `yarn install --immutable` passes.

### Remaining blocker (why this is not MERGE-NOW yet)
`@endo/claude-sandbox` `test/mcp-bridge.test.js` › *socket server relays JSON-RPC over a Unix socket…* fails intermittently. The symptom is `Test timeout exceeded`, then an unhandled `Cannot find module 'lodash/isLength'` from ava's concordance. It hit CI job 124985662433 (test 22.x ubuntu).

Attribution, from runs of that file alone:

| ava version | passes |
| --- | --- |
| 8.0.1 | **8/8** |
| 8.1.2 | **4/8** |
| 8.1.2 with its new lazy `lib/concordance.js` made eager | **8/8** |

The cause is ava 8.1.0's lazy `createRequire(import.meta.url)('concordance')`, which now runs mid-test. ava 8.3.0 is unchanged. This is a regression this upgrade introduces, not a flake. The remedy takes a project choice (a preload or config workaround, or holding ava at 8.0.x out of the group), which makes it not a mechanical consequence of the upgrade. I have therefore not landed it, and escalated it to the fixer job `endojs-endo-but-for-bots-pr1631-ava-lazy-concordance`.

The other red leg, test (22.x, macos-15) `restore-context.test.js` "Uncaught exception", is a **pre-existing macOS flake**: the same failure occurs on an unrelated ava-8.0.1 branch (job 124899623720).

**Next:** once the fixer's repair is green, the daily dependabotany recheck re-evaluates this PR from the ledger and conducts it through `ci-wait-merge.sh --dependabot-auto-merge`.
