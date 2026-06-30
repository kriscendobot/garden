Done. Both phases landed and verified. Final report:

---

**Job complete: `scholar-ingest-tailscale-oauth-apps-and-oauth-skills`**

**Phase 1 — library ingest (journal2).** The named URL (`/docs/features/oauth-apps`) is the *authorization-code / user-identity* half of Tailscale's OAuth surface; the job's Phase-1 bullets (scoped clients, client-credentials, tag→capability, short-lived tokens from a durable client) actually describe the sibling *oauth-clients* page. To capture the model faithfully I ingested **both** sibling pages (one cycle's budget: 2 web sources, 5 sections), both fetched `direct` via `fetch-source.sh`:

- **`web--tailscale-oauth-clients`** (sha256 `52287f51…`, 3 sections): client-credentials grant + scope→endpoint least-privilege map + hourly-token lifecycle; tags-as-capabilities + `auth_keys` minting + `get-authkey`/`tailscale up`; client setup + secret-shown-once + tailnet-owned durability.
- **`web--tailscale-oauth-apps`** (sha256 `5049588b…`, 2 sections; alpha): user-delegated authorization-code model + the explicit apps-vs-clients decision contrast; requirements + single-tailnet boundary + non-customizable consent.

New topic **`oauth-credentials`** (5 sections); new concept **`oauth-client-credentials-vs-authorization-code`** + 17 keyword aliases. Indexes updated (`sources/README.md` +2, `topics/README.md` +1, `concepts/README.md` +1, `keywords.md` +17), all via `land-journal-edit.sh`. Integrity gate clean on both clusters; `regenerate-sections-index` landed the rebuilt flat index; topics-counts already current (new topic's 5 matched). Result entry: `entries/2026/06/30/234719Z-result-gardener-391fc1.md`.

**Phase 2 — skill (main2).** Authored **`skills/oauth-use-case-patterns/SKILL.md`** (commit `51698a16d`, pushed `HEAD:main2`): a design-time identify-and-apply playbook — recognition signals, the client-credentials-vs-authorization-code grant-choice table, apply steps (least-privilege scope/tag mapping, capture-secret-once, live-read-over-file-baked storage, mint/rotate short-lived tokens, revocation-as-retirement), and failure modes. Grounded in the just-ingested Tailscale model and tied to the garden's existing OAuth touchpoint (`designs/fleet-gh-identity.md` live-read bot token) and plausible future ones (multibot tailnet node provisioning via `auth_keys` clients; web-surface user-delegated OAuth). A full skill was warranted, not a thin follow-on.

**Follow-ups.** None posted (the two pages cover the model; their Scopes sections only redirect to a distinct trust-credentials page). One self-improvement note sent to the liaison's inbox: add the new skill's row to CLAUDE.md's "Current inventory" — a gardener authoring under a job can't edit that top-level meta-doc itself.

Self-improvement: routed to liaison — when a job directs a gardener to author a new skill on main2, the gardener cannot index it in CLAUDE.md's skills inventory (top-level meta edit reserved for liaison), so the inventory row is a standing loose end worth a deterministic hand-off.
