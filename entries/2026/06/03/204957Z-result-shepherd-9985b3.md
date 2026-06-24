---
ts: 2026-06-03T20:49:57Z
kind: result
role: shepherd
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/shepherd--9985b3
prs:
  - repo: endojs/endo-but-for-bots
    pr: 394
    role: target
refs:
  - entries/2026/06/03/204421Z-dispatch-liaison-9985b3.md
  - https://github.com/endojs/endo-but-for-bots/pull/394#issuecomment-4616585224
next: weaver
---

# result: shepherd — #394 CI diagnosis (Pray shepherd)

Verdict: all 10 failures on `a57332f69` share one root cause:
**stale base**. The gateway-package phase chain (#388 phase-2,
#389 phase-3, #392 phase-4, #393 phase-5, #394 phase-6) has not
been cascade-rebased after the steward's earlier weaver `59079d`
rebased the foundation #343 onto `llm-720a396`. No in-PR
source change is appropriate; the source files that need
updating already exist correctly on the rebased base.

## Ancestry probe (run in project worktree)

- `phase-2 contains origin/design/gateway-package (#343 head)`: NO.
- `phase-3 contains phase-2`: YES.
- `phase-4 contains phase-3`: NO.
- `phase-5 contains phase-4`: YES.
- `phase-6 contains phase-5`: YES.
- `phase-6 contains origin/llm-720a396`: NO.
- `phase-6 contains ba26f4cdb` (the upstream xs/v8 esvu fix
  in the rebased #343): NO.
- `origin/design/gateway-package contains ba26f4cdb`: YES.

Common ancestor of phase-6 and `origin/llm-720a396` is
`b1c3f4dca` (`fix(ci): address zizmor findings ...`) — the
pre-rebase #343 root. The rebased #343 (`origin/design/gateway-package`
head `23bc11a9e`) carries 17+ commits not present in the
phase-2..phase-6 chain, including the `makeClient -> makeOcapn`
rename and its matching test update.

## Per-failure classification

All ten failures resolve via cascade-rebase. Job URLs are under
`actions/runs/26902247839`.

- **lint** (job 79357463441): `##[error] 7:10 error makeClient
  not found in '../src/client/index.js' import/named` in
  `packages/ocapn/test/netlayer-tcp-syrup.test.js`. Rebased base
  renamed `makeClient` to `makeOcapn` and updated the test
  file (`origin/design/gateway-package:packages/ocapn/test/netlayer-tcp-syrup.test.js`
  now imports `makeOcapn`); phase-6 still carries the stale
  `import { makeClient }` line. **Cause: stale base.**
- **test (20.x / 22.x / 24.x; ubuntu + macos)** (jobs 79357463485,
  79357463511, 79357463476, 79357463568, 79357463450, 79357463496):
  `✘ test/netlayer-tcp-syrup.test.js exited with a non-zero exit
  code: 1`. Same import-load failure as lint. **Cause: stale
  base (same root cause).**
- **cover (20.x / 24.x ubuntu)** (jobs 79357463455, 79357463481):
  downstream of the same test load failure. **Cause: stale base
  (same root cause).**
- **test-xs** (job 79357463530): `Error installing XS or V8:
  esvu ✖ Some engines were not installed`. Upstream master
  fixed this in `ba26f4cdb fix(benchmark): install xs/v8 via
  direct download instead of esvu (#3294)`; phase-6 predates
  the rebase that pulled this in. **Cause: stale base (same
  root cause).**

## Action taken

- No source change (this is weaver work).
- No CI re-enqueue (the failures are real and reproducible from
  the diagnosis; not flakes).
- Posted classification comment on #394:
  https://github.com/endojs/endo-but-for-bots/pull/394#issuecomment-4616585224

## Escalation

`next: weaver` — cascade-rebase the gateway-package phase chain
#388 -> #389 -> #392 -> #393 -> #394 onto the rebased #343
(`origin/design/gateway-package` head `23bc11a9e`). Per memory
`feedback_shepherd_to_fixer_auto_chain.md` extended to weaver,
this verdict is the authorization for the steward's auto-pickup
chain to dispatch the weaver cascade without re-asking the
maintainer.

Self-improvement: nothing this time. The dispatch brief's
stale-base-induced hypothesis matched the evidence directly;
the verdict-to-comment-to-result loop was straightforward.
