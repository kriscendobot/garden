---
title: Observer tracking strategy per binding granularity
source: packages/gatekeeper-supabase/src/supabase.ts
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/gatekeeper-supabase/src/supabase.ts
source_line_range: "1116-1188"
source_commit: 91c830eb453e8ae65cf186247f7ef961f2275bc9
comment_subject: how a Supabase Gatekeeper tracks observers differently for project versus organization bindings
source_authors: [Nathan Disidore, Dan Carter, Yo'av Moshe]
ingested: 2026-08-24
ingested_by: scholar
topics: [collaborative-workspace-sharing, capability-mediated-integrations, capability-security]
status: current
---

The Supabase Gatekeeper picks its observer-tracking strategy from the bound resource's granularity: a project binding is a single atomic ACL unit (confirm the observer can reach the project, track nothing), while an organization binding tracks which projects the Gadget has actually read and verifies each observer against that accumulating data-set. It is the concrete implementation of the two abstract observer strategies (single-unit ACL check versus data-set tracking) that the observer design enumerates, showing how the atomic-unit choice makes `removeObserver` a no-op and how forward-exclusion runs on the first observation of a new project.

## Two strategies, chosen by binding granularity

An observer is a non-owner collaborator who must independently prove they could have read every external data-set the Gadget observed (the information-flow invariant behind gadget sharing). Supabase implements this two ways depending on what the binding grants access to:

- **Project binding, "ACL check (single unit)".** Arbitrary read-only SQL can read anything in the project's database, so the project is the atomic unit. Verification only confirms the observer can access the project at all (their own `/v1/projects` lists it). Nothing read later could fall outside that unit, so no observers are tracked and `removeObserver` is a no-op.

- **Organization binding, "data-set tracking (by project)".** Org members may have access to different projects, so the connector tracks which projects' data the Gadget has actually observed and verifies each observer against them. `addObserver` requires org membership (so org-level metadata like the project list is safe to show) plus access to every already-observed project. Verified observers are remembered (their verifier is stored) so a later forward-exclusion check can run: the first observation of a *new* project excludes any observer lacking access to it.

The overseer re-runs `addObserver` on every open, catching a collaborator's loss of access promptly rather than only at share time.

## The organization-binding verification loop

`addObserver` for an org binding checks org membership first, then loops over the tracked projects the workspace has read, calling the observer's own verifier (`hasProjectAccess(refs)`) and failing closed with a specific error naming any project the observer cannot reach. Only once every tracked project passes is the observer's verifier persisted under an observer key, so the forward-exclusion pass can later re-consult it. A project binding short-circuits: one `hasProjectAccess([ref])` call and return, storing nothing.

## Translation

| Supabase-connector term | Meaning in the observer model |
|---|---|
| ACL check (single unit) | The bound resource is one atomic authorization unit; membership in it is the whole check. |
| data-set tracking (by project) | The connector accumulates the set of sub-resources actually read and verifies each observer against that set. |
| forward exclusion | A new observation is blocked while any already-authorized observer would be unable to independently read it. |
| overseer | The Gadget-side component that re-runs observer verification on every open. |

Source: [packages/gatekeeper-supabase/src/supabase.ts](https://github.com/cloudflare/cloudflare-os/blob/91c830eb453e8ae65cf186247f7ef961f2275bc9/packages/gatekeeper-supabase/src/supabase.ts) at commit `91c830eb45` (lines 1116-1188).
