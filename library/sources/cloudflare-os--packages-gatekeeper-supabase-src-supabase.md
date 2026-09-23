---
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/gatekeeper-supabase/src/supabase.ts
source_line_range: "661-1188"
source_commit: 91c830eb453e8ae65cf186247f7ef961f2275bc9
comment_subject: observer-tracking strategy and own-token verification in the Supabase Gatekeeper
source_authors: [Nathan Disidore, Dan Carter, Yo'av Moshe]
ingested: 2026-08-24
ingested_by: scholar
section_count: 2
status: current
---

The Supabase Gatekeeper's `supabase.ts` carries longform comments on how it verifies observers for shared Gadgets. It chooses an observer-tracking strategy from the bound resource's granularity (single-unit ACL check for a project binding, data-set tracking by project for an organization binding) and answers every access question against the *prospective observer's own* Supabase token via a minted verifier. Two sections cover the strategy selection and the own-token verifier; both are implementation-side detail behind the abstract observer strategies described in `docs/observers.md`.

| Section | Topics | Status |
|---------|--------|--------|
| [Observer tracking strategy per binding granularity](../sections/cloudflare-os--packages-gatekeeper-supabase-src-supabase--observer-tracking-strategy.md) | collaborative-workspace-sharing, capability-mediated-integrations, capability-security | current |
| [Verifier answers access against the observer's own token](../sections/cloudflare-os--packages-gatekeeper-supabase-src-supabase--own-token-verifier.md) | collaborative-workspace-sharing, capability-mediated-integrations, capability-security | current |
