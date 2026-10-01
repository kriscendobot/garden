All four call sites named in the job are fixed and pushed to the #1404 head. CI is green on the current head (17 checks pass, the rest skipped).

That head is `9809f6d979`, a peer's commit on top of mine. The CI run on my own head (`fb2bb0ae06`) was cancelled when that push landed. By then everything had passed except the two macOS test legs, which were still running.

**Commits on `guest-no-identifiers-locators`**
- **`19d61f0bbe` floot**
  - `container-mounts.js`: the possession check now asks the factory host (`E(powers).identify(sessionName, ...path)`), using the host's own name for the session guest. `makeSessionKit` takes `sessionName` instead of `sessionGuest`, and `agent.js` passes `agentName`.
  - `floot-factory-setup.js`: both `storeLocator('account-profile', …)` calls on the oracle guest became `E(agent).copy(profileNamePath, [<oracle guest path>, 'account-profile'])`. One is in the create path, one in the reuse path.
  - The three container-mount test files now resolve possession through the host.
- **`e463c67663` fae**: this needed more than the job listed. The factory, the spawner and the provider factory all run as guests and called `locate` themselves.
  - `subagent-host.js`: the spawner and driver guests get their capabilities bound by the host via `E(hostAgent).storeLocator([<guest>, name], loc)`. I exported a new helper, `spawnerProfileNameFor`.
  - The spawner (`subagent-spawner.js`) and the factory (`agent.js`) now ask the host for the locators they pass on, using their own host-side name. The spawner works its name out from `SUBAGENT_PARENT`.
  - The factory gets its name from a new `FAE_FACTORY_POWERS_NAME` env var. `fae-factory-setup.js` and `setup-with-tools.js` now set it, and also write the provider and auth secret into the factory from the host side. An existing factory launched without that variable will refuse to create agents, with a clear error, until setup is re-run.
  - The driver spots its own outgoing mail with `fromNames.includes('@self')`. `llm-provider-factory.js` does the same, and reads the submitted form value by adopting the message's `value` edge instead of calling `lookupById`.
  - I also updated `endo-skill.js`, the smoke test and the channel-mention test.
  - New test: provisioning binds each guest its capabilities through the host. The `subagent-loop` test mock now also carries `fromNames`/`toNames`.
- **`fb2bb0ae06` lal**
  - Own-mail detection uses `fromNames.includes('@self')`, and form values are read by adopting the `value` edge.
  - Each worker's `primer` is now bound by the host (`E(agent).copy(['lal-primer'], [`profile-for-${name}`, 'primer'])`).
  - The `listMessages` tool reports `fromNames`/`toNames`, and I dropped the `locate` tool.
  - The mock guest powers match the new message shape, and `AGENTS.md` and `LAL-ARCHITECTURE.md` are updated.

**Checks run locally:** the full ava suites passed for fae (156, plus 2 failures already marked as known), floot (195) and lal (52). eslint shows warnings only, no errors. The repo-root `tsc -p tsconfig.json` is clean; it ran out of memory at the default heap and needed `--max-old-space-size=8192`. All three packages are private, so no changesets.

**Follow-up:** fae's subagent delegation (`spawnSubagent`/`askSubagent` and the matching of replies to asks) still identified subagents by locator, which would throw in a real guest. I posted that as `ebfb-1404-fae-subagent-delegation-names`. A peer claimed it within minutes and pushed `9809f6d979` ("delegate to subagents by pet name, not locator"); that is the commit CI is green on now. I have not reviewed that commit.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-1404-guest-consumers-identifiers.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 208 tokens (13405102 cached reads)
- Output: 50367 tokens
- Cost: $5.054104399999999
- Wall-clock: 5148s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
