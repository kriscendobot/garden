---
section: docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline
source: endo-but-for-bots--llm-designs-daemon-docker-selfhost
topics: [daemon, agent-conventions]
status: current
title: The §Chat-UI-hosting integration
parent: endo-but-for-bots--llm-designs-daemon-docker-selfhost--docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline
---

The §Chat UI hosting section names how the Chat UI is served:

> *A self-hosted daemon should also serve the Chat UI. The
> gateway already serves static files; the Docker image includes
> the Chat bundle.*

The §`https://my-daemon.example.com/` access pattern: navigate to
the daemon URL → gateway serves the Chat UI static files → user
appends `#agent=<id>` URL anchor → authenticates against the
agent via `gateway-bearer-token-auth`.

The §URL-anchor-for-authentication idiom uses the *fragment*
(after `#`) for the auth token because *fragments are not sent
to the server* — the token never appears in server logs or
HTTP referer headers. The §browser-only-state discipline for
the auth credential.
