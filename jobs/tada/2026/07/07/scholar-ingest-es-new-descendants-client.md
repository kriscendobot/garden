Job completed (`doin → tada`). All work is landed and verified. Final report:

---

## Completion report: scholar-ingest-es-new-descendants-client

**Source ingested:** Apple's EndpointSecurity reference `es_new_descendants_client(_:_:)` (macOS 27.0.0+). Fetched via `fetch-source.sh`; the HTML page is JS-rendered, so the idempotency anchor is content SHA-256 `fc069413` over the machine-readable `.md` rendering (`source_kind: web`, snapshot recorded).

### Deliverable 1 — Library ingest
New domain (macOS EndpointSecurity / OS-level process-and-descendant monitoring) got **two new cross-cutting topics** rather than bending the endo-centric taxonomy:
- **`endpoint-security`** (the ES framework) and **`process-monitoring`** (OS-level process+descendant observation/bounding), each with abstract + Sections table, cross-linked to `daemon` and `capability-security`.
- **Source** `web--apple-es-new-descendants-client` with **3 sections**: `client-creation-and-signature`, `descendant-monitoring-semantics` (notify for caller, auth+notify for the recursive descendant tree, all else invisible), `muting-and-client-requirements` (process muting → `ES_RETURN_ERROR`, path muting works; client entitlement but no root, no TCC).
- **2 concepts** (`es-descendants-client`, `auth-vs-notify-events`) + 19 `keywords.md` lines.
- Indexes updated: `topics/README.md`, `concepts/README.md`, `sources/README.md`; `sections/README.md` regenerated (+3), topic counts regenerated (already current).

### Deliverable 2 — Relevance analysis
**One genuine, concrete fit: `endo-but-for-bots`.** Its OS-sandbox design lineage (`daemon-os-sandbox-plugin` → `endo-posix-sandbox`, already in the library) confines/observes daemon-spawned native-tool process subtrees, and the superseded parent design *explicitly named the Endpoint Security framework* as a future macOS backend (should Apple retire `sandbox-exec`/SBPL). `es_new_descendants_client` is exactly that primitive. Wrote `projects/endo-but-for-bots/os-sandbox-endpoint-security.md` documenting the fit **and its honest limits** — a named-but-not-chosen path (the live design picked lima + Apple Containerization for macOS; OS sandboxing is defense-in-depth, not the authoritative CapTP/ocap boundary). Analysis, not advocacy.

**Weak/absent for the rest, stated plainly:** the garden's own fleet is systemd-on-Linux (ES is macOS-only); endo/ocapn/cosgov/agoric-sdk have no OS-level process-monitoring surface. No connection manufactured.

### Verification
`library-link-check.sh --changed` → OK; topic-counts check → current; re-verified `--source-slug` against the landed tip → OK. All 14 files landed via `land-journal-edit.sh` through the producer clone. Result entry `220359Z-result-gardener-04c1b8` posted; job completed `doin → tada`.

**Follow-ups:** none — single compact source fully ingested in one cycle.
