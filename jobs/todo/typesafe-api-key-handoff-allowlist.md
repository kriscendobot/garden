---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Add TYPESAFE_API_KEY to the container's env-var handoff allowlist

Maintainer directive (kriskowal, 2026-09-21), follow-up to
`incorporate-typesafe-agent-skill`. So the garden picks up
`TYPESAFE_API_KEY` on next container recreation (if/when the maintainer
exports it on the host before running `./garden create`), add it to the
allowlist in `scripts/systemd/seed-api-key-handoff.sh` alongside the
existing provider keys:

```
for key_name in ANTHROPIC_API_KEY MOONSHOT_API_KEY FIREWORKS_API_KEY OPENROUTER_API_KEY OLLAMA_CLOUD_API_KEY TYPESAFE_API_KEY; do
```

Same validation already applies uniformly (base64url charset check, no
per-key special-casing needed) — this is a one-line addition to the
allowlist array, not new logic.

Check whether `context/first-run/README.md` or any operator-facing doc
enumerates the current handoff-eligible key names (mirroring how
`OLLAMA_CLOUD_API_KEY` was documented when it was added) and add
`TYPESAFE_API_KEY` there too if such a list exists, so an operator knows
this key is now recognized.

This only wires the HANDOFF (host env var -> container's lingering systemd
user manager). It does not provision a key value, and does not wire the key
into any specific worker/handler's consumption path — `skills/typesafe-ai/
SKILL.md` (from the prior job) already documents that real use is a
separate, later step once a key exists. Nothing here should attempt to
acquire or assume a key value.

## Verify

Existing `seed-api-key-handoff.sh` test coverage (if any) still passes;
extend it to cover the new key name the same way the existing ones are
covered, if the test file enumerates keys explicitly rather than looping
generically.

## Report

Confirm the allowlist change landed and that no key value was invented,
assumed, or hardcoded anywhere.
