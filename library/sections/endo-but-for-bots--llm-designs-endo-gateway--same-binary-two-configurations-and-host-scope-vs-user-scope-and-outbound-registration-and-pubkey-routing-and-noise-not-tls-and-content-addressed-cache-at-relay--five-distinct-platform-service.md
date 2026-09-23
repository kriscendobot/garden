---
title: §five-distinct-platform-service-manager-targets (first-explicit-observation)
section-slug: endo-but-for-bots--llm-designs-endo-gateway--same-binary-two-configurations-and-host-scope-vs-user-scope-and-outbound-registration-and-pubkey-routing-and-noise-not-tls-and-content-addressed-cache-at-relay
source-slug: endo-but-for-bots--llm-designs-endo-gateway
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endo-gateway.md
authors: [Kris Kowal (prompted)]
status: Proposed
created: 2026-05-10
updated: 2026-05-10
ingest-cycle: 283
ingest-date: 2026-06-10
lane: designs
scope: full
total-lines: 997
parent: endo-but-for-bots--llm-designs-endo-gateway--same-binary-two-configurations-and-host-scope-vs-user-scope-and-outbound-registration-and-pubkey-routing-and-noise-not-tls-and-content-addressed-cache-at-relay
---

The design enumerates **five named platform-service-manager-targets** for the Gateway:

1. **Linux**: systemd unit (`endo-gateway.service`).
2. **macOS**: launchd `LaunchDaemon` plist under `/Library/LaunchDaemons/`.
3. **Windows**: Windows Service via `sc.exe` or SCM API.
4. **Container** (Docker / Podman / Kubernetes): no platform service manager inside the container; the **container runtime IS the service manager**.
5. **AppImage**: cannot install system services directly; offers Gateway only as a "save this unit file and `systemctl --user link` it" prompt, not a one-click install.

**§the-`Platform service management IS the supervisor`-principle as named architectural-decision** (first-explicit-observation): "The Gateway does not implement its own singleton enforcement beyond what the platform's service manager already provides. systemd on Linux, launchd on macOS, the Service Control Manager on Windows, the container runtime in containers; each enforces 'one instance' by being the thing that started it." This is **the-singleton-is-the-thing-that-started-the-process**, not a lock file, not a PID file, not a discovery dance — *whoever started me is the singleton enforcer*.

**§the-platform-singleton-by-supervisor pattern** (first-explicit-observation): instead of carrying singleton-enforcement code, the design points at five external supervisors and declares "one of these will be running; that's where the singleton-ness lives". **Pushes the responsibility outward to the platform**, keeping the binary state-light.
