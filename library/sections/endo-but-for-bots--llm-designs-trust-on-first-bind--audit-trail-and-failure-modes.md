---
title: Audit trail (event-log entries) + Failure modes
source: designs/trust-on-first-bind.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 337329bdd0cee6c9f30b6dc593684e8823455e09
source_date: 2026-05-10
source_authors: [Kriscendo Bot]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security]
status: current
notes: The audit log is **bounded** (default 1024 entries) and rolls off — the listBindings table is the durable record, the audit log is just the change history. The concurrent-first-requests coalescing is the load-bearing UX detail: N simultaneous Unknown-target requests produce ONE prompt, not N. The 30s policyPromptTimeoutMs default and the "binding returns to Unknown on timeout" behavior together give clean retry semantics.
---

> Abstract: **Audit trail**: every state transition appends an entry: `{at: ms-epoch, target, fromState, toState, decisionMode, decidedBy, context?: {method, userAgentNote}}`. Log is **bounded** (most recent N, default 1024); exposed via `control.listAuditEntries({since, limit})`. Old entries roll off; `listBindings` is the durable record, the audit log is the change history. **Failure modes**: (1) **Holder rejects** — request fails with `policy refused <target>`; retry reads the pin and fails again; requester avoids retry-storm. (2) **Prompt times out** — `policyPromptTimeoutMs` (default 30s, separate from request timeout); on timeout, binding returns to Unknown; request fails with `policy decision timed out`; next request re-prompts; audit log records the timeout. (3) **Network down during prompt** — orthogonal; network not consulted until policy check passes. (4) **Authority cap revoked mid-prompt** — pending prompt rejects with upstream error; binding stays Unknown; later request can re-prompt via freshly-supplied authority (`setPolicyAuthority`). (5) **Concurrent first requests** — controller coalesces concurrent same-Unknown-target requests into one Pending decision; all callers wait on that one prompt + observe the same outcome (avoids stacking prompts).

### Audit trail

Every state transition appends an entry to a per-controller audit log:

```ts
type AuditEntry = {
  at: number;             // ms epoch
  target: string;
  fromState: 'Unknown' | 'Pinned-Allow' | 'Pinned-Deny' | 'Pending' | 'Revoked';
  toState: 'Pinned-Allow' | 'Pinned-Deny' | 'Pending' | 'Revoked' | 'Unknown';
  decisionMode: 'strict' | 'tofu-prompt' | 'tofu-auto' | 'tofu-attenuator';
  decidedBy: string;
  context?: { method?: string; userAgentNote?: string };
};
```

The log is bounded (most recent N entries, default 1024) and exposed via `control.listAuditEntries({ since, limit })`. Old entries roll off; the persistent `listBindings` table is the durable record, the audit log is the change history.

### Failure modes

- **Holder rejects.** The request fails with `policy refused <target>`; the requester can retry, in which case the pin is read from policy and the request fails again immediately. The requester is responsible for not retry-storming.
- **Prompt times out.** The controller is constructed with a `policyPromptTimeoutMs` (default 30 s, separate from the request timeout); if the authority does not respond, the binding stays `Pending` for that interval and then the request fails with `policy decision timed out`. The binding returns to `Unknown`; next request re-prompts. The audit log records the timeout.
- **Network goes down during prompt.** Orthogonal: the network is not consulted until the policy check passes. If the network is down when the request is allowed to proceed, the request fails on connect; the pin remains.
- **Authority capability revoked mid-prompt.** The pending prompt rejects with the upstream error; the binding stays `Unknown` so a later request can be re-prompted via a freshly-supplied authority (set with `setPolicyAuthority`).
- **Concurrent first requests.** The controller coalesces concurrent requests for the same Unknown target into a single Pending decision; all callers wait on that one prompt and observe the same outcome. This avoids stacking prompts on the holder for what is one decision.

Source: [designs/trust-on-first-bind.md](https://github.com/endojs/endo-but-for-bots/blob/337329bdd0cee6c9f30b6dc593684e8823455e09/designs/trust-on-first-bind.md) at commit `337329bd` on branch `llm`.
