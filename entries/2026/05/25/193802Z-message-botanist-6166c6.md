---
ts: 2026-05-25T19:38:02Z
kind: message
role: botanist
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
refs:
  - entries/2026/05/13/000050Z-message-steward-e08492.md
  - entries/2026/05/20/011222Z-message-botanist-310e99.md
---

# Dependabotany ledger row: endojs/endo-but-for-bots#362

Appended row for the `endojs/endo-but-for-bots` dependabotany ledger
seeded at `entries/2026/05/13/000050Z-message-steward-e08492.md`. Future
botanist dispatches against this repo append their rows under the same
`project: endo-but-for-bots` tag; the steward's per-cycle scan greps

```sh
grep -rl '^project: endo-but-for-bots$' journal/entries/ | xargs grep -l '^# Dependabotany'
```

to recover the cumulative posture and re-dispatch on maturity dates.

## Per-PR posture

| PR | Headline upgrade | Verdict | Maturity date | State | Notes |
|---|---|---|---|---|---|
| [362](https://github.com/endojs/endo-but-for-bots/pull/362) | grouped `all-minor-patch` x 15 (ws 8.20.0 to 8.21.0, ink 7.0.2 to 7.0.4, @anthropic-ai/sdk 0.95.1 to 0.96.0, @typescript-eslint/* 8.59.2 to 8.59.3, @libp2p/{autonat,crypto,dcutr} minor, rollup 4.60.3 to 4.60.4, turbo 2.9.10 to 2.9.14, @playwright/test 1.59.1 to 1.60.0, yaml 2.8.4 to 2.9.0, @types/node 25.6.2 to 25.8.0) | EMBARGO-2026-05-31 | 2026-05-31 | OPEN | Pre-flight clean: diff touches only root `package.json`, `packages/eslint-plugin/package.json`, `packages/lal/package.json`, and `yarn.lock` (no source files). Install with `enableScripts: false` (project default in `.yarnrc.yml`) succeeds; lockfile contains 56 version changes across the 15 headline packages and their pinned-exact transitive set (rollup's 26 platform-specific native binaries, turbo's 6 binaries, the typescript-eslint internal monorepo, libp2p's interface-internal/logger/peer-collections/peer-id/utils transitives, undici-types 6.19.x/7.19.x consolidated to 7.24.6 under @types/node). Only one upgrade is vuln-repairing: ws 8.20.0 to 8.21.0 patches GHSA-96hv-2xvq-fx4p / CVE-2026-48779 (high, remote memory-exhaustion DoS from tiny WebSocket fragments and data chunks). The project consumes `ws` in four packages (`relay-server`, `daemon`, `ocapn-noise`, `ocapn`) that accept remote peers, so the project is exposed; under the "MERGE-NOW closes a CVE the project is exposed to" rule, the ws bump alone would justify MERGE-NOW. But the bump is grouped with 14 non-vuln-repairing upgrades whose maturity is mixed: ink@7.0.4 published 2026-05-24 (today, 0 days mature), libp2p/autonat@3.0.20 and libp2p/dcutr@3.0.20 published 2026-05-16 (8 days mature, just past the floor), ws@8.21.0 itself published 2026-05-22 (2 days mature). The standing default is to embargo non-vuln-repairing upgrades for one week from upstream publish date; the bundled CVE-fix does not pull the whole grouped PR through the supply-chain wait when the freshest member (ink) was published this morning and the CVE class is DoS-only (not RCE / data-exfil). Embargo until 2026-05-31, which is one week from ink's publish date and two days past ws's own 7-day floor. CI status as of this dispatch (commit `c0a38cde9`, run `26371350951`): 10 FAILURE checks (lint, test (20/22/24 x ubuntu/macos), cover (20/24 ubuntu)), 15 SUCCESS, mergeable; shepherd dispatched in parallel by the steward to drive CI to green. The shepherd's work is independent of this embargo: when 2026-05-31 arrives, the steward re-dispatches; if CI is green and the ws GHSA still names 8.21.0 as the patched version and no headline package has been yanked or republished in the interim, the verdict converts to MERGE-NOW and the conductor takes over. If the maintainer judges the ws CVE urgent enough to fast-track ahead of the embargo, the override is theirs to issue (the bot defers per the standing default). ([verdict comment](https://github.com/endojs/endo-but-for-bots/pull/362#issuecomment-4536766907)) |

## Botanist self-notes for this PR

Carried over from prior endo-but-for-bots and endo dependabotany engagements; reaffirmed by this engagement:

- **Grouped Dependabot PRs are a single verdict, not a per-package vote.** Dependabot configures `groups:` in `.github/dependabot.yml`; when a CVE-fix lands in the same group as non-vuln-repairing upgrades, the whole PR moves together. The botanist embargoes the group at the freshest publish date, not at the CVE-fix's date. The maintainer's override is to ungroup or to merge-now anyway; the botanist's default is the wait.
- **DoS-class CVEs do not always override the embargo on a feature branch.** GHSA-96hv-2xvq-fx4p / CVE-2026-48779 is high severity but limited to remote memory exhaustion (no RCE, no data exfiltration, no privilege escalation). The PR base is `llm` (a feature branch), not `master`; the merge does not reach production immediately, and the embargo cost is one week. An RCE-class CVE on a master-bound PR would more plausibly justify overriding the embargo.
- **`enableScripts: false` is the project-wide default.** Same finding as the prior endo-but-for-bots ledger; `.yarnrc.yml` sets `enableScripts: false` globally. `npx corepack yarn install --immutable` in the worktree was already passive; no per-worktree override needed. Confirmed by the `Link step` output flagging 11 packages with disabled build scripts.
- **`npm view <pkg> time --json` gives exact publish dates per version.** Faster than reading the changelog or release page. Pipe to `python3` with `d.get('<ver>')` to extract a single version's date. The freshest package in a grouped PR drives the embargo floor.
- **`gh api repos/<owner>/<repo>/security-advisories` lists every GHSA the upstream package author has published.** This is the authoritative source for "is this version's bump a CVE-fix?" Faster and more authoritative than reading release notes; the release notes for ws@8.21.0 said "Fixed a remote memory exhaustion DoS vulnerability" but did not name the GHSA / CVE, which the security-advisories API gave directly.
- **Check the consumed package's call sites before declaring exposure.** GHSA-96hv-2xvq-fx4p is a server-side DoS in ws; `grep "\"ws\":" packages/*/package.json` showed four consumers in network-facing packages. If `ws` had only been a dev-tool dependency (e.g. a fixture for a test harness), the exposure rule would not have fired.

## Scheduled engagements

| Date | Action | Trigger |
|---|---|---|
| 2026-05-31 | Re-dispatch the botanist on `endojs/endo-but-for-bots#362` | EMBARGO matures; verify no headline package yanked/republished, ws@8.21.0 still named in GHSA-96hv-2xvq-fx4p patch set, CI is green (shepherd should have driven it green by then). Convert to MERGE-NOW or REJECT based on findings. |
