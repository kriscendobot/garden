---
title: Problem + State machine (Unknown / Pending / Pinned-Allow / Pinned-Deny / Revoked)
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
notes: The three classical options (refuse / auto-add / refer + pin) are the canonical capability-policy taxonomy. TOFU is option 3 specialized to capability bindings. Pinned-Deny vs Revoked: both refuse, but Revoked came from a withdrawn Pinned-Allow — the holder explicitly retracted the trust. Promotability: Pinned-Deny can return to Unknown if the deny was a transient mistake.
---

> Abstract: **Problem**: a confined capability with an allowlist policy (HTTP client, Browser, Shell, Mount) has three options when handed a target outside its allowlist — **refuse** (the agent stalls; the user resolves out of band), **auto-add and continue** (the allowlist becomes a write-once log, no review), or **refer the decision** to a higher authority and **pin** the answer. Trust-on-first-bind is TOFU specialized to capability-policy bindings: the "first use" is the first attempt to *bind* a policy slot (origin, path, command) at request time. **State machine**: five states. **Unknown** — never seen (no record). **Pending** — request in flight asking the authority; subsequent requests for the same target wait on the same pending decision (coalesced; no second prompt). **Pinned-Allow** — in the allowlist; record carries provenance (who, when, by what mechanism). **Pinned-Deny** — explicitly refused; distinct from Unknown so a re-request does NOT re-prompt; promotable back to Unknown if the deny was a transient mistake. **Revoked** — was Pinned-Allow, now refused; in-flight requests already past the policy check abort. **Entry point shape**: `decideAndApply(target)` reads the state; Pinned-Allow → proceed; Pinned-Deny or Revoked → throw; Unknown or Pending → await prompt (coalesces concurrent), then write the result.

## What is the Problem Being Solved?

A confined capability whose policy is "allowlist of permitted targets" (an HTTP client allowlisted to a set of origins, a `Browser` exo allowlisted to a set of origins, a `Shell` allowlisted to a set of commands, a `Mount` allowlisted to a set of subpaths) has to answer the same question every time it is handed a target outside its allowlist:

- **Refuse** with a fault that the user has to resolve out of band (the agent stalls; the user opens a CLI and runs `endo http policy add https://api.example.com`; the agent retries).
- **Auto-add and continue** (least intrusive at the moment, but the allowlist is no longer a host-controlled artifact, and it grows without review).
- **Refer the decision** to a higher authority (the user, an attenuator the cap was minted with) and pin the answer for next time.

The third option is the well-known **trust-on-first-use (TOFU)** pattern: SSH pins a host key the first time it sees one, browsers prompt for notification permission the first time a site requests one, and OS package managers ask before adding a new keyring. The proposed pattern, **trust-on-first-bind**, is TOFU specialised to a capability whose policy is itself a capability surface: the "first use" is the first attempt to *bind* a policy slot (an origin, a path, a command) at request time, and the pin is recorded into the controller's policy storage where it is later inspectable, revocable, and exportable.

The pattern is a **shared adapter for capability policy storage**, not a feature of any one capability surface. PR #144's `HttpClient` raises the question first because origin allowlists are the smallest concrete example, but the same machine should plug into the `Browser` exo (`endoclaw-browser`), the `Shell`/`Git` exos (`daemon-agent-tools`), and `Mount` deny-pattern extensions (`daemon-mount`). This design describes the pattern once.

### State machine

A trust-on-first-bind controller holds a per-policy-slot state for every target it has ever encountered:

```
        first encounter
   --------------------------->  Pending
                                    |
                                    | decision (allow / deny / always-deny)
                                    v
                              +-----+-----+
                              |           |
              Pinned-Allow    |   Pinned-Deny
                              |           |
                              v           v
                         (revocable)  (revocable)
```

The states:

- **Unknown.** Default for any target the controller has never seen. No record in policy storage.
- **Pending.** A request is in flight asking the higher authority to decide. Subsequent requests for the same target wait on the same pending decision (coalesced); they do not raise a second prompt.
- **Pinned-Allow.** Target is in the allowlist. Record carries provenance (who decided, when, by what mechanism).
- **Pinned-Deny.** Target was explicitly refused. Distinct from Unknown so a second request does not re-prompt. Promotable back to Unknown by the controller holder if the deny was a transient mistake.
- **Revoked.** Previously Pinned-Allow, now refused. In-flight requests that were already past the policy check abort.

The controller's `fetch`/`open`/`exec` entry point is shaped as:

```js
const decideAndApply = async (target) => {
  const state = policy.get(target);
  if (state === 'Pinned-Allow') return proceed(target);
  if (state === 'Pinned-Deny' || state === 'Revoked') {
    throw makeError(X`policy denies ${q(target)}`);
  }
  // Unknown or Pending: ask the authority.
  const decision = await prompt(target); // coalesces concurrent
  policy.set(target, decision === 'allow' ? 'Pinned-Allow' : 'Pinned-Deny');
  if (decision === 'allow') return proceed(target);
  throw makeError(X`policy refused ${q(target)}`);
};
```

The `prompt` step is the only point of variation across deployment modes.

Source: [designs/trust-on-first-bind.md](https://github.com/endojs/endo-but-for-bots/blob/337329bdd0cee6c9f30b6dc593684e8823455e09/designs/trust-on-first-bind.md) at commit `337329bd` on branch `llm`.
