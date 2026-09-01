#!/bin/bash
# seed-api-key-handoff.sh -- seed API keys for the lingering systemd user manager.
#
# Docker gives PID 1 these variables, but user@.service starts through PAM and
# therefore does not inherit PID 1's environment. systemd's built-in
# environment-d generator reads /run/environment.d before the user manager
# starts. /run is a container tmpfs, so this is an intentionally volatile,
# allowlist-only bridge from PID 1 to that manager.

set -euo pipefail

handoff_dir=/run/environment.d
# Test fixtures need an isolated tmpfs-shaped directory. Production never
# accepts an override, even if an ambient process exports this variable.
if [[ "${GARDEN_TEST:-}" = 1 && -n "${GARDEN_API_KEY_HANDOFF_DIR:-}" ]]; then
    handoff_dir="$GARDEN_API_KEY_HANDOFF_DIR"
fi
handoff_file="$handoff_dir/60-garden-api-keys.conf"
garden_user="${GARDEN_USER:?GARDEN_USER is required}"

install -d -m 0755 "$handoff_dir"
tmp_file="$(mktemp "$handoff_dir/.garden-api-keys.XXXXXX")"
cleanup() { rm -f "$tmp_file"; }
trap cleanup EXIT

# Do not source an arbitrary file and do not enumerate the environment. These
# are the only secrets this bridge may carry. Provider tokens use the base64url
# alphabet; reject every other character so an environment.d parser can never
# reinterpret a secret as syntax. Failures name the variable, never its value.
for key_name in ANTHROPIC_API_KEY MOONSHOT_API_KEY FIREWORKS_API_KEY OPENROUTER_API_KEY OLLAMA_CLOUD_API_KEY; do
    key_value="${!key_name:-}"
    if [[ -n "$key_value" ]]; then
        if [[ ! "$key_value" =~ ^[A-Za-z0-9_-]+$ ]]; then
            printf '%s contains unsupported characters\n' "$key_name" >&2
            exit 1
        fi
        printf '%s=%s\n' "$key_name" "$key_value" >> "$tmp_file"
    fi
done

if [[ -s "$tmp_file" ]]; then
    # The user manager runs as this account. Root retains ownership while its
    # private group gets read access; no secret is placed in the bind-mounted
    # home, repository, unit files, or journal.
    if [[ "${GARDEN_TEST:-}" = 1 ]]; then
        # An unprivileged regression test cannot assign root ownership.
        chown "$garden_user:$garden_user" "$tmp_file"
    else
        chown root:"$garden_user" "$tmp_file"
    fi
    chmod 0640 "$tmp_file"
    mv -f "$tmp_file" "$handoff_file"
    trap - EXIT
else
    rm -f "$handoff_file"
fi
