from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-23T18:17:48Z
watchdog_key: self-heal-garden-container-hardening
notice_count: 1
first_seen: 2026-09-23T18:17:48Z
last_seen: 2026-09-23T18:17:48Z
---
self-heal: garden-container-hardening exited rc=1 with no scoped fix. Capture: 98400179762a17ff4bffc37e9470aef6858d4142 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 98400179762a17ff4bffc37e9470aef6858d4142). Diagnosis: This is the expected, documented condition, not a bug. Commit `3d453e3078` (the current `HEAD`, landed ~68 minutes ago) hardened the `garden` launcher and Dockerfile to drop `--privileged` and bot-user sudo, but per its own commit message and `context/operations/harden-container.md`, **the change takes effect only on container recreation** — "no flag day; recreate host by host." This host's container (`endolin-garden-ece02cb4`) is still running the old, privileged image/launch flags, so the twice-daily `garden-container-hardening` probe correctly still fails its two posture checks (`sudo -n true` succeeds, host block devices visible) exactly as the doc anticipates. The other five checks (including the maintainer-gh-credential check the commit message flagged as a separate concern) alread
