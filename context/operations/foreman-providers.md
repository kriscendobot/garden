---
created: 2026-07-14
updated: 2026-07-14
author: gardener
---

# Foreman inference providers

The foreman normally uses Claude only. Its default is therefore:

```sh
GARDEN_FOREMAN_PROVIDER_ORDER=anthropic
```

During the temporary Claude quota constraint, set this in a `garden-foreman`
systemd drop-in and restart the timer/service:

```ini
[Service]
Environment=GARDEN_FOREMAN_PROVIDER_ORDER=openai,local,anthropic
```

The order is left to right. Codex/OpenAI is tried first, then the local Ollama
Qwen endpoint, and Claude is used only if both are unavailable or quota-limited.
An availability or quota failure advances to the next provider. A malformed
planning response stops the tick safely, so conflicting output cannot post more
than one job.

Next week, remove the drop-in line (or set `anthropic`) and restart
`garden-foreman.timer` to restore the normal order. The handler validates the
comma-separated order and accepts only `openai`, `local`, and `anthropic`.
