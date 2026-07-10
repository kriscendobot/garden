---
role: designer
---

role: designer
---

# Design: the gateway OAuth (redirect) flow — per cloud provider

Repo: endojs/endo-but-for-bots (base branch `llm`).

Plan the gateway OAuth flow: how a remote, headless Endo daemon runs the
authorization-code redirect flow when the user's browser and the daemon
do not share a machine. This is Open Question 1 of
`designs/endoclaw-oauth.md` — the redirect must land on a URL the user's
browser can reach (a gateway route registered as a web-application
redirect URI), and the loopback listener is insufficient for remote
hosts.

Ground already broken: there is a potential design direction in
minion.town. The maintainer's finding is that the solution is **very
specific to the cloud provider**, so produce **separate but coherent
narratives**, one per provider:

- **AWS Endo Gateway** OAuth flow
- **CloudFlare Endo Gateway** OAuth flow
- **Netlify Endo Gateway** OAuth flow

They should share the common contract (redirect URI shape, PKCE, how the
minted token flows back into the daemon's token store, how consumers stay
oblivious per Design Decision 2) while each documents the provider's
specific hosting/redirect/routing mechanics. Relate to
`designs/daemon-web-gateway.md` and the endoclaw-oauth first-mint plumbing.

Deliverable: the three coherent design narratives (separate docs or one
doc with three clearly delineated provider narratives), each a solid
foundation the gateway route can be built on when public hosting (M5)
lands.

Origin: maintainer review directive on endojs/endo-but-for-bots#621
(inline comment 3560264811). Filed by a gardener resolving that review.
