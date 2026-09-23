---
kind: message
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-28T07:48:54Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/869

# Dependabotany ledger: endojs/endo-but-for-bots -- PR 869 MERGE-NOW, held at the approval gate

Botany review of <https://github.com/endojs/endo-but-for-bots/pull/869>
(`chore: bump happy-dom from 15.11.7 to 20.11.0`, base `llm`, head
`3b4c181446e838daf5d66cfd448a569a37f98139`), run by job
`endojs-endo-but-for-bots-pr869-dependabot`, posted automatically by the
dependabot-PR watcher. Appends to the `endojs/endo-but-for-bots` dependabotany
ledger. Recover the cumulative posture with:

```sh
grep -rl '^project: endo-but-for-bots$' journal/entries/ | xargs grep -l '^# Dependabotany'
```

## Verdict

**MERGE-NOW, execution attempted and correctly blocked: no maintainer approval.**

This is the successor of PR 562, which an earlier job closed as superseded. The
supersession check at step 1 confirmed 869 is the live happy-dom pull request and
the only open one, so it got the full review.

This is **not** an embargoed row: the verdict is terminal-on-approval, so it adds
no maturity date, no precise one-shot recheck, and no daily-heartbeat obligation.
It is an **open action item for the maintainer**, not for a future recheck tick.

## Per-PR posture

