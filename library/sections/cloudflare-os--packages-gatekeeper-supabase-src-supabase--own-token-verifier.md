---
title: Verifier answers access against the observer's own token
source: packages/gatekeeper-supabase/src/supabase.ts
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/gatekeeper-supabase/src/supabase.ts
source_line_range: "661-694"
source_commit: 91c830eb453e8ae65cf186247f7ef961f2275bc9
comment_subject: the minted verifier runs access checks against the prospective observer's own Supabase token, not the Gadget's
source_authors: [Nathan Disidore, Dan Carter, Yo'av Moshe]
ingested: 2026-08-24
ingested_by: scholar
topics: [collaborative-workspace-sharing, capability-mediated-integrations, capability-security]
status: current
---

Observer verification asks whether a *prospective* observer could independently read the data the Gadget saw, so the check must run against the observer's own credentials rather than the Gadget's. The Supabase connector answers this by having each account mint a verifier carrying that user's own account id: the verifier's `hasProjectAccess` / `hasOrgAccess` calls resolve against the observer's own Supabase token, so a positive result means the observer genuinely has independent access, not merely that the Gadget does.

## Minting a per-account verifier

`getVerifier()` returns a `SupabaseVerifier` facet whose props carry only `userObjectId` (the observer's account). It is handed by the overseer to a Supabase gatekeeper's `addObserver`, which confirms the prospective observer may read a bound project (and, for org bindings, the org and every already-accessed project). Because the verifier carries the observer's own account id, the access checks run against the observer's own token, not the Gadget's.

## Two questions, answered from list endpoints

Both strategies reduce to two per-observer access questions, each answered against the observer's own token by a Management-API list call that returns exactly what that token can reach:

- `hasProjectAccess(refs)`: the Management API's `/v1/projects` returns exactly the projects the calling token can reach, so one response can check every requested ref.
- `hasOrgAccess(slug)`: likewise `/v1/organizations` lists the orgs the token belongs to.

The overseer only ever hands this verifier back to a Supabase gatekeeper, which may therefore trust the boolean results. `SupabaseVerifierApi` extends the generic `GatekeeperUserVerifier` with these two non-standard methods, which are specific to the Supabase gatekeeper's own observer strategy and not part of the generic verifier contract.

Source: [packages/gatekeeper-supabase/src/supabase.ts](https://github.com/cloudflare/cloudflare-os/blob/91c830eb453e8ae65cf186247f7ef961f2275bc9/packages/gatekeeper-supabase/src/supabase.ts) at commit `91c830eb45` (lines 661-694).
