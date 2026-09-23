---
section: registry-shape-and-subscription-oauth-with-lal-vs-genie-consolidation-question
source: endo-but-for-bots--llm-designs-endopi-provider-registry-and-oauth
topics: [agent-conventions]
status: current
title: §Subscription OAuth — *authorization-code-with-PKCE*
parent: endo-but-for-bots--llm-designs-endopi-provider-registry-and-oauth--registry-shape-and-subscription-oauth-with-lal-vs-genie-consolidation-question
---

The §Subscription OAuth subsection is *the headline feature*. The
core mechanism:

> *A separate auth-storage exo holds OAuth credentials per
> provider, keyed by provider name and account ID. The OAuth flow
> is the standard authorization-code-with-PKCE path; the redirect
> URI is a Familiar pane (in the Electron build) or a local HTTP
> listener bound to `127.0.0.1` (in the daemon-only build, per
> [gateway-bearer-token-auth](gateway-bearer-token-auth.md)).*

Two structurally interesting moves:

1. **The §dual-redirect-URI discipline**: Familiar pane in the
   Electron build (uses cycle 109's electron-shell's
   `localhttp://` protocol and `protocol.handle` to intercept the
   OAuth redirect); local HTTP listener bound to 127.0.0.1 in the
   daemon-only build (uses cycle 111's familiar-gateway-migration's
   gateway server). Both paths satisfy the OAuth spec's
   *registered-redirect-URI* requirement without forcing a public
   HTTPS endpoint.

2. **The §encrypted-at-rest credential discipline**:
   > *Credentials are stored encrypted at rest, in the same store
   > as the formula graph, with the encryption key derived from
   > the host's passphrase or a hardware key per the existing
   > daemon pattern.*

   The §key-derivation-from-host-passphrase-or-hardware-key is the
   *existing-daemon-pattern* discipline; OAuth tokens get the same
   treatment as any other secret in the formula graph.

The §Out of scope explicitly declines Pi's auth-file shape:

> *Pi stores OAuth tokens under `~/.pi/agent/auth/`; Endo's store
> lives in the formula graph. We do not import Pi's auth file
> shape because the secrets boundary is different (the Endo store
> is encrypted; Pi's may or may not be).*

The §secrets-boundary-is-different rationale is the
*don't-adopt-Pi's-weaker-storage* discipline — unlike cycle 117's
adoption of Pi's JSONL transcript format (where Pi's storage shape
is *fine* and only needs Endo extensions), OAuth tokens are
*sensitive enough that Endo's encrypted store is mandatory*. The
authorship-shape gets adopted; the storage-shape doesn't.
