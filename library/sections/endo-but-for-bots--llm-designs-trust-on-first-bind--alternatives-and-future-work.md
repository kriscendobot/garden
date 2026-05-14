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
---

> Abstract: **Alternatives considered**: (1) **Refuse and document** (strict-only; do-nothing alternative) — right default; argued against because interactive agent development would alt-tab to a CLI for every new origin. (2) **Auto-add with audit log** (`tofu-auto` as only mode) — rejected as default because it converts the allowlist into a write-once side-effect log; a compromised agent can extend its own reach. (3) **Per-request prompts (no pinning)** — rejected; prompt cost dominates (five fetches = five prompts); TOFU pins, that's the point. (4) **TLS certificate pinning** — different problem; pinning a server's TLS public key, not allowlist membership; out of scope. **Out of scope**: per-target attenuators inside a binding (per-method, per-path, per-time-of-day limits); cross-controller policy sharing (mint both from a shared policy-store cap); TLS cert pinning; default-allow with deny-list (inverse posture — the capabilities here are default-deny by taste). **Open questions**: should `tofu-prompt` survive a daemon restart for a pending decision? per-controller vs per-host audit log? what's the prompt UI by default? exportable structured audit-event stream? naming (settled on trust-on-first-bind for the TOFU echo + "bind" matches capability-system vocab). **Test plan**: pin via tofu-prompt; concurrent same-target produces one prompt; Pinned-Deny throws; unpin re-prompts; revokeBinding moves to Revoked; timeout returns to Unknown with timed-out error; restart preserves listBindings; setPolicyMode('strict') preserves existing bindings; tofu-attenuator with always-reject yields Pinned-Deny; audit log roll-off preserves listBindings.

## Alternatives considered

### Refuse and document

Ship only `'strict'` mode (PR #144's behaviour) and require the holder to mutate the allowlist out of band. This is the do-nothing alternative and it is the right default. The argument for trust-on-first-bind as an opt-in is that interactive agent development is the primary use case for these caps in the near term, and a strict-only cap means the developer alt-tabs to a CLI for every new origin they discover.

### Auto-add with audit log

Always auto-add and log; rely on the holder to review the audit log. This is `'tofu-auto'` as the only mode. Rejected as a default because it converts the allowlist from a host-controlled artifact into a write-once side-effect log; the allowlist no longer protects against agent compromise (a compromised agent can extend its own reach by attempting requests). Acceptable as opt-in for environments where the agent is trusted but the allowlist's role is operational accounting.

### Per-request prompts (no pinning)

Prompt every time, never pin. Rejected because the prompt cost dominates: a chat agent fetching five pages from `api.example.com` would issue five identical prompts. TOFU pins the answer; that is the whole point.

### TLS certificate pinning

A different problem: TOFU on a server's TLS public key, not its allowlist membership. Adjacent and useful but out of scope for the policy-binding question here; documented as future work below.

## Out of Scope, Future Work

- **Per-target attenuators inside a binding.** A binding could carry per-method limits (allow GET but not POST), per-path limits (allow `/repos/*` but not `/users/*`), or per-time-of-day limits. This design treats a binding as a binary gate; richer per-binding policy is a follow-on.
- **Cross-controller policy sharing.** Two `HttpController` instances may want to share a policy table (the user's "trusted origins" set). Out of scope; addressable by minting both controllers from a shared policy-store capability.
- **TLS certificate pinning.** Discussed under alternatives; tracked separately if and when it becomes a question.
- **Default-allow with deny-list.** The inverse posture (start open, pin denials). Not in this design because the capabilities under discussion (HTTP, browser, shell, mount) are explicitly default-deny by taste; an inverted controller is a different design.

## Open Questions

1. **Should `'tofu-prompt'` survive across daemon restart for a pending decision?** If the holder is offline when a prompt arrives, the prompt times out and the binding stays Unknown. An alternative is to persist the pending state and re-prompt on reconnect.
2. **Is the audit log per-controller or per-host?** Per-controller is simpler and matches PR #144's policy storage. Per-host gives a single pane of glass but couples controllers that should be independent.
3. **What does the prompt UI look like in `'tofu-prompt'` mode by default?** CLI prompt blocks the running command; Chat could use `daemon-form-request`; Familiar an Electron dialog. The decision-mode names abstract the surface but the daemon needs one concrete default.
4. **Should audit log entries be exportable as a structured stream** so a higher-level monitoring capability can observe policy decisions across many controllers?
5. **Naming.** `trust-on-first-bind` settled on for the TOFU echo + "bind" matches capability-system vocabulary. Alternatives: "ask-and-pin", "lazy allowlist", "deferred policy".

## Test plan

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
