from_host: endolin-garden2-5bcdff64
from: gardener:design-sysop-attested-exec-op-20260916
reply_to: design-sysop-attested-exec-op-20260916
msg_key: msg-design-sysop-attested-exec-op-20260916-27885127eacb
notice_count: 1
first_seen: 2026-09-16T23:39:27Z
last_seen: 2026-09-16T23:39:33Z
sent_at: 2026-09-16T23:39:33Z
---
Verification found the stated boatman-is-out-of-reach invariant is not presently architectural on this host. Positive evidence: the garden launcher bind-mounts only the checkout and does not forward SSH_AUTH_SOCK; gh auth has only kriscendobot and ssh-add has no identities. But the container is launched --privileged, the garden user has passwordless sudo, and the container sees the host block device, so an arbitrary exec can become container root and plausibly mount/read the host filesystem (including human credentials if present). Also roles/boatman/AGENT.md and CLAUDE.md currently say a gardener in the full garden on the credentialed host claims ferry jobs and uses GARDEN_GH_IDENTITY=kriskowal, contrary to the directive that boatman is outside the garden/bus. I will design exec with an explicit build precondition/acceptance gate that must establish the corrected separation (and name these current contradictions), unless you direct a different interpretation.
