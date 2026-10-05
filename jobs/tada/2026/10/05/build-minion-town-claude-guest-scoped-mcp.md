## Completion report: `build-minion-town-claude-guest-scoped-mcp`

I opened draft PR **https://github.com/kriscendobot/minion.town/pull/160**. Its base is the frozen `main-9ac858d` and its body says "Fixes #149". CI is green, and the live-daemon suite ran rather than being skipped: 7 of 7 passed. I posted a reply with the PR link on #149: https://github.com/kriscendobot/minion.town/issues/149#issuecomment-5997486994

**The prerequisite.** endojs/endo-but-for-bots#1407 **merged** into `llm` on 2026-10-05 as a docs-only change. Its per-guest socket API was removed during review, as the job annotation said it would be. The existing launcher did **not** already satisfy #149, because the confined session's `mcp.json` still named the root socket in `ENDO_SOCK`. Upstream `llm` already had what was needed, though: an in-harness broker (`startGuestBroker`) and `relay.mjs`, added in `4edefa3ad0`. They use the one-root-socket plus `lookupById` design that #1407's review settled on, so I built on them.

**Item 1 (structure, not selection).**
- `brokerFor` now starts the upstream broker inside the minion.town app, using the app's own root connection. The broker looks up one guest, keeps only that guest's handle, and serves it on a private socket in a `0700` directory under the runtime tmpfs.
- The confined `claude` spawns only `env -i node relay.mjs <broker-socket>`. `ENDO_SOCK`, the root socket path and the formula ID no longer appear in the spawn's `mcp.json`, argv or env.
- The backend test now asserts they are absent and pins the new transport. The live test asserts the same against the real upstream broker.
- A child's broker is closed when the child is removed (new test) or when the daemon connection drops.
- I removed the now-dead `ENDO_CLAUDE_AGENT_MCP_COMMAND` config.

**Endo pin bump.** The pin moves from `1706e632` to `9174aad59e1f`.
- `4edefa3ad0` itself fails `yarn install --immutable` (stale lockfile; this was CI's first failure). Its only child, `9174aad59e1f`, changes nothing but `yarn.lock`, so that is the narrowest commit that installs.
- There are **no `packages/daemon` changes** between the two pins, so the migration problem that crash-looped the earlier `89481580` bump should not recur. The deploy script's existing upgrade check still guards the swap on prod.
- I re-vendored `@endo/claude`. Upstream's `index.js` now re-exports modules that import the unpublished `@endo/agent-mcp-stdio`, so the vendor script replaces those lines with a marker. The replacement is recorded in `PROVENANCE.json` and the drift test still verifies the file against upstream.
- The harness now passes `--output-format stream-json --verbose` itself, so `cli-launch.ts` adds those flags only when they're missing.

**Item 2 (same unix user).** I updated the comments in the bridge and `cli-provider.ts` and the text in `DEPLOYMENT.md`. Through each other's spawn files, `claude` and the relay can now reach only that one guest's authority and the spawn's own token, both of which the confined session already holds. They can no longer reach the root host. I did **not** build the separate unix user: it would need a group-shared directory or a file-descriptor handoff that upstream `startGuestBroker` doesn't offer. The PR lists it as a follow-up.

**Item 3 (mail edge).** f3235e1 is on `main` and the live test still asserts that a child's `@host` is not the root's. I didn't change it.

**Testing.** Typecheck is clean. Locally, 842 tests pass and 1 fails: `test/git-remote/capability.test.ts`, a known failure on this host that predates this change. CI passed 843.

**Follow-ups:**
- Running the relay as a separate unix user (optional per #149).
- Deploying the pin bump to prod, which needs the usual NRestarts check over SSM after deploy.
- No garden (`main2`) changes were needed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-guest-scoped-mcp.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 136 tokens (7765039 cached reads)
- Output: 42935 tokens
- Cost: $3.5898437999999993
- Wall-clock: 1155s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
