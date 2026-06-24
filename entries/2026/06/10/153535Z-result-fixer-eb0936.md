---
ts: 2026-06-10T15:35:35Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo
dispatch_root: /home/kris/dispatches/fixer--eb0936
prs:
  - repo: endojs/endo-but-for-bots
    pr: 290
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/290
  - https://github.com/endojs/endo-but-for-bots/pull/290#pullrequestreview-4465009139
  - https://github.com/endojs/endo-but-for-bots/pull/290#discussion_r3385885381
  - https://github.com/endojs/endo-but-for-bots/pull/290#discussion_r3385889766
---

# result: fixer (eb0936) — PR #290 kriskowal CHANGES_REQUESTED applied

Addressed the two inline asks on kriskowal's 2026-06-10T06:07:44Z
CHANGES_REQUESTED review (`PRR_kwDORRE4FM8AAAABCiKh8w`,
review id `4465009139`) on PR #290 (`refactor(lal): adopt genie's
pi-based harness + memory internals`, branch
`feat/lal-pi-harness`).

## Pre / post branch tip

- Pre (at dispatch fetch): `9d6f2ee95553985706ce965045828213f3d3e141`
  (`test(lal): factor shared scripted-PiAgent setup into a test helper`)
- Post: `4d17336cf7a1c9332f7fbf99e4fa2618272803d9`
  (`chore: Update yarn.lock`)

Append-push only; no force, no amend.

## Commits

1. `83c8e3c70` `revert(lal): restore package description`
   - Reverts the gratuitous line-5 edit on `packages/lal/package.json`
     flagged at inline comment `3385885381`.
   - Restored `"description": "AI agent plugin for Endo"` (was
     `"AI agent plugin for Endo, built on the @endo/genie pi-based
     harness"`). Identified via `git show llm:packages/lal/package.json`
     per the dispatch brief.
2. `8055a33c3` `refactor(lal): vendor agent-round driver, drop @endo/genie dependency`
   - Addresses inline comment `3385889766`. Only `runAgentRound` was
     imported at runtime from `@endo/genie`. Vendored verbatim into
     new `packages/lal/agent-round.js` along with the sibling event
     factories used by lal's switch on `event.type`
     (`makeMessage`, `makeToolCallStart`, `makeToolCallEnd`,
     `makeThinking`, `makeUserMessage`, `makeError`) and the
     `inconceivable` / `mayJSONify` locals. Source attribution to
     `packages/genie/src/agent/index.js` lives in the file header.
   - One semantic divergence: the `message_start` switch's default
     arm now ignores unknown roles silently rather than calling
     `inconceivable(...)`. Required because pi-agent-core 0.79
     adds `bashExecution`, `custom`, `branchSummary`, and
     `compactionSummary` roles to the message union; the prior call
     no longer typechecks. Noted inline.
   - `packages/lal/agent.js` now imports `runAgentRound` from
     `./agent-round.js`. The three comments cross-referencing
     `@endo/genie` (the ollama-registration explainer at line 30,
     the in-line PiAgent rationale at ~849, the `buildOllamaModel`
     contrast at ~1255) are reworded to drop the comparison.
   - `packages/lal/package.json` drops the `@endo/genie:
     "workspace:^"` dependency.
   - `packages/lal/tsconfig.json` drops the `paths` redirect that
     pointed `@endo/genie` at the type-only shim.
   - `packages/lal/src/genie-shim.ts` is deleted (the package-local
     `src/` directory is now empty and removed).
   - `packages/familiar/scripts/bundle.mjs` keeps its
     `tsconfigRaw: '{}'` override as a defensive no-op for any
     future package-local tsconfig `paths`, but the comment is
     rewritten for the post-vendor reality (the override is no
     longer specifically about the genie-shim resolution).
   - `packages/lal/README.md` and `packages/lal/LAL-ARCHITECTURE.md`
     replace "built on `@endo/genie`'s pi-based agent loop" with
     "built directly on `@earendil-works/pi-agent-core` +
     `@earendil-works/pi-ai`".
3. `4d17336cf` `chore: Update yarn.lock`
   - Mechanical effect of removing the `@endo/genie` dep: the
     `@endo/genie@workspace:^` resolver dedupes to a single
     `@endo/genie@workspace:packages/genie` constraint (genie still
     depends on itself for its own workspace tests) and lal's
     dependency list loses the `@endo/genie: workspace:^` line.

## Local checks (in `packages/lal`)

- `yarn lint:eslint`: 0 errors, 51 warnings (all `jsdoc/reject-any-type`
  and `@jessie.js/safe-await-separator`; pre-existing pattern across
  the package's other source files; six matching warnings now also
  on the vendored `agent-round.js`).
- `yarn lint:types`: clean (0 errors).
- `yarn test`: 28 passed, 1 skipped (the simulator's real-provider
  path stays gated on `LAL_HOST`).
- `yarn prettier --check` on all touched files: clean.

## Replies and summary

- Inline reply on `3385885381` (line-5 revert thread):
  https://github.com/endojs/endo-but-for-bots/pull/290#discussion_r3389572099
- Inline reply on `3385889766` (vendor-and-drop-dep thread):
  https://github.com/endojs/endo-but-for-bots/pull/290#discussion_r3389573252
- Top-level summary comment citing both addressing SHAs:
  https://github.com/endojs/endo-but-for-bots/pull/290#issuecomment-4671845847
- Re-requested review from `kriskowal` via
  `gh api .../pulls/290/requested_reviewers --input -` (JSON-body
  form; the per-action authorization was carried by the dispatch
  brief's explicit "re-request review from kriskowal" instruction).

## CI state at termination

CI run on the new head (`4d17336cf`) is in progress at termination:
roughly half the matrix is still running. Of the completed checks,
`build`, `zizmor`, `familiar-bundle`, and `build-wasm` are green.
`test-xs` reported a single transient annotation
(`Failed request: (500)` against `.github`, no test-level
diagnostic; GitHub Actions infra error rather than a lal-side
regression — lal's `test:xs` script is `exit 0`). The
re-request-review step happened per the dispatch brief's explicit
instruction, ahead of full CI convergence; the brief took priority
over the default "wait for green before re-requesting" fixer norm.

## Recommended next stage

`next: shepherd` if CI surfaces a real failure once the in-progress
matrix completes; otherwise `next: none` and the maintainer's
review on the addressed `CHANGES_REQUESTED` is the next venue.
The dispatch brief did not include CI-wait responsibility for this
fixer.

Self-improvement: nothing this time. The dispatch brief was precise
(both inline asks named with exact line numbers and the
`git show llm:packages/lal/package.json` diff anchor), the vendoring
scope was naturally bounded by what lal actually imported, and the
tsc-divergence on pi-agent-core's wider message union was the only
non-mechanical decision and is documented inline.
