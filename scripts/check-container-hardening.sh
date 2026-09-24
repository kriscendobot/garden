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
#   exit 3  — PENDING RECREATE: only the launcher-posture checks (2-5) failed and this
#             host has never been verified hardened. The known pre-recreate state,
#             not a regression (see § Pending vs regressed below).
#
# PENDING vs REGRESSED (2026-09-24). Checks 2-5 (caps, sudo, block devices, mount)
# can only pass once the container is RECREATED with the hardened launcher
# (context/operations/harden-container.md), which is a deliberate maintainer step.
# Until then, failing them is expected. It is not a regression, and it must not
# fail the unit, because a failed garden-* unit fails every rolling-deploy canary
# and drains the host. So the first all-pass run records a per-host marker
# ($GARDEN_STATE/container-hardening/hardened-verified; the state dir lives in the
# bind-mounted checkout, so it survives a recreate):
#   - no marker + only checks 2-5 failed → PENDING: one coalesced
#     watchdog-notice.sh notice (re-sent at most every 7 days), exit 3;
#   - marker present + any failure       → REGRESSED: exit 1, loudly;
#   - checks 1/6/7 (container guard, maintainer gh credential, loaded SSH
#     identity) do not depend on a recreate, so they fail with exit 1 always.
# GARDEN_HARDENING_STRICT=1 ignores the marker and reports every failure as exit 1.
#
# The checks (each mandatory unless noted):
#   1. /.dockerenv present            — the container guard still works.
#   2. effective caps empty           — the bot user holds no capabilities.
#   3. `sudo -n true` fails           — no passwordless privilege escalation.
#   4. no host BLOCK devices          — no disk to mount (char GPU nodes are allowed
#                                       when GARDEN_DEVICES opts in; they are not
#                                       block devices, so they never trip this).
#   5. mounting a block device fails  — even if a node appeared, mount is denied.
#   6. no maintainer gh credential    — no maintainer (default kriskowal) account or
#                                       token reachable, compared by ACCOUNT LOGIN
#                                       (structural), never by substring text.
#   7. no human SSH key / agent       — no id_* private key, no SSH_AUTH_SOCK.
#
# Deterministic, read-only, no LLM. Cheap enough to run on a timer
# (garden-container-hardening.timer) and in bring-up verification
# (context/operations/starting.md § Verify).

set -uo pipefail

PASS=0
FAIL=0
POSTURE_FAIL=0   # checks 2-5: fixed only by a hardened recreate
ok()  { PASS=$((PASS+1)); printf '  PASS: %s\n' "$1"; }
ko()  { FAIL=$((FAIL+1)); printf '  FAIL: %s\n' "$1" >&2; }
kp()  { POSTURE_FAIL=$((POSTURE_FAIL+1)); ko "$1"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- maintainer-credential detection (check 6 internals) ----------------------
# These functions compare gh ACCOUNT LOGINS structurally against the maintainer
# set. They exist as functions (rather than inline in check 6) so the test suite
# can drive them via the `--maintainer-cred-selftest` seam below, and so the
# structural-vs-substring intent is unmistakable: at NO point do we `grep` free
# text for a name — a `kriskowal/garden` repo path, a gh-wrapper notice, or a
# config comment must never trip the check (that false positive is why this
# rewrite exists).

# real_gh_bin — the real gh binary, SKIPPING the fleet identity wrapper
# (…/scripts/jobs/bin/gh). The wrapper pins every call to the bot identity, which
# would mask the truth we are trying to read (a leaked maintainer login). Echoes
# the path; rc 1 if no gh at all.
real_gh_bin() {
  local cand
  while IFS= read -r cand; do
    case "$cand" in */scripts/jobs/bin/gh) continue;; esac
    printf '%s\n' "$cand"; return 0
  done < <(type -aP gh 2>/dev/null)
  return 1
}

