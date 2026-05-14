---
title: Decision modes (strict / tofu-prompt / tofu-auto / tofu-attenuator) + Who decides
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
notes: `strict` is the default — PR #144 ships strict-only; the other three are opt-in. `tofu-attenuator` is the canonical capability-discipline answer for "the cap was minted with its own policy authority" — the holder supplies the authority at mint time and the controller doesn't know what UI to surface (could be a Chat command bar, a form, an external service).
---

> Abstract: The `policyMode` enum selects the prompt implementation. **`strict`** (default; the only mode PR #144 ships): no prompt; Unknown targets fault immediately. **`tofu-prompt`**: prompt the controller's holder (user / interactive agent) and record the answer — for interactive sessions where the developer wants the cap to grow as they work without restart. **`tofu-auto`**: auto-Pinned-Allow + audit-log entry + reactive notification — for trusted-environment internals; **never** the default for an HTTP client (converts the allowlist into a write-once log). **`tofu-attenuator`**: forward the decision to a separately-supplied attenuator capability — the cap was minted with a policy attenuator (e.g., "ask the user via Chat" exo); the controller doesn't know what the prompt UI looks like. **Who decides**: the authority is a separate object from the controller, passed in at construction (`policyAuthority` with `.decide({kind, target, context})`). In `tofu-prompt` the daemon holds the authority and surfaces through the holder's connection channel (Chat / CLI / Familiar dialog). In `tofu-attenuator` the holder supplies the authority at mint time. In `tofu-auto` the authority is a no-op that always allows; passing a real authority makes it `tofu-attenuator` with auto-allow as default.

### Decision modes

The controller is constructed with a `policyMode` enum that selects the prompt implementation:

| Mode | Prompt behaviour | Use case |
|---|---|---|
| `'strict'` | No prompt. Unknown targets raise a fault immediately. | Production daemons; the original behaviour PR #144 ships. |
| `'tofu-prompt'` | Prompt the controller's holder (the user, an agent in interactive mode) and record the answer. | Interactive sessions; the developer wants the cap to grow as they work without restarting. |
| `'tofu-auto'` | Auto-Pinned-Allow with audit-log entry and a reactive notification to the holder. | Trusted-environment internals; never the default for an HTTP client because it converts the allowlist into a write-once log. |
| `'tofu-attenuator'` | Forward the decision to a separately-supplied attenuator capability. | The cap was minted with a policy attenuator (e.g. a "ask the user via Chat" exo); the controller does not know what the prompt UI looks like. |

`'strict'` is the default. The PR #144 changeset describes only `'strict'`; this design adds the other three as opt-in.

### Who decides

The decision authority is a separate object from the controller, passed in at construction:

```js
const { client, control } = makeHttpClientKit({
  allowedOrigins,
  policyMode: 'tofu-attenuator',
  policyAuthority, // a capability with .decide({ kind, target, context })
});
```

In `'tofu-prompt'` mode the daemon holds the authority and surfaces the prompt through whatever channel the holder is connected through (Chat message, CLI question, Familiar dialog). In `'tofu-attenuator'` mode the holder supplies the authority when they mint the cap, and it can be a Chat command bar slot, a form (`daemon-form-request`), or an external service. In `'tofu-auto'` mode the authority is a no-op `{ decide: async () => 'allow' }` whose only side effect is the audit log entry; passing a real authority is allowed and would amount to `'tofu-attenuator'` with auto-allow as a default.

Source: [designs/trust-on-first-bind.md](https://github.com/endojs/endo-but-for-bots/blob/337329bdd0cee6c9f30b6dc593684e8823455e09/designs/trust-on-first-bind.md) at commit `337329bd` on branch `llm`.
