Implemented and pushed `d4a40ed9ba` to `main2`.

- Removed image auto-enablement of system `ollama.service`; `garden-ollama.service` is the sole owner.
- Confirmed/documented bot-user GPU group access via `entrypoint.sh`.
- Refused model-less foreign listeners, alerted once per signature, and required the pinned model during preflight/self-heal.
- Updated tests and operations documentation.

Ran shellcheck and focused tests: 14 + 19 + 12 passing. Also exercised a real local `:11434` empty-model stub; wrapper did not stand down. Cold Docker rebuild not run.
