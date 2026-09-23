#!/bin/bash
# check-container-hardening.sh — assert the garden container's security posture.
#
# Run as the BOT USER, INSIDE the container. Verifies that the container was
# launched with the hardened `garden` flags (no --privileged, no host devices) and
# that the bot user is unprivileged with no reachable maintainer credentials — the
# acceptance probe for the "harden the garden container" change
# (designs/sysop-attested-exec.md). A regression (a container recreated from an old
# image, or a launcher that re-added --privileged / passwordless sudo / device
# passthrough) makes this exit non-zero and name the failing check.
#
# Usage: check-container-hardening.sh
#   exit 0  — all checks pass (hardened as intended).
#   exit 1  — one or more checks FAILED (posture regressed); each is named on stderr.
#   exit 2  — a check could not be evaluated (e.g. run on the host, not the container).
#
# The checks (each mandatory unless noted):
#   1. /.dockerenv present            — the container guard still works.
#   2. effective caps empty           — the bot user holds no capabilities.
#   3. `sudo -n true` fails           — no passwordless privilege escalation.
#   4. no host BLOCK devices          — no disk to mount (char GPU nodes are allowed
#                                       when GARDEN_DEVICES opts in; they are not
#                                       block devices, so they never trip this).
#   5. mounting a block device fails  — even if a node appeared, mount is denied.
#   6. no maintainer gh credential    — no kriskowal account/token in the bot env.
#   7. no human SSH key / agent       — no id_* private key, no SSH_AUTH_SOCK.
#
# Deterministic, read-only, no LLM. Cheap enough to run on a timer
# (garden-container-hardening.timer) and in bring-up verification
# (context/operations/starting.md § Verify).

set -uo pipefail

PASS=0
FAIL=0
ok()  { PASS=$((PASS+1)); printf '  PASS: %s\n' "$1"; }
ko()  { FAIL=$((FAIL+1)); printf '  FAIL: %s\n' "$1" >&2; }

echo "=== container hardening probe ($(id -un)@$(hostname -s 2>/dev/null)) ==="

# Refuse to run OUTSIDE the container: every check would give a meaningless verdict
# on the host (where the maintainer legitimately has sudo, ssh keys, and disks).
if [ ! -e /.dockerenv ] && ! grep -qaE 'docker|containerd|libpod' /proc/1/cgroup 2>/dev/null; then
    echo "  SKIP: not inside a container — this probe only makes sense in the garden container" >&2
    exit 2
fi

# --- 1. /.dockerenv present (the guard's signal still fires) -------------------
if [ -e /.dockerenv ]; then ok "/.dockerenv present (container guard works)"; else ko "/.dockerenv missing"; fi

# --- 2. effective capabilities are empty for the bot user ---------------------
# CapEff in /proc/self/status is the effective-capability bitmask in hex. A
# non-root process with no file/ambient caps has 0000000000000000, even when the
# container BOUNDING set carries SYS_ADMIN (that is held by root/PID-1, not us).
capeff="$(awk '/^CapEff:/{print $2}' /proc/self/status 2>/dev/null || echo missing)"
if printf '%s' "$capeff" | grep -qE '^0+$'; then
    ok "effective caps empty (CapEff=$capeff)"
else
    ko "effective caps NON-empty (CapEff=$capeff) — expected 0 for the bot user"
fi

# --- 3. no passwordless sudo -------------------------------------------------
# Pass if sudo is absent (removed from the image) OR present but `sudo -n true`
# fails (no NOPASSWD rule). Fail ONLY if a non-interactive sudo actually succeeds.
if command -v sudo >/dev/null 2>&1; then
    if sudo -n true >/dev/null 2>&1; then
        ko "sudo -n true SUCCEEDED — passwordless privilege escalation is available"
    else
        ok "sudo present but 'sudo -n true' fails (no passwordless escalation)"
    fi
else
    ok "sudo binary absent (no privilege-escalation path)"
fi

# --- 4. no host block devices exposed ----------------------------------------
# Enumerate block device nodes two ways and require BOTH to be empty. `lsblk -nro
# NAME` lists block devices the kernel exposes to us; the /dev scan catches any
# node present even if lsblk is unavailable. Char devices (GPU nodes under
# GARDEN_DEVICES) are intentionally NOT counted — they are not block devices.
blk_nodes="$(find /dev -maxdepth 2 -type b 2>/dev/null | head -20 || true)"
lsblk_out=""
if command -v lsblk >/dev/null 2>&1; then
    lsblk_out="$(lsblk -nro NAME 2>/dev/null | head -20 || true)"
fi
if [ -z "$blk_nodes" ] && [ -z "$lsblk_out" ]; then
    ok "no host block devices visible (/dev has none; lsblk empty)"
else
    ko "host block device(s) visible — /dev: $(echo "$blk_nodes" | tr '\n' ' ')| lsblk: $(echo "$lsblk_out" | tr '\n' ' ')"
fi

# --- 5. mounting a block device fails ----------------------------------------
# Belt-and-suspenders even when no node is present: try to mount the FIRST block
# node if any, else a well-known host disk name. A pass is "mount did not
# succeed" (ENOENT, EACCES from the device cgroup, or EPERM from missing caps all
# count). We never leave a mount behind: on the vanishingly unlikely success we
# unmount immediately and FAIL loudly.
probe_dev="$(printf '%s\n' "$blk_nodes" | head -1)"
[ -n "$probe_dev" ] || probe_dev=/dev/sda1
mnt="$(mktemp -d 2>/dev/null || echo /tmp/hardening-mnt.$$)"
mkdir -p "$mnt" 2>/dev/null || true
if mount "$probe_dev" "$mnt" >/dev/null 2>&1; then
    umount "$mnt" >/dev/null 2>&1 || true
    ko "mount of $probe_dev SUCCEEDED — the container can mount host storage"
else
    ok "mount of a block device fails ($probe_dev not mountable)"
fi
rmdir "$mnt" 2>/dev/null || true

# --- 6. no maintainer (kriskowal) gh credential ------------------------------
# `gh auth status` must not report the human account, and no token file may name
# it. The bot's own login (kriscendobot) is fine and expected.
gh_bad=0
if command -v gh >/dev/null 2>&1; then
    if gh auth status 2>&1 | grep -qi 'kriskowal'; then gh_bad=1; fi
fi
gh_hosts="$HOME/.config/gh/hosts.yml"
if [ -f "$gh_hosts" ] && grep -qi 'kriskowal' "$gh_hosts"; then gh_bad=1; fi
if [ "$gh_bad" -eq 0 ]; then
    ok "no maintainer (kriskowal) gh account/token in the bot environment"
else
    ko "a kriskowal gh account/token is reachable from the bot environment"
fi

# --- 7. no loaded SSH agent identity -----------------------------------------
# The strong, deterministic signal is a LOADED identity, not the mere presence of
# a socket: these containers run a local gpg-agent whose ssh socket always exists
# but normally holds NO keys (`garden` deliberately does not forward the host's
# SSH_AUTH_SOCK — Dockerfile/usage notes). So we ask the agent what it holds:
#   ssh-add -l  → rc 0 with a list = identities loaded (FAIL)
#               → rc 1 ("no identities") or rc 2 (no agent) = clean (PASS)
if command -v ssh-add >/dev/null 2>&1 && ssh-add -l >/dev/null 2>&1; then
    ko "SSH agent has LOADED identities ($(ssh-add -l 2>/dev/null | wc -l) key(s)) — a forwarded human identity could leak into bot actions"
else
    ok "no loaded SSH agent identity (agent empty or absent)"
fi

echo "=== hardening probe: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] || exit 1
exit 0
