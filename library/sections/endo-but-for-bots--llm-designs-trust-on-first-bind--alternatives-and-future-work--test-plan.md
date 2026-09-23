---
title: Test plan
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
notes: The "auto-add as the only mode" critique is the load-bearing argument against `tofu-auto` as a default — it converts the allowlist from a host-controlled artifact into a write-once side-effect log, defeating the protection against agent compromise. The default-allow-with-deny-list inversion is explicitly out of scope; the capabilities under discussion are default-deny by taste.
parent: endo-but-for-bots--llm-designs-trust-on-first-bind--alternatives-and-future-work
---

- Pin a target via `'tofu-prompt'`; second request for the same target does not re-prompt.
- Two concurrent requests for the same Unknown target produce one prompt, both observe the same outcome.
- A `Pinned-Deny` target throws `policy refused`; a later `unpin` followed by a request re-prompts and can be allowed.
- A `revokeBinding` on a `Pinned-Allow` target moves it to `Revoked`; next request fails.
- Prompt timeout leaves the binding as `Unknown` and produces a `policy decision timed out` error; audit log records the timeout.
- `listBindings` returns the same content after a controller restart for `'tofu-prompt'` and `'tofu-auto'` modes.
- `setPolicyMode('strict')` after some bindings exist preserves the bindings; new Unknown targets refuse without prompting.
- `'tofu-attenuator'` mode with a no-op attenuator that always rejects produces `Pinned-Deny` for every fresh target.
- Audit log roll-off: filling past the configured cap drops the oldest entries while preserving `listBindings`.

Source: [designs/trust-on-first-bind.md](https://github.com/endojs/endo-but-for-bots/blob/337329bdd0cee6c9f30b6dc593684e8823455e09/designs/trust-on-first-bind.md) at commit `337329bd` on branch `llm`.
