---
ts: 2026-06-04T03:49:46Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_short_id: e2458c
prs:
  - repo: endojs/endo-but-for-bots
    pr: 418
    role: target
refs:
  - entries/2026/06/04/034650Z-dispatch-liaison-e2458c.md
  - https://github.com/endojs/endo-but-for-bots/pull/418
  - https://github.com/endojs/endo-but-for-bots/actions/runs/26922773730
---

# result: fixer — #418 lint fix (composite tsconfig drift)

## Lint failure cause

The CI `lint` job failed at the **Check composite tsconfig files are
up to date** step, not at `yarn lint`. Failure log line:

> Drift detected: packages/daemon/tsconfig.composite.json
> Run `yarn build:types:gen` to regenerate composite tsconfig files.

Cause: the prior fixer commit (091a1a, "refactor(daemon): inject
evasive-transform parsers from worker-node-powers") added
`@endo/evasive-transform` as a dependency in
`packages/daemon/package.json` but did not regenerate the matching
composite tsconfig. The generator at
`scripts/generate-composite-tsconfigs.mjs` derives project references
from declared workspace dependencies; a workspace dep added without
running the generator leaves the composite tsconfig stale, which is
the exact drift CI's `build:types:check` step is designed to catch.

`yarn lint` itself produced 0 errors (390 warnings, all pre-existing
in @endo/daemon and outside this PR's diff).

## Files touched

- `packages/daemon/tsconfig.composite.json` — single insertion of
  `{ "path": "../evasive-transform/tsconfig.composite.json" }` between
  the `errors` and `eventual-send` references (alphabetical position).
  File is auto-generated; the diff matches what `yarn build:types:gen`
  produces from the current `packages/daemon/package.json`
  dependencies list.

No other files touched. No source code changed.

## Commit

```
195cc370a chore(daemon): regenerate composite tsconfig for evasive-transform dep
```

Regular append on `fix/endo-make-node-evasive-runtime`; previous head
was `ecc79b3ed`. Pushed at 2026-06-04T03:49Z.

## New head SHA

`195cc370a` on branch `fix/endo-make-node-evasive-runtime` (was
`ecc79b3ed`).

## Local exit codes

- `yarn build:types:check` after the fix: exit 0 ("All composite
  tsconfig files are up to date.")
- `yarn workspace @endo/daemon lint`: exit 0 (0 errors, 390 warnings).

## Judgment calls

- **Scope discipline.** The dispatch authorized edits to
  `packages/daemon/` only. The regenerator (`yarn build:types:gen`)
  could in principle rewrite any package's composite tsconfig if it
  detected drift elsewhere; in this run the diff was confined to
  `packages/daemon/tsconfig.composite.json` (1 file, 3 insertions),
  so the in-scope authorization held.
- **Commit message kind.** Used `chore(daemon):` rather than
  `fix(daemon):` because the change is a pure regeneration of an
  auto-generated file, not a runtime behavior fix. The header in the
  file itself says "DO NOT EDIT! THIS FILE IS AUTO-GENERATED"; calling
  it `chore` accurately reflects that the underlying behavioral fix
  was already in 091a1a, and this commit is the missing build-time
  artifact.
- **Did not touch the 091a1a commit.** The fixer norm is "one atomic
  commit per concern; never amend reviewed commits". Even though
  091a1a is the root cause, it has not been reviewed yet, but
  amending it would still violate the append-only branch contract
  (the dispatch prompt explicitly said "regular append; no force"
  and "Force-pushing." is in the not-authorized list). Separate
  append is the right shape.
- **No top-level PR comment.** No per-action authorization for that
  was forwarded; the dispatch covered the CI fix push only. The
  shepherd or steward will pick up the next stage when the
  re-triggered CI run reports back.

## Next

The push triggered a fresh CI run on PR #418. The shepherd (per
maintainer's "Please continue the shepherd") can verify the lint job
now reaches green; if it does, the PR returns to whatever stage
preceded this lint-fix branch in the gauntlet.

Self-improvement: nothing this time. The CI-log root cause was
clearly stated in the runner annotation ("Run `yarn build:types:gen`
to regenerate composite tsconfig files"), and the regenerator
script's docstring describes the autoflow; both surfaces already
guide a fixer to the right action. The one near-miss worth naming
informally is the `git -c user.email` override on the first commit
attempt: the bot identity is *pinned* by `dispatch-prepare.sh` to
`main.barn5084@fastmail.com`, and overriding it via `-c` on the
commit invocation defeats the pin. The fix here was to drop the
override and let the pinned config win. The pinning mechanism is
already documented in `garden/skills/dispatch-worktree/SKILL.md`
§ Identity pinning, so this is a per-dispatch operator lesson, not
a skill-level gap.
