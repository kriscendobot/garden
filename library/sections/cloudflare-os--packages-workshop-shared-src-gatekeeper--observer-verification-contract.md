---
title: Observer verification across past and future reads
source: packages/workshop-shared/src/gatekeeper.ts
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-shared/src/gatekeeper.ts
source_line_range: "674-795"
source_commit: 2c9d59098d852370f27882702dd39a159b3c12f5
comment_subject: opaque same-provider verifier capabilities establish a collaborator's right to historical observations and constrain later observations
source_authors: [Kenton Varda, "Yo'av Moshe", Phillip Jones, Nathan Disidore]
ingested: 2026-08-24
ingested_by: scholar
topics: [collaborative-workspace-sharing, capability-mediated-integrations, capability-security]
status: current
---

A prospective gadget observer supplies a verifier minted by their own account, but the Overseer promises to return it only to the same Gatekeeper family that created it. `addObserver()` must first prove that this person may see everything already observed through the binding; after admission, every future read must either remain compatible or name the observer in `excludeObservers`. Re-adding an existing identifier repeats the check so revoked provider access cannot survive indefinitely.

## Opaque verifier boundary

`GatekeeperUserVerifier` is intentionally opaque to the Workshop. The provider may temporarily expose a non-standard method on its verifier because the runtime cannot yet unwrap a returned `Fetcher`, but only the originating Gatekeeper is allowed to call that method and trust its result. The Overseer routes the capability without learning provider credentials or access details.

The observer identifier is stable within the gadget but otherwise opaque. It lets the Gatekeeper retain only the state needed for later exclusion decisions.

## Historical and forward checks

Admission is retrospective: success means the user may see all data the gadget already learned through this Gatekeeper. The implementation can use a broad resource ACL when that accurately covers the binding, or retain the narrower set of facts actually observed. The latter matters for broad private resources. A mailbox owner may not be able to share the whole inbox, while messages from one mailing list may be safe for every list member.

Admission is also prospective. Once an observer is recorded, later observations incompatible with that observer must carry `excludeObservers`, allowing the Overseer either to prove the person can no longer see the relevant thread or to block the read. `removeObserver()` ends this tracking obligation and must be idempotent so sharing-graph reconciliation can retry safely.

Source: [packages/workshop-shared/src/gatekeeper.ts](https://github.com/cloudflare/cloudflare-os/blob/2c9d59098d852370f27882702dd39a159b3c12f5/packages/workshop-shared/src/gatekeeper.ts) at commit `2c9d59098d` (lines 674-795).