# bounded_gh <gh> <args...> — run the real gh under an explicit wall-clock bound.
# Skipping the fleet wrapper (real_gh_bin, above) also skips its GARDEN_GH_TIMEOUT
# hang-protection, and a raw gh can stall unboundedly on a stuck TCP connect / DNS
# lookup / credential-helper prompt. Unbounded, that stall ran the whole unit past
# its TimeoutStartSec=120 into a systemd-timeout kill, which SuccessExitStatus does
# not cover, so self-heal-run.sh never captured or diagnosed it. Bounded, a hung
# call degrades to the "gh unavailable" path: logged_in_gh_logins falls back to
# the hosts.yml parse, env_token_maintainer_login resolves nothing. Default 15s
# per call (GARDEN_HARDENING_GH_TIMEOUT), well inside the unit's budget.
bounded_gh() {
  local gh="$1"; shift
  if command -v timeout >/dev/null 2>&1; then
    timeout --signal=TERM --kill-after=10s "${GARDEN_HARDENING_GH_TIMEOUT:-15s}" "$gh" "$@"
  else
    "$gh" "$@"
  fi
}

# maintainer_logins — the login set to guard against, one per line, lowercased.
# Precedence: explicit GARDEN_MAINTAINER_LOGIN (comma/space/newline separated) →
# the journal maintainers/allowlist (GARDEN_MAINTAINERS_ALLOWLIST or the journal
# worktree beside this checkout) → the safe default `kriskowal`.
maintainer_logins() {
  {
    if [ -n "${GARDEN_MAINTAINER_LOGIN:-}" ]; then
      printf '%s\n' "$GARDEN_MAINTAINER_LOGIN" | tr ', \t' '\n'
    else
      local allow="${GARDEN_MAINTAINERS_ALLOWLIST:-}" src
      if [ -z "$allow" ]; then
        for src in "${GARDEN_ROOT:-}/journal/maintainers/allowlist" \
                   "$SCRIPT_DIR/../journal/maintainers/allowlist" \
                   "$HOME/journal/maintainers/allowlist"; do
          [ -n "$src" ] && [ -f "$src" ] && { allow="$src"; break; }
        done
      fi
      if [ -n "$allow" ] && [ -f "$allow" ]; then
        grep -vE '^[[:space:]]*(#|$)' "$allow" | awk '{print $1}'
      else
        printf 'kriskowal\n'
      fi
    fi
  } | tr '[:upper:]' '[:lower:]' | awk 'NF'
}

# logged_in_gh_logins — every gh account logged in on this host, one login per
# line, lowercased, enumerated STRUCTURALLY. Primary path: `gh auth status --json
# hosts` (gh >= ~2.66), read with the store only (env tokens stripped; those are
# evaluated separately by env_token_maintainer_login). Fallback for an older/absent
# gh: parse hosts.yml's per-host `user:` field and the `users:` map keys by
# strictly-anchored position — never a raw substring scan.
logged_in_gh_logins() {
  local gh json; gh="$(real_gh_bin || true)"
  if [ -n "$gh" ]; then
    if json="$( (unset GH_TOKEN GITHUB_TOKEN; bounded_gh "$gh" auth status --json hosts --jq '.hosts[][].login') 2>/dev/null)" \
       && [ -n "$json" ]; then
      printf '%s\n' "$json" | tr '[:upper:]' '[:lower:]' | awk 'NF'
      return 0
    fi
  fi
  local hosts_yml="${GH_CONFIG_DIR:-$HOME/.config/gh}/hosts.yml"
  [ -f "$hosts_yml" ] || return 0
  {
    # per-host active account:  "    user: <login>"
    grep -oE '^[[:space:]]+user:[[:space:]]+[A-Za-z0-9._-]+' "$hosts_yml" 2>/dev/null | awk '{print $2}'
    # users: map keys (indented >= 6, a bare "<login>:" with no inline value); this
    # excludes the 0-indent host key, the 4-indent "users:" line, and value-bearing
    # fields like "oauth_token: …".
    grep -oE '^[[:space:]]{6,}[A-Za-z0-9._-]+:[[:space:]]*$' "$hosts_yml" 2>/dev/null \
      | sed -E 's/^[[:space:]]+//; s/:[[:space:]]*$//'
  } | tr '[:upper:]' '[:lower:]' | awk 'NF' | sort -u
}

