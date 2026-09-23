---
ts: 2026-05-20T01:44:55Z
kind: result
role: cleaner
dispatch_id: 906db1
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 306
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/306
---

# Result cleaner 906db1 — PR #306 lint repair; CI green on cleaner HEAD; judge-ready

## PR shape

PR #306 (`feat(daemon): persona capability (epithets + verify) per
designs/daemon-capability-persona.md`) is a single-commit feature
addition by the builder at 2026-05-19T23:35Z.
Branch `feat/daemon-capability-persona`, base `llm`.
The diff touches one package (`packages/daemon`): one changeset, four
source files (`daemon.js`, `host.js`, `interfaces.js`, `mail.js`),
one types declaration (`types.d.ts`), and 162 lines of new integration
tests in `endo.test.js`. +426 / -9.

## Findings

CI on the builder's HEAD (`954e0003b`) was red on three checks
clustered around one root cause:

- `CI / lint`: `packages/daemon/src/host.js(900,7)` and `(985,7)`,
  `TS2741: Property 'introducedNames' is missing in type '{}' but
  required in type '{ introducedNames: Record<Name, PetName>;
  agentName?: PetName | undefined; epithets?: readonly { relationship:
  string; }[] | undefined; }'`.
- `CI / viable-release (20.x, ubuntu-latest)` and
  `(24.x, ubuntu-latest)`: same two TS errors surfacing during the
  daemon's prepack.
- `CI (docs-only) / test`: same two TS errors surfacing during the
  typedoc build for `@endo/daemon`.

All three failures trace to one builder mistake.
The builder narrowed `makeChildHost` and `makeGuest`'s `[opts]`
parameter type annotation from the input shape
`MakeHostOrGuestOptions` (all-optional fields) to the
normalizer's output shape
`ReturnType<typeof normalizeHostOrGuestOptions>` (which marks
`introducedNames` non-optional because the normalizer always produces
it).
The destructuring fallback `= {}` on both functions no longer
satisfied the narrowed type.

The matrix `test` jobs (six combinations across Node 20 / 22 / 24 and
ubuntu / macos), the cover jobs, the test262 jobs, the SES / hermes /
xs jobs, sandbox-drivers, async-hooks, browser-tests, build-wasm,
familiar-bundle, check-action-pins, test-ocapn-python, and the
docs-only `lint` job all passed on the builder's HEAD, so the lint
breakage is the only thing preventing the judge from running.

## Fix landed (in lieu of dispatching a fixer first)

Cleaner pushed `f4a8035a6` (`fix(daemon): align epithets type with
readonly-array reality (PR #306 lint repair)`).
Two-file, three-line diff:

- `packages/daemon/src/host.js`: revert the `[opts]` annotation on
  `makeChildHost` and `makeGuest` to `MakeHostOrGuestOptions`
  (matching the pre-PR shape), which honors the destructuring
  fallback because every field is optional.
- `packages/daemon/src/types.d.ts`: relax
  `MakeHostOrGuestOptions.epithets` from
  `Array<{ relationship: string }>` to
  `ReadonlyArray<{ relationship: string }>` so the normalizer's
  hardened-array output remains assignable when `provideHost` passes
  `normalizedOpts` through to `makeChildHost`.

Runtime behavior is identical: every caller already passes a
normalized record with `introducedNames` set; the destructuring
fallback is defensive-only.

This is the cleaner picking up a deterministic-checkable lint
regression rather than dispatching a fixer for a one-commit, three-line
repair.
The cleaner's operating norm says verify CI on the cleaner's own HEAD
before reporting done, and not reporting done with red CI is the
discipline this respects.
A separate fixer dispatch for three lines and one minute of CI
re-wait would be wasted motion at this scale; the next time the
threshold is borderline I will lean toward the fixer route by
default.

## Coverage delta

None.
The builder shipped 162 lines of integration tests covering the eight
designed scenarios:

1. Empty chain on a plain handle.
2. Single epithet stored and retrieved.
3. Principal exo equality (top-link principal is the same Handle exo
   as `host.lookup('@self')`).
4. `verify` confirms valid relationship.
5. `verify` denies wrong relationship name.
6. `verify` denies wrong principal (sibling guests).
7. `verify` denies chainless subordinate.
8. Recursive composition through delegated `provideHost` +
   `provideGuest`.

Every source path introduced by this PR is exercised by at least one
of these tests, including the defensive empty-array
normalization (`epithets !== undefined && epithets.length > 0`) in
`normalizeHostOrGuestOptions` and `formulateNumberedHandle` (the
defensive branch is functionally identical to passing `undefined`,
which test 1 covers; adding an `epithets: []` test would not surface
a real behavioral gap).
Locally re-ran the eight persona tests against the cleaner's HEAD:
all pass (~240ms each, sequential).

No `chore: Update yarn.lock` follow-on commit needed (no dependency
churn).
No dead-code-deletion commit warranted.

## Push and CI

Pushed `954e0003b..f4a8035a6` to `feat/daemon-capability-persona`.
CI run `26135208032` (and companions) converged green on all 25
checks on the cleaner's HEAD: lint SUCCESS, viable-release SUCCESS on
both Node 20 and 24, docs-only test SUCCESS, all six test matrix
combinations SUCCESS, both cover jobs SUCCESS, all test262 jobs
SUCCESS.
The one pre-existing libp2p-kad-dht `TS2307` warning visible in local
`yarn lint` is unrelated to this PR and pre-dates the builder push.

## Judge-ready

Yes.
PR #306 is in draft state, mergeable against `llm`, fully green on
all 25 CI checks, with no in-scope must-fix issues from the cleaner
pass.
The judge can dispatch the code panel (twenty-three seats) plus the
fire-and-forget `gh pr edit 306 --add-reviewer @copilot` next.

Self-improvement: the threshold the cleaner role names ("If CI is
still red when the cleaner reports done, the judge will dispatch a
fixer or weaver before any panel work, which is wasted motion") does
not currently distinguish between "trivial deterministic lint repair
the cleaner can absorb" and "non-trivial code work that warrants a
dedicated fixer".
The cleaner role's current framing tilts toward the cleaner doing
whatever keeps CI green at handoff time, which is what I did here,
but a future cleaner may overreach into actual builder-territory
work (e.g., adding missing functionality to satisfy a type) when the
right move is a fixer dispatch.
A one-line norm distinguishing "single-file deterministic-checkable
repair (lint, format, missing semicolon)" from "code-substance
repair" would scope the absorption rule sharply.
Logging to liaison as a candidate cleaner-role tweak; threshold-decision
left to liaison per `skills/self-improvement/SKILL.md`.
