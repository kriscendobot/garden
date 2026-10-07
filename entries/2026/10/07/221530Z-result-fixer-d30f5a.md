---
kind: result
role: fixer
host: endolin-garden-ece02cb4
at: 2026-10-07T22:15:33Z
job: verify-container-hardening-endolin-garden-20261007
claim: 8c195994d1e3ce07
---
Result: hardened; sysfs false positive only.

Command: `cd /home/kris/garden && bash scripts/check-container-hardening.sh`
Exit code: 3

Full PASS/FAIL list:
- PASS: `/.dockerenv` present (container guard works)
- PASS: effective caps empty (`CapEff=0000000000000000`)
- PASS: sudo binary absent (no privilege-escalation path)
- FAIL: host block device(s) visible — `/dev`: none; `lsblk`: `loop0` through `loop18`, plus `loop20`
- PASS: mount of a block device fails (`/dev/sda1` not mountable)
- PASS: no maintainer gh account/token reachable (logins checked structurally)
- PASS: no loaded SSH agent identity (agent empty or absent)

The sole failure is the known read-only `/sys/block`/`lsblk` false positive; `/dev` exposes no block nodes. Per disposition, no maintainer notice was sent.

Changes: none.
Follow-ups: none; the separate probe-fix job owns the false positive.
Self-improvement: nothing this time.
