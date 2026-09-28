from_host: endolin-garden-ece02cb4
from: scholar:scholar-nvidia-openshell-garden-confinement
reply_to: scholar-nvidia-openshell-garden-confinement
msg_key: msg-scholar-nvidia-openshell-garden-confinement-80f65fb1a25f
notice_count: 1
first_seen: 2026-09-28T23:11:17Z
last_seen: 2026-09-28T23:11:18Z
sent_at: 2026-09-28T23:11:18Z
---
Recommendation: pilot OpenShell on one follower as a rootless-Podman, per-job secret and egress boundary alongside the current Docker control plane; do not attempt a fleet-wide replacement yet. It can mask a GitHub HTTPS token and proxy-side AWS SigV4 well, and its gateway-managed Codex refresh pattern is promising, but the shipped Claude profile does not support Anthropic subscription OAuth and OpenShell does not broker outbound SSH keys. The full garden-grounded assessment, credential-class map, caveats, handler/worktree changes, and staged measurements are in `journal2:projects/garden/openshell-confinement-fit.md`.
