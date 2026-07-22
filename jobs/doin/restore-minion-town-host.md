---
role: fixer
---

priority: urgent
role: fixer

# Restore the impaired minion.town production host

Production outage observed 2026-07-22 around 19:10 UTC:

- `https://minion.town/` times out connecting to port 443.
- DNS resolves to `13.56.17.18`, matching EC2 `i-0380cd68b90020fad` in `us-west-1`.
- EC2 state is `running`; system status is `ok`; instance status is `impaired`.
- SSM reports `ConnectionLost`, last ping `2026-07-22T17:38:10.904Z`.
- The serial orchestration `minion-town-mcp-daemon-guest-tools-orchestration` is in flight. B3 daemon stand-up is complete. `minion-town-mcp-b4-full-facet-surface` was claimed at 18:03 UTC and has been reaped once. Preserve its work and avoid overlapping/clobbering any deployment state.

Repository: private `kriscendobot/minion.town`. Operational reference: `context/operations/aws-bringup.md` and the repository's `DEPLOYMENT.md`. AWS CLI is `$HOME/.local/bin/aws`; region `us-west-1`.

Diagnose and restore production using the least-destructive action that works. Inspect EC2 status details, CloudWatch/console evidence available through read-only APIs, SSM reachability, and recent instance/deployment state. If an EC2 reboot is warranted, perform and monitor it. Do not stop/start or replace the instance, alter DNS/EIP, roll back data, or destroy infrastructure unless the evidence requires it and the action is explicitly authorized through the maintainer channel. Do not expose secret values.

Once access returns, inspect system health and logs; restore Caddy, oauth2-proxy, minion MCP/daemon, and SSM agent as applicable. Reconcile the deployed revision without overwriting uncommitted or in-flight B4 work. Verify from outside the host: HTTPS/TLS and expected landing/auth behavior; health/metadata endpoints; MCP authorization behavior using non-secret probes. Confirm EC2 system and instance status checks are both `ok` and SSM is `Online`.

Coordinate with the in-flight B4 job through its inbox if it is still active. Determine whether B4 merely blocked on the outage, partially deployed, or needs deterministic requeue/resume; do not duplicate its feature implementation. Report root cause if knowable, exact recovery actions, before/after evidence, deployed revision, remaining risks, and any follow-up job needed for durable monitoring or recurrence prevention.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 17
  worker_kind: cleric
  claimed_at: 2026-07-22T19:11:32Z
