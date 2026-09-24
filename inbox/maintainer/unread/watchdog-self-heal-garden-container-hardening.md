from_host: endolin-garden2-5bcdff64
from: watchdog:self-heal-claude
sent_at: 2026-09-24T06:17:32Z
watchdog_key: self-heal-garden-container-hardening
notice_count: 1
first_seen: 2026-09-24T06:17:32Z
last_seen: 2026-09-24T06:17:32Z
---
self-heal: garden-container-hardening exited rc=1 with no scoped fix. Capture: 1b6d969846bace100616d1970de211749cd332c4 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 1b6d969846bace100616d1970de211749cd332c4). Diagnosis: I'm not posting a fix job. The probe found a real problem, but the fix is to recreate the container on the host, not to change any code.

**What happened.** `scripts/check-container-hardening.sh` passed 5 checks and failed 2:
- **`sudo -n true` succeeded**, so passwordless privilege escalation is available.
- **The host's disks are visible in `/dev`** (`/dev/sda*`, `/dev/nvme0n1*` and loop devices).

**Why.** This container was built from the old privileged launcher and image:
- `/.dockerenv` shows the container was created at 2026-09-23 16:09:39Z.
- Commit `3d453e30784` ("harden(container): drop --privileged and bot-user sudo") landed on `main2` at 17:09:38Z, one hour later. The container never picked it up.
- `/proc/self/status` confirms it is still privileged: `CapBnd: 000001ffffffffff`
