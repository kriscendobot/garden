I opened draft PR https://github.com/kriscendobot/minion.town/pull/193, which builds the OCapN guest canary from design #191 Section 6. The 12 offline tests pass, but nothing has been run against a live Endo daemon or minion.town yet.

**What changed** (on branch `build/ocapn-guest-canary`, based on the frozen `main-30a4c62`):
- **`deploy/probe/ocapn-canary.mjs`**: the canary, in plain JavaScript. It calls the Endo CLI directly through `execFile`, with no shell.
  - It runs `endo start` and `endo net ensure ocapn`.
  - It binds each guest using its locator (formula id). The locators come from the host-local file `~/.garden-state/ocapn-canary/guests.json`, which must be mode 0600 and is never committed.
  - In both directions (A→B, then B→A) it sends a message with a per-run marker and polls until it shows up in the recipient's inbox. It then sends a capability, has the recipient adopt it and call it, and cleans up afterwards.
  - Each run writes an audit record to `~/.garden-state/ocapn-canary/audit/<runId>.json`. It holds guest names and step results only; every locator is scrubbed out of command output.
  - Exit codes follow the accepted failure contract: 0 means pass, 1 means a failure or an incomplete run, and 75 means not-provisioned. A not-provisioned run also prints one line to stderr: `ocapn-canary: not-provisioned reason=<missing|unreadable|insecure|insufficient-guests>`. That is what it reports until the guest ids exist.
- **`deploy/probe/ocapn-canary.test.mjs`**: offline tests, added to CI in `test.yml`. They cover how the guests file and run results are classified, the exit codes, and locator scrubbing. They also run the whole canary against a fake Endo CLI: a healthy pair, a message that never arrives, a transport failure (checking no locator leaks into the record), and a guest with no capability to share.
- **`deploy/probe/systemd/minion-ocapn-canary.{service,timer}`**: a user-level systemd timer that runs the canary every 6 hours. It goes only on the host that holds the guests file, as design Section 4 requires.

**Not done or unverified:**
- **CLI behaviour is assumed.** The design's runbook only documents binding a guest through `endo accept` with an invitation, so binding one by formula id that way is my assumption. So is the input and output shape of `endo eval`. Both need checking on the first live run on the canary host.
- **Known CLI gap.** `endo net ensure ocapn` doesn't exist yet. Until it lands, a provisioned run will fail at the transport step.
- **The Claude-operated guest leg** is left as a follow-up because it needs a live Claude credential. The PR body says so; it isn't faked.
- **One-time interactive setup is documented in the PR, not built.** Someone signs in once and calls `GET /account/guest-formula-id` (or accepts an invitation) to capture each guest's id, then writes the guests file. Each guest also needs a name for the other guest and a capability to share.
- **Installing the timer** on `endolin-garden1` is a manual step.
- Root-only checks are out of scope, as the design says.

The PR is still a draft and needs review.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-ocapn-guest-canary.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1136215 cached reads)
- Output: 17525 tokens
- Cost: $1.1077670000000002
- Wall-clock: 210s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
