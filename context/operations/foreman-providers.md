---
created: 2026-07-14
updated: 2026-09-28
author: gardener
---

# Autonomous inference provider order

The foreman and mentor use the same availability-aware provider vocabulary:
`openai`, `local`, and `anthropic`. The foreman's conservative normal order is
Claude only:

```sh
GARDEN_FOREMAN_PROVIDER_ORDER=anthropic
```

During the temporary Claude quota constraint, set this in a `garden-foreman`
systemd drop-in and restart the timer/service:

```ini
[Service]
Environment=GARDEN_FOREMAN_PROVIDER_ORDER=openai,anthropic
```

The foreman **rejects `local`**: the local-qwen hermit lane was retired fleet-wide
on 2026-09-13 (job `retire-local-qwen-hermit-lane`; no host runs Ollama), so a
`local` entry would be a guaranteed dead probe on every tick. A stale drop-in that
still names `local` (such as `openai,local`) makes the foreman handler FATAL at
parse time with a message naming the retirement; fix the drop-in to
`openai,anthropic` (or remove it) and restart.

The mentor's normal order is already the resilient sequence:

```sh
GARDEN_MENTOR_PROVIDER_ORDER=openai,local,anthropic
```

Set either value in the corresponding systemd service drop-in. The order is left
to right: Codex/OpenAI, local Ollama Qwen, then Claude when configured that way.
Missing credentials, quota limits, and transient provider failures advance to the
next provider. A malformed semantic response stops the tick safely; it never asks
a second model to make a competing decision. The handlers validate the
comma-separated order; the foreman accepts only `openai` and `anthropic`, the
mentor still accepts `openai`, `local`, and `anthropic`.

To restore the foreman's normal Claude-only order, remove its drop-in line (or set
`anthropic`) and restart `garden-foreman.timer`. Restart `garden-mentor.timer`
after changing its order. These are leader-only services, so make the change on
the active leader.
