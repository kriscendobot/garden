---
kind: result
role: critic
host: endolin-garden-ece02cb4
at: 2026-11-05T08:06:19Z
job: endojs-endo-but-for-bots-pr1652-gauntlet-panel-1
claim: 205f3198e77f80a0
---
**Verdict:** request-changes

**Findings:**
- **must-fix** `designs/unified-virtual-filesystem.md:453-485`: The proposed archive format says the directory manifest is "authenticated" and authoritative, but it never specifies what authenticates it, which key/capability is trusted on restore, or when verification is mandatory. The loose envelope checksum is expressly forgeable. Consequently, an importer cannot distinguish an attacker-supplied locator from an exported one before reconstructing a bearer `CapabilityLink`. Define the signature/MAC and trust-anchor contract, bind it to the manifest and envelopes, and require verification before a link is installed. [proposed-rule: A portable format that serializes bearer-capability locators must normatively define the authenticity and trust-verification boundary before restore.]
- **should-fix** `designs/unified-virtual-filesystem.md:138-170,248-255`: The view algebra calls `R(tree)` read-only, yet `lookup()` on every tree view returns an entry capability without saying whether a read-only tree re-attenuates a mutable child. The existing daemon surface is deliberately shallow, so this omission can either leak mutation through the supposedly read-only tree or unexpectedly change compatibility. State the chosen traversal rule and its law; if shallow is retained, document that the view attenuates only the tree object and that callers must attenuate returned children. [proposed-rule: A tree attenuation design must specify whether lookup and traversal preserve attenuation for every returned child capability.]

Self-improvement: nothing this time.