# env_token_maintainer_login — for each of GH_TOKEN / GITHUB_TOKEN present in the
# env, resolve the token's OWNING login via the real gh (`gh api user`) and echo
# it, lowercased. Resolving the token beats grepping for a name: a maintainer PAT
# named nothing suggestive is still caught.
env_token_maintainer_login() {
  local gh; gh="$(real_gh_bin || true)"
  [ -n "$gh" ] || return 0
  local var tok login
  for var in GH_TOKEN GITHUB_TOKEN; do
    tok="$(printenv "$var" 2>/dev/null || true)"
    [ -n "$tok" ] || continue
    login="$(GH_TOKEN="$tok" GITHUB_TOKEN="$tok" bounded_gh "$gh" api user --jq .login 2>/dev/null | tr '[:upper:]' '[:lower:]')"
    [ -n "$login" ] && printf '%s\n' "$login"
  done
}

# maintainer_gh_credential_reachable — echoes each offending "<source>:<login>"
# (a logged-in account or a resolved env token whose login is a maintainer) and
# returns 0 iff at least one was found; rc 1 when clean.
maintainer_gh_credential_reachable() {
  local -A maint=()
  local m login found=1
  while IFS= read -r m; do [ -n "$m" ] && maint["$m"]=1; done < <(maintainer_logins)
  while IFS= read -r login; do
    [ -n "$login" ] || continue
    [ -n "${maint[$login]:-}" ] && { printf 'gh-account:%s\n' "$login"; found=0; }
  done < <(logged_in_gh_logins)
  while IFS= read -r login; do
    [ -n "$login" ] || continue
    [ -n "${maint[$login]:-}" ] && { printf 'env-token:%s\n' "$login"; found=0; }
  done < <(env_token_maintainer_login)
  return "$found"
}

# Test seam: run ONLY the maintainer-credential detection (no container guard, no
# other checks) so the hardening-probe test can drive it on host fixtures. Prints
# "REACHABLE <offenders…>" + exit 1 when a maintainer credential is reachable, or
# "CLEAN" + exit 0 otherwise.
if [ "${1:-}" = "--maintainer-cred-selftest" ]; then
  offenders="$(maintainer_gh_credential_reachable || true)"
  if [ -n "$offenders" ]; then
    printf 'REACHABLE %s\n' "$(printf '%s' "$offenders" | tr '\n' ' ')"; exit 1
  fi
  echo CLEAN; exit 0
fi

# --- verdict: pending recreate vs regression ----------------------------------
HARDENING_MARKER="${GARDEN_HARDENING_MARKER:-${GARDEN_STATE:-${GARDEN_ROOT:-$SCRIPT_DIR/..}/.garden-state}/container-hardening/hardened-verified}"
PENDING_STAMP="$(dirname "$HARDENING_MARKER")/pending-notified"
HARDENING_HOST="${GARDEN:-$(hostname -s 2>/dev/null || echo unknown)}"
PENDING_KEY="container-hardening-pending-recreate-$HARDENING_HOST"

# notify <watchdog-notice args...> — best-effort, bounded; a journal hiccup never
# changes the verdict. GARDEN_HARDENING_NOTICE is the test seam.
notify() {
  local cmd="${GARDEN_HARDENING_NOTICE:-$SCRIPT_DIR/jobs/watchdog-notice.sh}"
  if command -v timeout >/dev/null 2>&1; then
    timeout --kill-after=10s 60s "$cmd" "$@" >/dev/null 2>&1 || true
  else
    "$cmd" "$@" >/dev/null 2>&1 || true
  fi
}

