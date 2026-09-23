---
title: §Publishing-flow as §send-to-registry-operator
source-slug: endo-but-for-bots--llm-designs-endoclaw-skill-registry
section-id: no-new-abstractions-and-capability-declaration-via-directory-structure-and-decentralized-by-default-and-federation-by-reference
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-skill-registry.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-skill-registry.md
total-lines: 252
status: Not Started
ingest-cycle: 222
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-skill-registry--no-new-abstractions-and-capability-declaration-via-directory-structure-and-decentralized-by-default-and-federation-by-reference
---

```bash
# Author creates descriptor
endo make-directory gmail-bridge-descriptor

# Populate metadata
endo store "Read and manage Gmail via OAuth" --name description-text
endo write gmail-bridge-descriptor description description-text
# ... (more population) ...

# Send to registry operator for review
endo send registry-operator "Please list gmail-bridge" \
  --attach gmail-bridge-descriptor:gmail-bridge-descriptor

# Registry operator reviews and adds
endo adopt <message> gmail-bridge-descriptor submitted-gmail-bridge
endo write skills gmail-bridge submitted-gmail-bridge
```

§The-publishing-flow-is-a-mail-message-with-attachment. §Borrowable-pattern: §publishing-as-a-mail-message-not-an-RPC. §The-registry-operator-receives-the-descriptor-as-an-Endo-message + §reviews-it + §adds-it. §No-special-publish-API-needed.

§Two-actors-with-different-roles: §author (creates and sends) + §operator (receives and adds). §The-mail-message-is-the-handoff-point.
