---
title: Policy storage (HttpController surface) + Revocation interaction
source: designs/trust-on-first-bind.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 337329bdd0cee6c9f30b6dc593684e8823455e09
source_date: 2026-05-10
source_authors: [Kriscendo Bot]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security, exo, persistence]
status: current
notes: The revokeBinding vs unpin distinction is load-bearing: revokeBinding records active refusal that survives a re-prompt (the holder said "never"); unpin says "I was wrong, ask me again." Pin revocation does NOT abort in-flight requests that have already passed the policy check — that's intentional permissiveness; if the holder needs hard abort, they revoke the whole cap via the existing `control.revoke()`.
---

> Abstract: **Policy storage**: the controller's `control` facet exposes the policy table. New methods over PR #144: **listBindings()** returns `Array<{target, state: 'Pinned-Allow'|'Pinned-Deny'|'Revoked', decidedAt: ms-epoch, decidedBy: human-id, decisionMode, note?}>`; **revokeBinding(target)** records active refusal; **unpin(target)** demotes to Unknown so next request re-prompts; **setPolicyMode(mode)** changes the live mode. Storage lives wherever the controller's other policy lives — for HttpController, the same SQLite-backed formula store the daemon uses. **No new persistence layer**. **Revocation interaction** has two scopes: **(1) Pin revocation** (`revokeBinding`): pin moves to Revoked; in-flight requests already past the policy check continue to completion; new requests refused. **(2) Cap revocation** (existing `control.revoke()` from PR #144): whole controller dies; in-flight requests abort via existing AbortController plumbing; policy table preserved on disk for future controller minting. The in-flight-permissive choice is intentional — the alternative (per-request AbortController in the policy state) complicates request shape for an edge case; if hard abort is needed, revoke the cap.

### Policy storage

The controller's `control` facet exposes the policy table:

```ts
interface HttpController {
  // existing PR #144 surface
  setAllowedOrigins(origins: string[]): void;
  // …
  // new with trust-on-first-bind
  listBindings(): Array<{
    target: string;
    state: 'Pinned-Allow' | 'Pinned-Deny' | 'Revoked';
    decidedAt: number;        // ms epoch
    decidedBy: string;        // human identifier (user pet name, etc.)
    decisionMode: 'strict' | 'tofu-prompt' | 'tofu-auto' | 'tofu-attenuator';
    note?: string;            // optional reviewer comment
  }>;
  revokeBinding(target: string): void;
  unpin(target: string): void; // demote to Unknown; next request re-prompts
  setPolicyMode(mode: 'strict' | 'tofu-prompt' | 'tofu-auto' | 'tofu-attenuator'): void;
}
```

`listBindings` is the audit surface; `revokeBinding` and `unpin` are the two revocation knobs. The distinction matters: `revokeBinding` records an active refusal that survives a future prompt round (the holder said "never"), `unpin` says "I was wrong, ask me again next time".

Storage lives wherever the controller's other policy lives. For `HttpController` that is the same persisted state as `allowedOrigins`/`maxRequestsPerMinute`, which means the SQLite-backed formula store the daemon already uses for cap state. No new persistence layer.

### Revocation interaction

Revocation in trust-on-first-bind has two scopes:

1. **Pin revocation** (`revokeBinding`). The pin moves to `Revoked`. In-flight requests that have already passed the policy check continue to completion; the request that triggered the pin is past the check before the network call begins. New requests for that target are refused.
2. **Cap revocation** (the existing `control.revoke()` from PR #144). The whole controller goes dead; in-flight requests abort via the existing AbortController plumbing PR #144 already wires. The policy table is preserved on disk so a future controller minted from the same configuration can re-load the bindings (or the holder can choose to discard them).

The "in-flight at the moment of pin revocation" case is intentionally permissive: the alternative is to wire an AbortController per request into the policy state, which complicates the request shape for an edge case (a target was Pinned-Allow at request start; the holder revoked it during the network roundtrip). If the holder needs to abort in-flight requests, they revoke the cap.

Source: [designs/trust-on-first-bind.md](https://github.com/endojs/endo-but-for-bots/blob/337329bdd0cee6c9f30b6dc593684e8823455e09/designs/trust-on-first-bind.md) at commit `337329bd` on branch `llm`.
