---
title: Out of Scope, Future Work
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

- **Per-target attenuators inside a binding.** A binding could carry per-method limits (allow GET but not POST), per-path limits (allow `/repos/*` but not `/users/*`), or per-time-of-day limits. This design treats a binding as a binary gate; richer per-binding policy is a follow-on.
- **Cross-controller policy sharing.** Two `HttpController` instances may want to share a policy table (the user's "trusted origins" set). Out of scope; addressable by minting both controllers from a shared policy-store capability.
- **TLS certificate pinning.** Discussed under alternatives; tracked separately if and when it becomes a question.
- **Default-allow with deny-list.** The inverse posture (start open, pin denials). Not in this design because the capabilities under discussion (HTTP, browser, shell, mount) are explicitly default-deny by taste; an inverted controller is a different design.

Source: [designs/trust-on-first-bind.md](https://github.com/endojs/endo-but-for-bots/blob/337329bdd0cee6c9f30b6dc593684e8823455e09/designs/trust-on-first-bind.md) at commit `337329bd` on branch `llm`.
