---
title: §weblet-profiles-guest-plus-handle (the §four-step-install)
source-slug: endo-but-for-bots--llm-designs-familiar-chat-weblet-hosting
section-id: two-part-status-and-iframe-sandbox-confinement-and-four-step-weblet-install-and-two-CapTP-transports-and-five-section-considerations
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/familiar-chat-weblet-hosting.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/familiar-chat-weblet-hosting.md
status: Not Started (with ready Familiar-side infrastructure)
ingest-cycle: 218
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-familiar-chat-weblet-hosting--two-part-status-and-iframe-sandbox-confinement-and-four-step-weblet-install-and-two-CapTP-transports-and-five-section-considerations
---

```
1. Create a guest for the weblet:
   E(host).provideGuest(handlePetName, { agentName: webletAgentName })
2. Endow the guest with capabilities the user selects.
3. Install the weblet in the guest's worker.
4. Register the weblet with the unified server under the guest's handle identifier.
```

§Each-weblet-has-four-things:
- Its own pet store.
- Its own mailbox.
- Its own handle.
- Only the capabilities the host user explicitly granted.

§Borrowable-pattern: §guest-as-the-unit-of-application-installation — §the-application-IS-the-guest. §Sibling to cycle 210 lal-fae-form-provisioning's §inbox-as-durable-config-store; both designs use §existing-Endo-primitives-(guest + provideGuest + endow) as the §application-installation-substrate.
