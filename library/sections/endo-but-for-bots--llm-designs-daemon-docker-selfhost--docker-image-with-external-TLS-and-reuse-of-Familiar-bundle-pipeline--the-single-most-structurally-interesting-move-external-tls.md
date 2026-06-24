---
section: docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline
source: endo-but-for-bots--llm-designs-daemon-docker-selfhost
topics: [daemon, agent-conventions]
status: current
title: The single most structurally interesting move — §external TLS
parent: endo-but-for-bots--llm-designs-daemon-docker-selfhost--docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline
---

The §External TLS discipline is the design's load-bearing
choice:

> *TLS termination is handled externally. The daemon speaks
> plain HTTP/WebSocket inside the container. Users place a
> reverse proxy (nginx, Caddy, Traefik, cloud load balancer) in
> front for TLS. This is the standard Docker pattern and avoids
> bundling certificate management into the daemon.*

Three claims compose:

1. **The standard Docker pattern** — TLS is a *proxy concern*,
   not an *application concern*. Caddy, nginx, Traefik, and
   cloud LBs all do this; the daemon shouldn't.
2. **Avoids bundling certificate management** — Let's Encrypt
   renewal, OCSP stapling, modern TLS suite selection, etc.
   are *non-trivial* and *moving targets*. Outsourcing to a
   reverse proxy keeps the daemon out of that scope.
3. **A future enhancement could add `--tls-cert` and `--tls-key`
   flags** — but *not required for the initial Docker image*.
   The §don't-build-it-now-could-build-it-later discipline.

The §design-as-deferral pattern: rather than building TLS
*into* the daemon, the design *defers* TLS to the deployment
pipeline. The §each-layer-handles-its-concern discipline.
