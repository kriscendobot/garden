---
ts: 2026-05-19T23:11:18Z
kind: result
role: builder
host: endolinbot
short_id: c06931
dispatch_root: dispatches/builder--a8e4d9
repo: endojs/endo-but-for-bots
branch: kriskowal-error-trace
base: llm
pr_number: 301
project: endo-but-for-bots
refs:
  - entries/2026/05/19/225725Z-dispatch-steward-84ed30.md
---

# Builder result: error tracing across CapTP workers (PR #301)

## PR
- https://github.com/endojs/endo-but-for-bots/pull/301 (DRAFT, base `llm`, branch `kriskowal-error-trace`).
- Head SHA: `42ea749babcd81d22c63b79f48d77d07a8bee6f3`.
- Title: `feat(daemon,cli): error tracing aggregator and 'endo trace' verb`.

## What the change adds
End-to-end error tracing for CapTP-mediated failures.
Errors that originate inside a worker today reach the CLI as terse rejections whose only call site is the unserializer; the originating worker, compartment, turn, unredacted stack, and SES-redacted annotation trail are unreachable downstream.
This change adds three load-bearing pieces, designed in `docs/error-tracing-design.md` (commits `d95c0110d` and `84f7d86f3`, the latter revising per #50 review):

1. New `marshalSaveError` / `marshalLoadError` callbacks on `@endo/marshal`'s `makeMarshal`, forwarded through `@endo/captp` so CapTP endpoints can observe error encode/decode keyed by the `errorId` the marshal layer already mints.
2. A daemon-side trace aggregator (`packages/daemon/src/trace-aggregator.js`) that holds records in a per-`(workerId, errorId)` ring buffer (cap by per-worker count and total bytes; eviction on overflow), plus a privileged `EndoHost.traces()` facet exposing `lookup`, `recent`, `stats`, and `clear`.
3. A worker-side push (`packages/daemon/src/worker.js`) that captures the unredacted V8 throw-site stack via a `prepareStackTrace` hook (receives SES's `safeV8SST` attenuation — security-safe), replays the error through SES's `makeCausalConsoleFromLogger` to surface the unredacted tag and `Sent as ...` annotation trail, and `eagerly` pushes a `TraceRecord` to the daemon at every outbound marshal site.

User surface is a new CLI verb (`endo trace <errorId>`, `--recent`, `--stats`) plus an inline trace appended to `endo eval` rejections.
A chat-side `error-trace.js` provides the same enrichment for the chat client.
The wire format is unchanged; enriched data flows out-of-band only through the privileged `traces()` facet (confined guests still see only the marshalled error).

## Affected files (36 files, +3411 / -57 against merge-base)
- `packages/marshal/src/marshal.js`, `src/types.js` — hooks.
- `packages/captp/src/captp.js` — forwarder.
- `packages/daemon/src/trace-aggregator.js` (+ `test/trace-aggregator.test.js`, 248 lines of tests).
- `packages/daemon/src/worker.js` — throw-site capture, causal-console replay, emission-stack capture, push hook.
- `packages/daemon/src/daemon.js`, `host.js`, `interfaces.js`, `daemon-go.js`, `daemon-go-powers.js`, `daemon-node.js`, `daemon-node-powers.js`, `serve-private-path.js`, `connection.js`, `ws-gateway.js` — wiring.
- `packages/daemon/src/networks/network-marshal-save-error.js` (+ `test/network-marshal-save-error.test.js`); `networks/libp2p.js`, `networks/ws-relay.js` — network hook.
- `packages/daemon/test/error-trace.test.js`, `test/ws-relay.test.js` — integration coverage.
- `packages/cli/src/commands/trace.js`, `src/error-trace.js`, `src/endo.js`, `src/client.js`, `src/context.js`, `bin/endo.cjs`, `test/trace.test.js` — CLI verb + inline enrichment.
- `packages/chat/error-trace.js`, `chat-bar-component.js`, `connection.js`, `eval-form.js`, `index.css` — chat client.
- `docs/error-tracing-design.md` — design.

## Branch hygiene applied this dispatch
Two new commits on top of the branch:
- `1ae47282a style: apply prettier formatting to WIP error-tracing files` — fixes `worker.js` `void` precedence and two test-file wrap fixes flagged by `prettier --check`.
- `42ea749ba fix(cli,chat): drop redundant 'console' /* global */ directive` — removes the `/* global console */` declaration in `packages/cli/src/error-trace.js` and `packages/chat/error-trace.js` that triggered `no-redeclare` errors (the project's eslint config already declares `console`).

The literal `WIP error tracing` commit (`f0e393c1d`) is fleshed-out, load-bearing code with extensive docstrings — the `WIP` label is the leftover from finalisation but the code itself is not unfinished.
Per the dispatch's "if it's just a label, leave it" guidance, left as-is.

## Tests (local)
- `yarn lint:prettier` — clean across the repo.
- `packages/daemon yarn lint:eslint` — 0 errors, 64 warnings (all pre-existing `safe-await-separator` and unrelated).
- `packages/cli yarn lint:eslint` — 0 errors, 6 warnings (one new `safe-await-separator` in `src/error-trace.js`, matching the project's pattern elsewhere).
- `packages/chat yarn lint:eslint` — 0 errors, 130 warnings (pre-existing).
- `packages/daemon yarn ava test/trace-aggregator.test.js test/network-marshal-save-error.test.js test/ws-relay.test.js test/error-trace.test.js --timeout=120s` — 34 tests pass (15 aggregator unit + 7 error-trace integration + 5 network-marshal + 27 ws-relay including the new trace-recording test; total reflects ws-relay reporting "27 tests passed").
- `packages/cli yarn test` — 16 tests pass, including all 5 new `trace.test.js` cases (`endo trace --stats`, `--recent`, the `endo eval` inline-trace inline-content and CLI-decode-stack-omission cases, and unknown-id exit code).

## Caveats
- The branch is based on `llm` but its merge-base is 435 commits behind current `origin/llm`.
  GitHub's PR view computes the diff against the merge-base (36 files / +3410 / -57), so the diff stays focused; CI will exercise the merge.
  No rebase done in this dispatch — opening the PR was the priority and the maintainer's stated pattern is "designs based on llm" so this branch's choice of `llm` base is correct.
  A future weaver dispatch can rebase if needed.
- The dispatch entry in the steward's parallel-fan-out (`225725Z-dispatch-steward-84ed30.md`) recorded an error for Bucket C's `DISPATCH_ROOT` field (`fatal: invalid reference: kriskowal-error-trace`); the actual dispatch root (`/home/kris/dispatches/builder--a8e4d9`) exists and the dispatch fired correctly.
- The PR opens DRAFT; per the dispatch instructions, the steward's standing PR-creation-flow scan picks it up on the next cycle for cleaner → judge → fixer-loop → un-draft.

## Self-improvement
**The `/* global console */` trap on new `error-trace.js` files.** Two of the six existing files added in the WIP commit declared `console` in a `/* global ... */` directive; the project's eslint config already lists `console` as a global, triggering `no-redeclare` as an *error* (not a warning). The pattern in the surrounding code is to declare only the non-default globals the file uses (`process`, `setTimeout`, `Buffer`, etc.). A `git grep -E "^/\* global.*\bconsole\b"` from the project root finds zero pre-existing instances, confirming this was a fresh-author trap. Worth a one-line note in the builder's `pre-pr-checklist` skill or the project's CLAUDE.md `## Hardened JavaScript` section: "Do not list `console` (or other already-globals) in `/* global */` directives; the project's eslint config declares them."

Self-improvement: when adding new `.js` source files to a project that uses an eslint config declaring `console`/`process`/etc. as globals, never re-declare those names in a per-file `/* global */` directive — `no-redeclare` is enforced as an error and breaks `yarn lint:eslint`. Verify with `git grep -E "^/\* global.*\bconsole\b"` to confirm the project's existing pattern before adding the directive.
