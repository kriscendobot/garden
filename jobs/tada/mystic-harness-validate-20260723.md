Validation passed; no changes made.

- Mystic uses the official `kimi` CLI, Moonshot/Kimi K3 metadata, explicit `model: kimi-k3` routing, and no default Mystic model/capacity.
- Offline harness: 14 passed. Confirmed per-job `KIMI_CODE_HOME`, credential-safe capture, sentinel gating, resume, and cleanup.
- Worker-spine, routing, provider-order, and scaler tests passed.
- Reputation arm is provider-scoped: `mystic / moonshot / kimi-k3`.
- Not deployed or canaried. Canary should enable one Mystic, run an explicit reversible K3 job, inspect `tada` report/output capture and Moonshot-scoped reputation event, then return capacity to zero.