| PR | Headline upgrade | Verdict | Maturity date | State | Blocking |
|---|---|---|---|---|---|
| [869](https://github.com/endojs/endo-but-for-bots/pull/869) | `happy-dom` 15.11.7 to 20.11.0 (devDependency of chat, markmdown, space-file-explorer) | MERGE-NOW (vulnerability repair) | n/a, published 2026-07-18 so the 7-day window was already met independently | OPEN, mergeable, CI green 22/22 | `reviewDecision=none`; the conductor spine refused at `pr-maintainer-approval-gh.sh` |

## Why MERGE-NOW rather than embargo

The version **in the tree** (15.11.7) is affected by three advisories, all fixed
at or below the proposed 20.11.0:

- GHSA-37j7-fg3j-429f / CVE-2025-61927, **CRITICAL**, VM context escape to remote
  code execution, range `>=0 <20.0.0`, fixed 20.0.0.
- GHSA-6q6h-j7hj-3r64 / CVE-2026-33943, HIGH, unsanitized export names
  interpolated as executable code, range `>=15.10.0 <20.8.8`, fixed 20.8.8.
- GHSA-w4gp-fjgq-3q4g / CVE-2026-34226, HIGH, fetch credentials send page-origin
  cookies to the target origin, range `>=0 <20.8.9`, fixed 20.8.9.

OSV returns no advisory for 20.11.0. Scope stated honestly: happy-dom is a
devDependency, so exposure is test-time and this is not a live production remote
code execution.

## Regression evidence (executed, per skills/regression-evidence)

Ran the advisory's own reproducer against both versions in isolated
`npm i --ignore-scripts` installs, payload reduced to reading `process.pid`:

```
happy-dom 15.11.7   RESULT: ESCAPED pid=1264947
happy-dom 20.11.0   RESULT: (script never ran -- JS evaluation disabled)
```

The escape reproduces on the in-tree version and is closed on the proposed one.
The mechanism is the documented 20.0.0 fix: **JavaScript evaluation is off by
default in 20.x**. That is also a behavior change worth carrying forward: a test
relying on happy-dom executing an inline `<script>` would now get a silent no-op.
Nothing in the repo depends on it today.

## Full lockfile transitive set

happy-dom's dependency list is rewritten by this major. Every moved version, with
npm publish date and advisory status (all clean):

| Package | Version | Published | Note |
|---|---|---|---|
| `happy-dom` | 15.11.7 -> 20.11.0 | 2026-07-18 | headline; 10 days mature |
| `ws` | 8.21.1 (new) | 2026-07-14 | 20.x adds a WebSocket implementation; freshest item at 14 days |
| `entities` | 7.0.1 (new major; 4.5.0 stays for other consumers) | 2026-01-21 | BSD-2-Clause |
| `buffer-image-size` | 0.6.4 (**new package**) | 2018-03-01 | dormant since 2018, single maintainer `jccr`; read in full |
| `@types/node` | 26.1.1 (new range `>=20.0.0`) | 2026-07-08 | types only |
| `undici-types` | 8.3.0 (new, via `@types/node`) | 2026-05-14 | types only |
| `@types/whatwg-mimetype` | 3.0.2 (**new package**) | 2023-11-07 | types only |
| `webidl-conversions` | 7.0.0 **removed** | n/a | no longer needed |

`@types/ws` was already present at 8.18.1; happy-dom only joins as a consumer.
Nothing is less than 24 hours old. Licenses unchanged in kind (MIT, `entities`
BSD-2-Clause).

`buffer-image-size` was the one item warranting a full read, being new, dormant
since 2018, and single-maintainer: 500 lines total of magic-byte header parsing to
recover image dimensions from a buffer, with no filesystem, network,
`child_process`, `eval`, install hook, or `bin`. The lockfile pins the exact
resolution with a checksum, so a later malicious publish to that dormant package
would not be silently picked up.

## Source read

- No `preinstall` / `install` / `postinstall` / `prepare` and no `bin` on happy-dom
  or any of the six new or moved transitive packages. (`entities` has
  `prepublishOnly`, publish-time only.)
- Installed with scripts disabled: `YARN_ENABLE_SCRIPTS=false yarn install
  --immutable --mode=skip-build`, clean, which also confirms the lockfile agrees
  with the three `package.json` edits.
- Risky-surface scan of shipped `lib/` found one hit: `SyncFetch.js` imports
  `child_process` and calls `execFileSync(process.argv[0], ['-e', script])`. This
  is **pre-existing**: 15.11.7 has the identical import and design (happy-dom's
  synchronous-fetch mechanism). Not introduced by this upgrade. No new fs writes,
  network calls, `eval`, `new Function`, `process.env` reads, or telemetry.
- 20.11.0 is present in the registry `versions` map (not unpublished or
  yanked-then-republished), published by GitHub Actions, `engines: node >=20.0.0`
  (CI runs 22.x/24.x; devDependency, so it does not raise the published floor).
- `yarn npm audit` reports nothing against this moved set; its findings
  (`@octokit/request`, `axios`) are pre-existing and unrelated.

## CI and local verification

22 of 22 check-runs succeeded at head `3b4c181446e838daf5d66cfd448a569a37f98139`.
Cross-checked at the check-run level, and the legacy combined-status endpoint again
returned the vacuous `state=pending total_count=0` that the role file warns about,
so the rollup alone would have misread this as a stall.

Because this is a five-major jump, the three consumer suites were also run locally
against the new version, using the known `node "$A/entrypoints/cli.js"` workaround
for the sandbox's block on `node_modules/.bin` shims:

```
packages/markmdown             15 tests passed
packages/chat                 800 tests passed
packages/space-file-explorer   80 tests passed
```

895 tests, all passing.

## Execution and what remains

Drove the disposition through `scripts/jobs/gardening/ci-wait-merge.sh
endojs/endo-but-for-bots 869 --merge`. It independently agreed CI was green
(`rollup-terminal ... total=22 failed=0 -> CI GREEN`) and then refused at the
maintainer-approval gate:

```
merge blocked: no maintainer approval (reviewDecision=none)
```

The pull request has no review at all. Not merged, and not merged over the gate.
**One approval from a maintainer is the entire remaining distance.**

Verdict comment:
<https://github.com/endojs/endo-but-for-bots/pull/869#issuecomment-5101396827>
Maintainer inbox alert: `20260728T074750Z-a00ff0`.
