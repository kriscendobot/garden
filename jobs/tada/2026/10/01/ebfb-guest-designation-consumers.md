I opened draft PR [endojs/endo-but-for-bots#1410](https://github.com/endojs/endo-but-for-bots/pull/1410), stacked on #1404. It moves every remaining follow-up consumer in the #1404 ledger off the guest identifier and locator methods, and it adds none of them back. I did not watch CI on #1410, and the daemon-backed suites were never run locally, so CI will be the first run of those.

**Stacking.** `ensure-pr.sh` would not accept the moving #1404 head as a base. I pushed a frozen snapshot of it, `guest-no-identifiers-locators-9809f6d`, and based #1410 on that. If #1404 gets more commits, #1410 will need a rebase.

**Already done before I started.** lal, fae, the floot container mounts and `cli inbox` had been migrated on the #1404 head by earlier jobs. The code-mode-provisioning tests, `auto-responder-agent.js`, the fae smoke test and the setup scripts only call these methods on a host, which is still allowed.

**Commits on branch `guest-designation-consumers`:**
- **jaine:**
  - The router spots its own mail with `fromNames.includes('@self')`.
  - Channels are keyed by pet name instead of by their formula id.
  - The factory now has the host bind the driver's capabilities, and finds its own name from a new `JAINE_FACTORY_POWERS_NAME` env var, the same way fae does.
- **workflow:**
  - Senders and recipients are checked by comparing the actual capabilities (`@mail/<n>/@from|@to` against `@self` and the endowment that was asked).
  - The ledger suggested matching on `fromNames`, but that would let an unnamed attacker match an unnamed operator.
  - The saved correlation no longer stores `from`/`to`.
- **claude-sandbox:**
  - Own forms are recognized with `fromNames`.
  - Form replies are read by adopting the message's `value` edge, looking it up, then removing the temporary name. This replaces `lookupById(valueId)`.
- **floot:**
  - Stored tools are pinned by name and schema instead of by locator.
  - `TOOL_POLICY_VERSION` is now `floot-endo-tools-v2`, so threads pinned the old way start fresh.
  - The `listMessages` tool reports `fromNames`.
- **lal:** the system prompt and primer stop telling the model to use a `locate` tool that no longer exists.
- **chat / spaces:**
  - A guest profile is checked with `has('@self')`.
  - A guest's inbox uses `fromNames`/`toNames` and reads values by adopting them.
  - `/locate`, `/invite` and `/accept` give a clear error for a guest. Host profiles behave as before.
- **cli:** `endo locate`, `invite`, `accept` and `paths <name>` give a clear error for a guest `--as`. `endo list -g/--type` asks the host instead.
- **Docs:** I updated nine design docs and four package docs (including both FAE docs). Designs that have already landed get a dated note pointing to #1404.

There are no changesets because every package touched is private.

**Tests run locally, all passing:**

| Package | Tests |
|---|---|
| workflow | 114 |
| claude-sandbox | 35 |
| floot | 195 |
| lal | 52 |
| fae subsets | 28, plus 2 failures already marked as known |
| chat | 902, including 6 new |
| cli unit suites | 15 |

The cli suites that need a running daemon fail locally. I believe that is the known `better-sqlite3` mismatch with Node 22, but I didn't confirm it against unchanged code. jaine has no test suite, so it only got eslint and prettier.

**Things a reviewer needs to know:**
- Existing jaine and fae factories have to be re-created before they can create agents. Until then `createAgent` throws a clear error.
- The `prettier` helper script I set up for the subagents was broken, so they ran the repo's own prettier 3.9.8 instead.
- I removed my one-line change to the designs README index (it still says capabilities are bound with `storeIdentifier`). The PR-opening check treats that file as an ordered design and refused the PR while it was in the diff.

**Follow-ups, listed in the PR body:**
- A guest profile's inventory shows no type badges and can't open a conversation by clicking an item.
- Editing a guest's sent message loses its `@token` bindings.
- Chat channel-mode `/adopt` and `/reply` still use locators.
- `daemon/src/help.md` should be checked to make sure its `storeIdentifier`/`invite` sections aren't shown to guests.
- The designs README index row above still needs fixing.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-guest-designation-consumers.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (2998147 cached reads)
- Output: 20926 tokens
- Cost: $10.425884999999997
- Wall-clock: 692s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
