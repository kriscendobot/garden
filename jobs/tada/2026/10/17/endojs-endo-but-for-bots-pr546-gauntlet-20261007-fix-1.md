# Fix round 1: endojs/endo-but-for-bots PR #546

I applied the panel's must-fix items, plus some cheap should-fix items, and pushed them to `mirror/endo-3137-build-ts` (head `2f2c0a3bf5` → `678ecb680a`). CI is **green** on all 16 checks.

## Must-fix items addressed
- **saboteur: `--import amaro/strip` resolved from the user's working directory.**
  - New `packages/daemon/src/amaro-exec-argv.js` resolves the hook once from the daemon package with `import.meta.resolve`.
  - The daemon fork (`index.js`) and worker fork (`daemon-node-powers.js`) both use it. It doesn't add the flag again when the parent process already has it, which also covers the "duplicated wiring" and "double registration" should-fix items.
  - I checked it by forking from `/tmp` (works) and with the parent already loading the hook (no duplicate).
- **engine-realist: no Node version floor.**
  - `@endo/cli` and `@endo/daemon` now declare `engines.node >=22`, the minimum `amaro` supports.
  - `endo.cjs` now exits with a clear error on Node older than 22.
- **packager / changeset-auditor: changeset for a change the diff doesn't make.** I deleted `.changeset/ts-eslint-jsdoc.md`.
- **migrator: wrong bump levels.**
  - `@endo/eventual-send` and `@endo/patterns` go from `minor` to `patch`.
  - I dropped the `@endo/exo` entry, since the PR doesn't touch exo.
  - The changesets are rewritten to say where the moved helper types went, name the new `amaro` dependency and the Node 22 floor, and warn that installing from git or a workspace link isn't supported.
- **migrator: claim that published packages contain no `.ts` was unverified.** I ran `ts-node-pack` on both packages. The tarballs contain `src/E.js` and `src/patterns/patternMatchers.js`, with no `.ts` sources and no `.ts` import specifiers. The PR body and changeset now cite this.
- **archivist: `AGENTS.md` example pointed at an import that doesn't exist.** It now cites the real imports in `patterns/index.js` and `no-shim.js`.
  - `AGENTS.md` and `docs/typescript.md` now describe the mechanism that is actually used: Node's built-in stripping is on by default from Node 22.18 and 23.6, the CLI and daemon use `amaro/strip`, and `ts-node-pack` handles packing.
- **integrator: PR body didn't follow the template.** I rewrote it in template section order and kept the mirror header.

## Should-fix items also done
- Fixed stale comments in `captp/src/trap.js` (still said `E.js`) and `type-from-pattern.ts` (still mentioned `@ts-nocheck`).

## Unexpected CI failures
After the first push, two checks failed:
- **zizmor:** it passed on the old head in June. Since then, `actions/setup-node` moved its `v6` tag to v6.5.0 and `dorny/paths-filter` moved `v3` to v3.0.4. That made the existing `# v6` / `# v3` comments next to the pinned commits look wrong to zizmor. The pinned commits haven't changed, so I added a comment-only `ci:` commit naming the exact tags (`v6.4.0`, `v3.0.3`). Other PRs on the same frozen base will hit the same failure.
- **macOS, Node 22.x:** one daemon test failed (`indirect cancellation via worker`, "Unexpected dangling message"). The same test passed on ubuntu 22.x and macOS 24.x, so it looks like a timing flake. It passed on the next push.

## Local checks
- Daemon `tsc`, eslint on every file I changed, and prettier all pass. I did not run the full test suites locally; CI ran them.

## Commits
`281e4f0709` fix(daemon) · `6843984806` fix(cli) · `b5b18af7e7` docs · `4f7875c992` chore(changeset) · `678ecb680a` ci

## Follow-ups (should-fix items not done this round)
- Filtering inherited `--inspect` flags out of forked processes (inheriting them is already Node's default for `fork`).
- An XS bundle-and-run test.
- A CI step that runs tests against the packed output.
- Gaps in what the lint rule catches (`require`, template-literal imports).
- The `locksmith` item on `M.split` / `M.partial` (`patternMatchers.ts` around lines 2115–2128).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr546-gauntlet-20261007-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 100 tokens (4805441 cached reads)
- Output: 24800 tokens
- Cost: $2.4014961999999995
- Wall-clock: 1594s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
