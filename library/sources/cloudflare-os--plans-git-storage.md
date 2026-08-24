---
source: plans/git-storage.md
source_repo: cloudflare/cloudflare-os
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
source_date: 2026-08-21
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
section_count: 7
status: current
notes: Three-part implementation plan; Parts 2 and 3 supersede transitional choices inside Part 1 before deployment.
---

This plan moves gadget code from workspace-wide Yjs history into Git objects, refines chat state to lazy per-gadget pins and epochs, then replaces Yjs with an operational-transform revision protocol and CodeMirror client.

| Section | Topics | Status |
|---------|--------|--------|
| [Git object store and commit model](../sections/cloudflare-os--plans-git-storage--git-object-store-and-commit-model.md) | persistence, ai-generated-apps, cloudflare-workers-agent-hosting | current |
| [commit-backed chat merge and migration](../sections/cloudflare-os--plans-git-storage--commit-backed-chat-merge-and-migration.md) | persistence, collaborative-workspace-sharing, ai-generated-apps | current |
| [lazy per-gadget pinning and epochs](../sections/cloudflare-os--plans-git-storage--lazy-per-gadget-pinning-and-epochs.md) | persistence, collaborative-workspace-sharing, ai-generated-apps | current |
| [deterministic Yjs seeds and reserved client IDs](../sections/cloudflare-os--plans-git-storage--deterministic-yjs-seeds-and-reserved-client-ids.md) | collaborative-workspace-sharing, testing, persistence | current |
| [operational-transform change model](../sections/cloudflare-os--plans-git-storage--operational-transform-change-model.md) | collaborative-workspace-sharing, persistence, testing | current |
| [revision epochs, stragglers, and materialization](../sections/cloudflare-os--plans-git-storage--revision-epochs-stragglers-and-materialization.md) | collaborative-workspace-sharing, persistence, cloudflare-workers-agent-hosting | current |
| [CodeMirror client and delivery sequence](../sections/cloudflare-os--plans-git-storage--codemirror-client-and-delivery-sequence.md) | collaborative-workspace-sharing, testing, repository-governance | current |