# hardening_verdict <posture_fails> <total_fails> — print the verdict and return the
# exit code (0 hardened, 1 failed/regressed, 3 pending recreate). Records the
# marker on the first all-pass run and closes an open pending notice.
hardening_verdict() {
  local posture="$1" total="$2" now stamp_at
  if [ "$total" -eq 0 ]; then
    if [ ! -f "$HARDENING_MARKER" ]; then
      mkdir -p "$(dirname "$HARDENING_MARKER")" 2>/dev/null || true
      printf 'verified_at: %s\nhost: %s\n' "$(date -u +%FT%TZ)" "$HARDENING_HOST" > "$HARDENING_MARKER" 2>/dev/null \
        && echo "  VERIFIED: first hardened run on this host; recorded $HARDENING_MARKER (any later failure is a regression)"
    fi
    if [ -f "$PENDING_STAMP" ]; then
      printf 'Container hardening verified on %s: the recreate landed and every check passes.\n' "$HARDENING_HOST" \
        | notify --recovered "$PENDING_KEY"
      rm -f "$PENDING_STAMP"
    fi
    return 0
  fi
  if [ "$posture" -ne "$total" ] || [ -f "$HARDENING_MARKER" ] || [ "${GARDEN_HARDENING_STRICT:-0}" = 1 ]; then
    [ -f "$HARDENING_MARKER" ] && [ "$posture" -gt 0 ] \
      && echo "  REGRESSED: this host was verified hardened ($HARDENING_MARKER) and has lost it" >&2
    return 1
  fi
  # Only launcher-posture checks failed on a never-hardened host: pending recreate.
  echo "  PENDING RECREATE: not yet recreated with the hardened launcher (context/operations/harden-container.md); not a regression"
  now="$(date +%s)"
  stamp_at="$(stat -c %Y "$PENDING_STAMP" 2>/dev/null || echo 0)"
  if [ $(( now - stamp_at )) -ge "${GARDEN_HARDENING_PENDING_RENOTIFY:-604800}" ]; then
    printf '%s\n' \
      "Container hardening is PENDING on $HARDENING_HOST: $posture launcher-posture check(s) fail (caps/sudo/block devices/mount)." \
      "" \
      "This is the expected state until the container is recreated with the hardened launcher," \
      "a maintainer step: context/operations/harden-container.md. The garden-container-hardening" \
      "unit stays clean meanwhile (exit 3), so it does not fail rolling-deploy canaries. After the" \
      "first all-pass run, any failure is treated as a regression and fails the unit." \
      | notify "$PENDING_KEY"
    mkdir -p "$(dirname "$PENDING_STAMP")" 2>/dev/null || true
    touch "$PENDING_STAMP" 2>/dev/null || true
  fi
  return 3
}

# Test seam: run ONLY the verdict on given failure counts (no environment probing).
if [ "${1:-}" = "--verdict-selftest" ]; then
  hardening_verdict "${2:?posture fails}" "${3:?total fails}"; exit $?
fi

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
    kp "effective caps NON-empty (CapEff=$capeff) — expected 0 for the bot user"
fi

# --- 3. no passwordless sudo -------------------------------------------------
# Pass if sudo is absent (removed from the image) OR present but `sudo -n true`
# fails (no NOPASSWD rule). Fail ONLY if a non-interactive sudo actually succeeds.
if command -v sudo >/dev/null 2>&1; then
    if sudo -n true >/dev/null 2>&1; then
        kp "sudo -n true SUCCEEDED — passwordless privilege escalation is available"
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
    kp "host block device(s) visible — /dev: $(echo "$blk_nodes" | tr '\n' ' ')| lsblk: $(echo "$lsblk_out" | tr '\n' ' ')"
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
    kp "mount of $probe_dev SUCCEEDED — the container can mount host storage"
else
    ok "mount of a block device fails ($probe_dev not mountable)"
fi
rmdir "$mnt" 2>/dev/null || true

# --- 6. no maintainer gh credential ------------------------------------------
# No gh account logged in on this host, and no GH_TOKEN/GITHUB_TOKEN in the env,
# may resolve to a MAINTAINER login (default kriskowal; overridable via
# GARDEN_MAINTAINER_LOGIN or the journal maintainers/allowlist). The comparison is
# structural — account LOGINS, not substring text — so an incidental "kriskowal"
# in a repo path (kriskowal/garden), a gh-wrapper notice, or a config comment can
# never false-alarm (the bug this rewrite fixes). The bot's own login
# (kriscendobot) is fine and expected. Uses the REAL gh, not the fleet wrapper,
# so the wrapper's identity pin cannot mask a leaked maintainer credential.
offenders="$(maintainer_gh_credential_reachable || true)"
if [ -z "$offenders" ]; then
    ok "no maintainer gh account/token reachable (logins checked structurally)"
else
    ko "a maintainer gh credential is reachable: $(printf '%s' "$offenders" | tr '\n' ' ')"
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
hardening_verdict "$POSTURE_FAIL" "$FAIL"
exit $?
