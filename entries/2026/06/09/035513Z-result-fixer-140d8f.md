---
ts: 2026-06-09T03:55:13Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/fixer--140d8f
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: target
  - repo: endojs/endo
    pr: 3232
    role: upstream-source
refs:
  - entries/2026/06/09/034000Z-dispatch-fixer-140d8f.md
  - https://github.com/endojs/endo-but-for-bots/pull/75
  - https://github.com/endojs/endo-but-for-bots/pull/75/commits/e627f7b13be2f048ecc35d1a8f7f0826ddf0c917
  - https://github.com/endojs/endo-but-for-bots/pull/75#issuecomment-4655929663
  - https://github.com/endojs/endo-but-for-bots/pull/75#issuecomment-4655930878
---

# result: fixer 140d8f — carried gibson042 final review on endo#3232 into single append commit on PR #75

## Branch tips

- Pre: `1da07c3587d5384551a60546a8c78fb34b1dae7c` (`1da07c358`)
- Post: `e627f7b13be2f048ecc35d1a8f7f0826ddf0c917` (`e627f7b13`)
- Single commit: `e627f7b13` — `fix(random,chacha12): address gibson042 final review on endo#3232`

## Files changed (mapped to upstream comment ids)

| File | Upstream comment(s) | Change |
| --- | --- | --- |
| `.changeset/endo-chacha12.md` | 3369687293 | Reframed keystream-methods description; cited pure-rand v8 `RandomGenerator` interface and fast-check v4 `randomType` parameter with anchored links. |
| `packages/chacha12-fast-check-test/test/_random-type.js` | 3369692155, 3369696203, 3369697997 | Removed two stale references to nonexistent `packages/random-fast-check/`, `designs/random-pure-rand-v8-interface.md`, and `@endo/random-fast-check`. Consistency rewrite `pure-rand v8` → `pure-rand@8`. |
| `packages/chacha12-fast-check-test/test/fast-check.test.js` | 3377415818, 3377468377 | Tightened non-trivial assertion `new Set(runA).size > 1` → `runA.length > 1`. Restructured `findCounterexample` to track `distinctResults` and assert both true/false branches were produced. |
| `packages/chacha12/src/chacha12.js` | 3377480793 | Header-comment consistency rewrite `pure-rand v8` → `pure-rand@8`. |
| `packages/chacha12-fast-check-test/package.json` | mirror PR #75 thread 3223667088 | Collapsed `exports` map (was `{ "./package.json": "./package.json" }`) to `{}`; `main` and `module` were already absent. |
| `packages/random/README.md` | (consistent cleanup) | Replaced the same stale `@endo/random-fast-check` sibling-package callout with a pointer to the actual `@endo/chacha12-fast-check-test` integration package. (Not in gibson042's enumerated seven, but the same broken reference; included because the upstream pattern is "remove references to artifacts that don't exist".) |

## Investigation results

- `find packages -type d -name 'random-fast-check'`: no match. The package was never created.
- `ls designs/ | grep -i pure-rand`: no match. The design doc was never created either.
- The actual integration-test package is `packages/chacha12-fast-check-test/`, which exists and is what every reference should point at.

## Mirror sweep findings

Enumerated all `isResolved=false isOutdated=false` review threads on PR #75 (10 unresolved, not-outdated threads):

| Thread | Status | Action |
| --- | --- | --- |
| `3176097827` / `3270527743` `packages/chacha12/index.js` | bot reply already in place; awaiting kriskowal | none |
| `3177655399` `packages/hex/test/decode.bench.js:19` | "Still interested in bench." | not folded; benchmark scope |
| `3177670597` `packages/random/seeds.js:1` | approval (no ask) | none |
| `3178350512` / `3223690950` `packages/chacha12/src/chacha12.js:254` | "Remind me the outcome" | not folded; benchmark scope |
| `3223667088` `packages/chacha12-fast-check-test/package.json:27` | "Should be present and empty" | **folded** (`exports: {}`); also resolves `test-package-no-main` probe |
| `3223702262` `packages/chacha12/README.md:1` | "Please reread the style guide" | not folded; vague rewrite ask |
| `3223744548` `packages/random/types.d.ts:1` | "Please check naming conventions" | not folded; survey ask |
| `3270531154` `packages/chacha12/src/chacha12.js:151` | bot reply already in place; awaiting kriskowal | none |
| `3270538201` `packages/random/src/uint.js:34` | bot reply asks for clarification; awaiting kriskowal's pick from three readings | none |

## Local checks

- `pre-push-gates.sh --summary`: `result: gate passed.` after `yarn format` and `yarn lint --fix` silently re-staged 6 paths. All probes pass.
- `corepack yarn build`: green (SES vanilla 506745 bytes / minified 231959 / hermes 506778; Done in 4s).
- `corepack yarn lint` (workspaces-wide): `All matched files use Prettier code style!`; eslint silent (no errors).
- `corepack yarn workspaces foreach -A --topological-dev --include '@endo/chacha12*' --include '@endo/random' run lint`: `Done in 8s 44ms` (green).

## Upstream-thread reply tracking (for future boatman/upstream-reply dispatch)

Per dispatch scope, replies were **not** posted on endojs/endo#3232 threads. The seven upstream threads need a brief acknowledgment (each citing the addressing SHA on the mirror, then later the upstream cherry-pick) when the upstream-reply leg runs:

- `3369687293`, `3369692155`, `3369696203`, `3369697997`, `3377415818`, `3377468377`, `3377480793` — all on endojs/endo#3232.

## Comments posted

- Top-level summary on PR #75: <https://github.com/endojs/endo-but-for-bots/pull/75#issuecomment-4655929663>
- Reply to kriskowal directive (issue comment `4655836014`) — posted as a new top-level comment since GitHub does not support direct replies to issue comments; the body links the directive's source and the addressing SHA: <https://github.com/endojs/endo-but-for-bots/pull/75#issuecomment-4655930878>

## Authorizations honored

- Push to `kriskowal-random-chacha12`: implicit in fixer dispatch.
- No reply on endojs/endo upstream threads (explicit out-of-scope per brief).
- Top-level summary on PR #75: standing authorization.
- Reply to issue comment `4655836014` on PR #75: standing authorization.
- **Not** re-requested review (per "Out of scope": "Do NOT re-request review. The directive's chain ends with shepherd").

## Definition of done

- All seven gibson042 inline suggestions addressed in one commit.
- Mirror sweep performed; one ask folded in (test-package `exports`); rest documented with rationale.
- Top-level PR summary lists every thread by id with SHA.
- Reply to kriskowal directive cites SHA and links the summary.
- Local checks green (build + lint + pre-push-gates).
- CI matrix convergence handed off to shepherd (per brief).

Self-improvement: nothing this time. The brief was tight; the pre-push-gates probe `test-package-no-main` flagging the same `exports` shape that mirror thread `3223667088` had been asking about for months is the kind of structural feedback the gate was designed to make routine, and it worked exactly as designed (the gate's complaint surfaced the mirror thread's ask in the same dispatch).
