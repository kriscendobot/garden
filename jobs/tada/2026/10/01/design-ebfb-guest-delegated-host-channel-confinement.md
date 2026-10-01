## Completion report: design-ebfb-guest-delegated-host-channel-confinement

The design is written and up for review as draft PR **endojs/endo-but-for-bots#1414**. Its only change is the new design file.

- **Design:** `designs/daemon-guest-delegated-host-channel-confinement.md`, committed `a1a1b8a264` on branch `design/guest-delegated-host-channel-confinement`.
- **Base:** a frozen snapshot of `llm`, branch `llm-afc72ca` (`afc72caff9`). The PR description follows the repo's template, refs #1404, and carries the job marker.
- **Grounding:** I read the #1404 head (`90b4f72604`): `guest-redaction.js`, `guestFacetFor` in `directory.js`, `channel.js`, and the interface definitions. I also listed every host method that fae, lal, jaine and claude-sandbox call on the host bound into their guests.

### Recommendations

1. **Delegated host (breaker):** guests that today receive the full host would receive a reduced, durable `provisioner` object instead.
   - Setup scripts would bind it with `introducedNames: { '@provisioner': 'host-agent' }`, so the agents' own code keeps using the name `host-agent`.
   - It keeps the methods for working with names and creating things. It withholds everything that handles formula identifiers or locators, plus peer, bootstrap, mailbox, and host-creating methods.
   - **Main finding:** the identifier handling in these agents is incidental. Almost every use (fae's locate-then-store pattern, jaine's pinning, lal's logging) can be replaced by copying by pet name. The one exception is claude-sandbox's mount bridge, which looks a capability up by identifier and needs its callers changed.
   - **Limit:** the provisioner still lets the guest run unconfined code, so it is not isolation. It gives least authority and makes the #1404 rule hold for these guests. Whether to keep that ability is open question 1.
2. **Channels (purist and wire-watcher):** a guest reaching a channel, member or invitation would get a filtered view of it.
   - Message lists and streams drop the formula identifiers, and posting identifiers is refused.
   - Host-side readers see no change.
   - This closes three problems: leaking identifiers, a guest falsely presenting itself as the sharer of a capability, and the combination with gap 1, where a leaked identifier plus the full host becomes real authority.

The design also includes an ownership map, a plan of four build PRs (the channel work and the new provisioner can be built in parallel), a test plan, the alternatives I rejected, and seven open questions for the maintainer.

### Follow-ups

- Kris needs to answer the open questions, especially: whether the provisioner keeps the ability to run unconfined code and evaluate; whether full delegation should stay possible through an explicit opt-in; and whether guests should be able to post or receive capabilities through channels.
- The design depends on #1404, which is still open.
- I noted one item in the design as "to be filed": find out who creates the identifier that claude-sandbox's mount bridge receives, so it can be passed by name or as the capability instead.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-ebfb-guest-delegated-host-channel-confinement.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (2886386 cached reads)
- Output: 26537 tokens
- Cost: $1.9013532000000004
- Wall-clock: 336s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
