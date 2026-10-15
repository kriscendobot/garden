---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# minion.town: install Node root-owned, then pin the observer's interpreter

Repo: kriscendobot/minion.town. Follow-up from https://github.com/kriscendobot/minion.town/pull/171 (panel round 9, breaker #1 / wire-watcher #5).

`deploy/aws/scripts/deploy-app.sh` (and `deploy-endo-daemon.sh` and `deploy-npm-registry.sh`) unpack the official Node tarball into `/usr/local` with `sudo tar -C /usr/local --strip-components=1 -xf`. As root, tar keeps the archive's owner (`iojs`), so `/usr/local/bin/node` and `/usr/local/bin` are probably not `root:root` on the box. Root runs that interpreter for the harness observer and for other services.

Task:
1. Add `--no-same-owner` to all three install sites. Also chown the existing install to `root:root` idempotently on every deploy, not only on a fresh install.
2. Once #171 has merged, add `/usr/local/bin/node`, `/usr/local/bin` and `/usr/local` to the observed set in `deploy/probe/claude-harness-layout.cjs`. The interpreter's file rule is root-owned with no group/other write, not the 0444 rule. Then remove the "trusted rather than observed" paragraph from `DEPLOYMENT.md` § AWS/SSM.

Block step 2 on #171 merging. Open a draft PR on a frozen base.
