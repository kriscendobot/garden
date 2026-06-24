---
title: Alternatives considered + Out of scope + Open questions + Test plan
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
kind: index
section_count: 4
---

> Abstract: **Alternatives considered**: (1) **Refuse and document** (strict-only; do-nothing alternative) — right default; argued against because interactive agent development would alt-tab to a CLI for every new origin. (2) **Auto-add with audit log** (`tofu-auto` as only mode) — rejected as default because it converts the allowlist into a write-once side-effect log; a compromised agent can extend its own reach. (3) **Per-request prompts (no pinning)** — rejected; prompt cost dominates (five fetches = five prompts); TOFU pins, that's the point. (4) **TLS certificate pinning** — different problem; pinning a server's TLS public key, not allowlist membership; out of scope. **Out of scope**: per-target attenuators inside a binding (per-method, per-path, per-time-of-day limits); cross-controller policy sharing (mint both from a shared policy-store cap); TLS cert pinning; default-allow with deny-list (inverse posture — the capabilities here are default-deny by taste). **Open questions**: should `tofu-prompt` survive a daemon restart for a pending decision? per-controller vs per-host audit log? what's the prompt UI by default? exportable structured audit-event stream? naming (settled on trust-on-first-bind for the TOFU echo + "bind" matches capability-system vocab). **Test plan**: pin via tofu-prompt; concurrent same-target produces one prompt; Pinned-Deny throws; unpin re-prompts; revokeBinding moves to Revoked; timeout returns to Unknown with timed-out error; restart preserves listBindings; setPolicyMode('strict') preserves existing bindings; tofu-attenuator with always-reject yields Pinned-Deny; audit log roll-off preserves listBindings.

Sections:

- [Alternatives considered](endo-but-for-bots--llm-designs-trust-on-first-bind--alternatives-and-future-work--alternatives-considered.md)
- [Out of Scope, Future Work](endo-but-for-bots--llm-designs-trust-on-first-bind--alternatives-and-future-work--out-of-scope-future-work.md)
- [Open Questions](endo-but-for-bots--llm-designs-trust-on-first-bind--alternatives-and-future-work--open-questions.md)
- [Test plan](endo-but-for-bots--llm-designs-trust-on-first-bind--alternatives-and-future-work--test-plan.md)

Source: [designs/trust-on-first-bind.md](https://github.com/endojs/endo-but-for-bots/blob/337329bdd0cee6c9f30b6dc593684e8823455e09/designs/trust-on-first-bind.md) at commit `337329bd` on branch `llm`.
