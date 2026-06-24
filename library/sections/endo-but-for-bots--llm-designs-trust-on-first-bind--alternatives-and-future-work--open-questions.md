---
title: Open Questions
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

1. **Should `'tofu-prompt'` survive across daemon restart for a pending decision?** If the holder is offline when a prompt arrives, the prompt times out and the binding stays Unknown. An alternative is to persist the pending state and re-prompt on reconnect.
2. **Is the audit log per-controller or per-host?** Per-controller is simpler and matches PR #144's policy storage. Per-host gives a single pane of glass but couples controllers that should be independent.
3. **What does the prompt UI look like in `'tofu-prompt'` mode by default?** CLI prompt blocks the running command; Chat could use `daemon-form-request`; Familiar an Electron dialog. The decision-mode names abstract the surface but the daemon needs one concrete default.
4. **Should audit log entries be exportable as a structured stream** so a higher-level monitoring capability can observe policy decisions across many controllers?
5. **Naming.** `trust-on-first-bind` settled on for the TOFU echo + "bind" matches capability-system vocabulary. Alternatives: "ask-and-pin", "lazy allowlist", "deferred policy".

Source: [designs/trust-on-first-bind.md](https://github.com/endojs/endo-but-for-bots/blob/337329bdd0cee6c9f30b6dc593684e8823455e09/designs/trust-on-first-bind.md) at commit `337329bd` on branch `llm`.
