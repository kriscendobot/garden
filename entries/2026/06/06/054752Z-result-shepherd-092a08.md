---
ts: 2026-06-06T05:47:52Z
kind: result
role: shepherd
host: endolinbot
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/shepherd--092a08
to: liaison
prs:
  - repo: endojs/endo-but-for-bots
    pr: 426
    role: target
refs:
  - entries/2026/06/06/051500Z-dispatch-builder-d94d05.md
  - entries/2026/06/06/052513Z-result-builder-101dc2.md
  - https://github.com/endojs/endo-but-for-bots/pull/426
  - https://github.com/endojs/endo-but-for-bots/pull/426#issuecomment-4637577349
---

# result: shepherd 092a08 — PR #426 CI converged with 5 failures, single root cause; next: liaison

CI on PR #426 (head `61804678`) settled at 25 checks complete: 20 SUCCESS, 5 FAILURE. All 5 failures share one root cause: missing `eslint-plugin-unicorn` at the workspace root. This is precisely the builder's flagged out-of-scope drift #2; per the dispatch brief's "do NOT fix; escalate to liaison if they surface as CI failures" instruction, escalation rather than fix.

## Rollup at terminal

- `browser-tests`: SUCCESS
- `build`: SUCCESS
- `build-wasm`: SUCCESS
- `check-action-pins`: SUCCESS
- `cover (22.x, ubuntu-latest)`: SUCCESS
- `cover (24.x, ubuntu-latest)`: SUCCESS
- `familiar-bundle`: SUCCESS
- `lint` (first instance): FAILURE
- `lint` (second instance): SUCCESS
- `sandbox-drivers`: SUCCESS
- `test`: SUCCESS
- `test (22.x, macos-15)`: FAILURE
- `test (22.x, ubuntu-latest)`: FAILURE
- `test (24.x, macos-15)`: FAILURE
- `test (24.x, ubuntu-latest)`: FAILURE
- `test-async-hooks (22, ubuntu-latest)`: SUCCESS
- `test-hermes`: SUCCESS
- `test-ocapn-guile-interop`: SUCCESS
- `test-ocapn-python`: SUCCESS
- `test-xs`: SUCCESS
- `test262 (22.x, ubuntu-latest)`: SUCCESS
- `test262 (24.x, ubuntu-latest)`: SUCCESS
- `viable-release (22.x, ubuntu-latest)`: SUCCESS
- `viable-release (24.x, ubuntu-latest)`: SUCCESS
- `zizmor`: SUCCESS

Two checks share the name `lint` (one passed, one failed). The failing instance is run `27053718776` job `79853889057`.

## Per-job classification

| Job | Run / job ID | Classification | Notes |
| - | - | - | - |
| `lint` (failing one) | 27053718776 / 79853889057 | builder-flagged out-of-scope drift | `ESLint couldn't find the plugin "eslint-plugin-unicorn"` from `packages/9p-server/package.json » plugin:@endo/internal` |
| `test (22.x, ubuntu-latest)` | 27053718776 / 79853889112 | same root cause as above | `Cannot find module 'eslint-plugin-unicorn'` at `packages/eslint-plugin/test/internal-numeric-separators.test.js:22:17` |
| `test (22.x, macos-15)` | 27053718776 / 79853889104 | same | same signature |
| `test (24.x, ubuntu-latest)` | 27053718776 / 79853889097 | same | same signature |
| `test (24.x, macos-15)` | 27053718776 / 79853889098 | same | same signature |

## Root cause

The merge brought in master's new dependency-shape: `packages/eslint-plugin/package.json` declares `eslint-plugin-unicorn ^56.0.1` as a peerDep, and `packages/eslint-plugin/lib/configs/internal.js` wires `unicorn/numeric-separators-style` into the shared internal config. But the root `package.json` does not provide `eslint-plugin-unicorn`. Yarn warns at install time:

```
YN0002: root-workspace-0b6124@workspace:. doesn't provide eslint-plugin-unicorn (pde1a41),
        requested by @endo/eslint-plugin.
```

The lint job dies when ESLint resolves the `@endo/internal` config and can't find the plugin. The four `test` matrix jobs all die at the `@endo/eslint-plugin#test` turbo step (an `internal-numeric-separators.test.js` that `require`s `eslint-plugin-unicorn` directly); turbo cascades that abort and the rest of the pipeline never runs.

This is precisely builder dispatch `d94d05`/`101dc2`'s out-of-scope drift #2 (`entries/2026/06/06/052513Z-result-builder-101dc2.md` § *Out-of-scope drift surfaced for follow-on*): "If the rule actually loads in this lockfile, a follow-on dispatch can add `eslint-plugin-unicorn` to the root devDependencies; until then, the precedent stands." It loads.

## What about the other builder-flagged drift?

The first drift (`makeClient` / `registerNetlayer` API divergence between bot llm and upstream master, manifesting in `packages/ocapn/test/netlayer-tcp-syrup.test.js`) is *masked* by this CI run. The `test` matrix jobs bail at the `@endo/eslint-plugin#test` step before the test pipeline reaches `packages/ocapn`. If the unicorn gap is closed, the netlayer drift is the next thing CI will surface, exactly as the builder predicted (`...the conductor's auto-CI on PR #426 will surface the failure as evidence.`).

## Why escalate rather than CI-fix

The dispatch brief explicitly said: *"Two out-of-scope drifts the builder flagged (do NOT fix; escalate to liaison if they surface as CI failures)."* The unicorn drift is one of those two. The remedy (`yarn add -D eslint-plugin-unicorn@^56.0.1` at the root + lockfile sync) is small and tractable but crosses the boundary the maintainer asked be kept clean for the sync PR. Escalation rather than fix is the right move.

If the maintainer wants the drift folded under the sync banner, a follow-on dispatch (builder or fixer) can land:

```sh
corepack yarn add -D 'eslint-plugin-unicorn@^56.0.1'
git add package.json yarn.lock
git commit -m 'fix: add eslint-plugin-unicorn devDep for new @endo/eslint-plugin peerDep'
git push origin HEAD:merge/actual-master-into-llm-20260606
```

After which CI will surface the netlayer drift (drift #1) for separate triage. Both drifts together appear to be the standing list of "things the bot llm has to catch up on after each master sync"; the `journal/projects/endo-but-for-bots/master-into-llm-sync.md` topic file the builder's self-improvement suggested is the right durable home for them.

## Classification

`next: liaison`. The shepherd brief is the directive: builder-flagged out-of-scope drifts that surface as CI failures escalate to liaison rather than fixer (no fixer scope; this is a maintainer-decision about scope discipline, not a code fix the fixer can derive from the failure inventory).

## Authorizations exercised

- Posted top-level summary comment on PR #426: <https://github.com/endojs/endo-but-for-bots/pull/426#issuecomment-4637577349>. Covered by the `endo-but-for-bots` standing broad-comment authorization (`journal/projects/endo-but-for-bots/README.md` § *Standing authorizations*) and explicitly forwarded in the dispatch.
- No push to `merge/actual-master-into-llm-20260606`. No `gh run rerun`.

## Self-improvement

Self-improvement: nothing this time. The brief's two-drift contract played as written: the rollup landed quickly (all 25 checks already terminal at first pull), the failures clustered cleanly into the unicorn root cause, and the brief's escalation-not-fix instruction was unambiguous. The masked-drift observation (drift #1 hidden behind drift #2's earlier abort) is worth noting in the shepherd's *Notes from the field* on `skills/pr-ci-watch/SKILL.md` if it recurs, but a single instance is not yet skill-worthy.
