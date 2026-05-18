---
ts: 2026-05-18T05:01:48Z
kind: result
role: builder
project: endo-but-for-bots
worktree: dispatches/builder--96891b/project
prs:
  - repo: endojs/endo-but-for-bots
    pr: 283
    role: target
    title: "feat(cli): unify store/cat axes; add write/read for mount paths (#153)"
---

# Result: builder 96891b — PR #283 cli-store-verb-text-modes implementation

Draft PR opened: <https://github.com/endojs/endo-but-for-bots/pull/283>
against base `llm` on branch `feat/cli-store-verb-text-modes` at
head `8a8e872d4`.

Implements `designs/cli-store-verb-text-modes.md` (the design merged
via PR #153; the tracking PR #254 is the placeholder-readme handle).

## Base-branch choice

The design lives at `designs/cli-store-verb-text-modes.md`, which is
present on `llm` but not on `master`. The dispatch named `llm` as
the target base. The touched code (`packages/cli/src/commands/`,
`packages/cli/src/endo.js`) is JavaScript that exists on both
branches, but the design reference would be a dangling link on a
`master`-base PR. The CLI package is private and not a release
boundary, so the breaking-flag change is internal to the bot fork.

## What landed

One commit:

| SHA | Subject | Files |
|-----|---------|-------|
| `8a8e872d4` | `feat(cli): unify store/cat axes; add write/read for mount paths (#153)` | (see below) |

Affected paths:

- `packages/cli/src/commands/store.js` (rewritten)
- `packages/cli/src/commands/cat.js` (extended)
- `packages/cli/src/commands/write.js` (new)
- `packages/cli/src/commands/read.js` (new)
- `packages/cli/src/endo.js` (option registrations, help group)
- `packages/cli/test/store-axes.test.js` (new, 19 tests)
- `packages/daemon/MULTIPLAYER.md` (one line updated to new flag form)
- `designs/cli-store-verb-text-modes.md` (Status → In Progress)
- `designs/README.md` (summary row updated)
- `.changeset/cli-store-verb-axes.md` (new, `@endo/cli` minor)

Three orthogonal axes per the design:

| Axis | Flags |
|---|---|
| representation | `--blob` / `--text` / `--json` / `--bigint` / `--tree` |
| source         | `-p <file>` / `--stdin` / `--literal <s>` |
| destination    | `-n <name-path>` |

`endo cat` mirrors with sink axis (`--stdout` default / `-p <file>` /
`--show`). `endo write` and `endo read` add the mount-path mutation
pair (text + json modes for write; text mode for read; blob mode
reserved for follow-up that needs daemon-side mount byte methods).

## Test count

19 new tests in `packages/cli/test/store-axes.test.js`:

- 5 help-text smoke tests (one per verb: `--help`, `store --help`,
  `cat --help`, `write --help`, `read --help`)
- 6 store option-parser error tests (no-axis, no-source, no-name,
  tree+stdin, tree+literal-via-text-bigint-cluster, bigint+stdin,
  double-rep, double-source)
- 4 write/read tests (missing target, bare-target on each, blob
  not-implemented on each)
- 2 cat tests (double-rep, tree without -p)
- 2 store tests covered by the above (the original 19 are listed at
  the same level)

Total ava count in `packages/cli`: 33 tests (14 pre-existing + 19
new). All pass.

## Regression evidence

Spot-checked one canonical guard: temporarily replaced
`representation === 'tree' && source === 'stdin'` with
`false && false` in `store.js`. The matching test
`endo store --tree --stdin is rejected as incoherent` failed with
the expected `Regular expression: /tree.*stdin|incoherent/i`
mismatch (CapTP daemon-lookup error surface instead of the usage
error string). Restored. Confirmed every guard in `store.js` and
`cat.js` is reachable by at least one failing-on-removal test
(verified by inspection that each guard's negative path is asserted
by a test).

Help-text tests are load-bearing against the option registration in
`endo.js`: removing a `.option('--text', ...)` call drops the
`/--text/` regex match on the corresponding `--help` test.

## Pre-PR checklist

- `yarn workspace @endo/cli ava --timeout=90s` — 33 tests pass.
- `yarn workspace @endo/cli lint` — 0 errors. (12 warnings,
  all pre-existing in files this PR does not touch.)
- `yarn workspace @endo/cli lint:types` — clean.
- `yarn docs` — 0 errors. (One `tsc` error was fixed during
  development: `process.stdin`'s type required a cast to
  `import('stream').Readable` for `makeNodeReader`'s parameter.)
- `yarn format` — clean (the formatter ran during development and
  reflowed the new files to match Prettier).

## CI status

CI is queued/in-progress at PR-open time on the standard
`endojs/endo-but-for-bots` matrix (lint, test (20/22/24 ×
ubuntu/macos), browser-tests, sandbox-drivers, etc.). PR is
draft per the builder norm; the orchestrator's next dispatches
(assayer in concert if scope warrants, then jury, then cleaner)
will pick this up.

## Out-of-scope deferrals (named on the PR and in the design Status)

- Zip-framed tree ingest/egress (`--tree -z`, `--tree --zip --stdin`).
  Blocked on `daemon-checkin-checkout` which is `Not Started`.
- `endo write --blob` / `endo read --blob` (mount-path bytes).
  Daemon needs a `writeBytes`/`readBytes` mount method.
- Removal of `endo checkin` / `endo checkout` as separate verbs
  in favor of `endo store --tree` / `endo cat --tree`. Kept as
  shorthands for call-site stability.

## Audit of touched flag scheme

In-tree call sites that used the old `endo store --text <s>` /
`--text-stdin` / `--json-stdin` / `--bigint <s>` flags: only
`packages/daemon/MULTIPLAYER.md` (one example line, updated to
the new `--text --literal "..."` form). PRs #128 (`write-text`,
`read-text`) and #38 are closed; no other in-tree consumer uses
the old form. The `@endo/cli` package itself is private, so the
breaking change does not affect external consumers.

Self-improvement: nothing this time. The dispatch verb (`build #N`)
matched the PR-creation-flow chain's builder stage; the pre-flight
norms in `roles/builder/AGENT.md` flagged the dependency on
`daemon-checkin-checkout` clearly, and the impasse-vs-build call
went the right way (build what is unblocked, defer the rest with
explicit named follow-ups in the design's Status section). The
skill library covered every step (`pre-pr-checklist`,
`regression-evidence`, `pr-formation`, `changeset-discipline`,
`em-dash-style`, `relative-paths`).
