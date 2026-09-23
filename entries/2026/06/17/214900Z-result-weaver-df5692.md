---
ts: 2026-06-17T21:49:00Z
kind: result
role: weaver
repo: endojs/endo-but-for-bots
project: endo
worktree: dispatches/weaver--df5692/project
refs:
  - entries/2026/06/17/212800Z-dispatch-weaver-df5692.md
---

Merged `endojs/endo@master` into the bot fork's `llm` branch as a 2-parent merge commit.

## Heads

- Pre: `origin/llm` at `9a3b5e97f` ("docs: Record PR merge-method preference (rebase, not squash)"). Bot-side `llm` was 1347 ahead of `endo-upstream/master` and 37 behind. The dispatch brief's "138 ahead / 920 behind" framed against the dispatch-prep snapshot at `68246ad92`, which is 565 commits behind current `origin/llm` (a `master`-merge already landed on llm at `11a76ae60` on 2026-06-06).
- Post: `origin/llm` at `f9ff85c55` ("chore: merge actual/master into llm (2026-06-14)"), 2 parents: `9a3b5e97f` (llm) + `a0f5d95ac` (endo-upstream/master tip, "chore: remove lerna.json (#3282)").

## Strategy

Merge (`git merge endo-upstream/master --no-ff`), not rebase. Standing policy for the bot fork's master-into-llm syncs (precedents: #426, #414, prior weekly cadence). Llm is the long-lived shared roadmap branch with 1347 commits of bot-side work no upstream merge should rewrite, and the open llm-targeted PRs (#454, #452, #450, #448, #445, #440, #432, #427, #424, #416, ...) all benefit from a discrete merge anchor rather than a rebase that breaks every in-flight head.

Re-anchored from the dispatch-prep snapshot (`68246ad92`) to current `origin/llm` tip (`9a3b5e97f`) before merging, since the snapshot was 565 commits stale and merging from the snapshot would have created a spurious second parent on already-merged history.

## Conflicts

Seven files:

- `CLAUDE.md` (add/add): kept the bot's 206-line Endo Project Guidelines. Upstream's 1-line `@AGENTS.md` bridge is upstream's Copilot-engine indirection; the bot fork's CLAUDE.md serves Claude Code's auto-load with substantive content. Cross-side reconciliation note: `AGENTS.md` auto-merged with upstream's added thunk-modules section.
- `package.json` (root devDeps): kept bot-only `turbo ^2.9.10`; took upstream bumps for `source-map ^0.7.6`, `ts-node-pack ^0.3.5`, `tsd catalog:dev`, `type-coverage ^2.29.7`. The bot's `.yarnrc.yml` catalog declares `tsd: ^0.33.0`, so `catalog:dev` resolves to the version the bot was pinning explicitly.
- `packages/evasive-transform/package.json`: kept bot's babel toolchain bump (dependabot landed `@babel/parser ~7.29.3`, `@babel/traverse ~7.29.0`); adopted upstream's new `@types/babel__generator` + `@types/babel__traverse` devDeps that accompany the new `makeEvasiveTransformVisitor` export (#3217).
- `packages/hex/package.json`: kept bot's cycle-break shape per #211 (Cut 2 of `designs/break-dev-dependency-cycles.md`): `@endo/hex` carries no devDeps on the four SCC members (`@endo/ses-ava`, `@endo/init`, `@endo/eventual-send`, `ses`). Test code lives in `@endo/hex-test`. Adopted upstream's `@endo/chacha12` + `@endo/random` devDeps because the bench files now import them; neither is in the SCC. Dropped upstream's `main.test.js` add (lives at `packages/hex-test/test/main.test.js` post-cycle-break). Took upstream's version bump to `1.1.1`.
- `tsconfig.composite.json`: union of references (alphabetical merge of upstream-added chacha12, chacha12-fast-check-test, random with bot-added chat, chat-network-view, sandbox). Auto-generated; `yarn build:types:check` confirms the union matches the generator's output.
- `typedoc.json`: union of exclude entries.
- `yarn.lock`: regenerated via `corepack yarn install`. Net: +140/-15 lines for the new upstream packages and bumped versions.

## Tests

- `corepack yarn workspace @endo/hex lint`: 0 errors, 4 pre-existing warnings.
- `corepack yarn workspace @endo/hex-test test`: 13/13 pass.
- `corepack yarn workspace @endo/evasive-transform lint`: 0 errors, 2 pre-existing warnings.
- `corepack yarn workspace @endo/evasive-transform test`: 52/52 pass.
- `corepack yarn workspace @endo/chacha12 lint`: 0 errors, 4 pre-existing warnings.
- `corepack yarn workspace @endo/chacha12 test`: 32/32 pass.
- `corepack yarn workspace @endo/random lint`: 0 errors, 1 pre-existing warning.
- `corepack yarn workspace @endo/random test`: 18/18 pass.
- `corepack yarn build:types:check`: composite tsconfigs up to date.

## Pre-push-gates

Ran `pre-push-gates.sh --probes-only`. Two non-fatal findings, both pre-existing on the upstream side I'm forwarding, not introduced by the resolution:

- `sentence-per-line-md`: many bot-side READMEs and a couple of upstream READMEs use multi-sentence physical lines. Out of scope for a sync; bulk-fix is a separate dispatch.
- `test-package-no-main`: `packages/chacha12-fast-check-test/package.json` declares `exports: {"./package.json": "./package.json"}` which the probe reads as a "main" entry. The self-reference is upstream's idiom for test-only packages; the probe's interpretation is over-broad. Surfaces as a probe sensitivity issue, not a real conflict.

## Out of scope

- The upstream shellcheck CI integration (#3300: `scripts/shellcheck.sh`, `yarn lint:sh`, folded into `yarn lint`) finds errors in five bot-only shell scripts not in this merge's path:
  - `evoke/config.sh` (missing shebang, SC2148)
  - `packages/fae/provider-setup.sh`
  - `packages/genie/test/integration.sh`
  - `packages/jaine/provider-setup.sh`
  - `packages/jaine/reload.sh`

  Follow-on shepherd dispatch drives the lint gate to green. The CI red is the validation gate; the precedent from #426 was the same shape ("CI is the validation gate. A follow-on shepherd dispatch drives CI to green").
- Upstream removed `lerna.json` (#3282); bot's root `package.json` still declares `lerna ^8.2.4` in devDeps. Lerna is unused (the `release-npm.mjs` script supplanted it); the devDep is benign. Removal is a separate sweep.

## Push

`git push origin HEAD:llm` from the dispatch project worktree. `llm` is not branch-protected (gh api 404 on `branches/llm/protection`), so direct push per dispatch authorization.

```
To github.com:endojs/endo-but-for-bots.git
   9a3b5e97f..f9ff85c55  HEAD -> llm
```

## Notice

Posted a top-level comment on the most recent llm-touching open PR (#454, "fix(daemon): resolve mail attachment pills via lookupByLocator"): https://github.com/endojs/endo-but-for-bots/pull/454#issuecomment-4735842634. Names the merge SHA, summarizes conflict resolutions, and flags the shellcheck follow-on so authors of in-flight PRs know what to expect when they rebase.

Self-improvement: nothing this time.
