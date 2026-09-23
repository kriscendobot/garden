---
id: ad-hominem-security
aliases: [ad hominem security, trusted by whom, trusted computing, trusted PC, Palladium, who wrote the code]
topics: [capability-security, capability-theory]
---

# ad-hominem-security

Norman Hardy's strategic pejorative (cap-talk, 2002) for the premise, associated with Microsoft's Palladium / "trusted computing" initiative, that security is achieved by knowing the *author* of the code that runs on your machine: authenticate who wrote code and admit code from trusted authors. Hardy names it "ad hominem" by analogy to the fallacy of judging a claim by its source rather than its content. The capability position is the contrast: confine what code can *do* (grant it only the authority it needs), so that even untrusted-authorship code can be run safely, rather than gating whether to run code on who signed it. Ka-Ping Yee's paired framing is "trusted by whom?": a machine should reliably carry out the wishes of its *owner*, not its manufacturer, and "trusted PC" gatekeeping converts reliability into manufacturer control over what the user may run.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cap-talk-2002-2003--ad-hominem-security-trusted-by-whom](../sections/cap-talk-2002-2003--ad-hominem-security-trusted-by-whom.md) | Hardy's coinage and Yee's NYT letter on owner-control versus manufacturer-control. |

## See also

- [[object-capability]] — the confine-what-code-can-do alternative to authenticating who wrote it.
- [[capabilities-vs-acls]] — identity-based (who is asking) versus designation-based authorization, the same axis one level down.
