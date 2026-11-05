#!/bin/bash
# Shared, value-silent parsing and validation for the fixed secret registry.

SECRET_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
: "${GARDEN_ROOT:=$(cd "$SECRET_LIB_DIR/../.." && pwd)}"
: "${GARDEN_SECRET_REGISTRY:=$SECRET_LIB_DIR/registry.tsv}"
: "${GARDEN_SECRETS_DIR:=$GARDEN_ROOT/.garden-state/secrets}"

secret_registry_row() { # <kind>
  local kind="${1:?kind required}"
  awk -F '\t' -v kind="$kind" '$1 == kind { print; found=1; exit } END { if (!found) exit 1 }' \
    "$GARDEN_SECRET_REGISTRY"
}

secret_registry_field() { # <kind> <1-based-column>
  local row
  row="$(secret_registry_row "$1")" || return 1
  printf '%s\n' "$row" | cut -f"$2"
}

secret_kind_valid() { secret_registry_row "$1" >/dev/null 2>&1; }
secret_environment_name() { secret_registry_field "$1" 2; }
secret_filename() { secret_registry_field "$1" 3; }
secret_path() { printf '%s/%s\n' "$GARDEN_SECRETS_DIR" "$(secret_filename "$1")"; }

secret_ensure_directory() {
  umask 077
  mkdir -p "$GARDEN_SECRETS_DIR"
  chmod 0700 "$GARDEN_SECRETS_DIR"
}

secret_validate_file() { # <kind> <file>; diagnostics name rules, never bytes
  local kind="$1" file="$2" validator bytes clean prefix
  secret_kind_valid "$kind" || { printf 'unknown secret kind: %s\n' "$kind" >&2; return 1; }
  [ -f "$file" ] || { printf '%s: value is not a regular file\n' "$kind" >&2; return 1; }
  bytes="$(wc -c < "$file" | tr -d ' ')"
  [ "$bytes" -gt 0 ] || { printf '%s: value is empty\n' "$kind" >&2; return 1; }
  [ "$bytes" -le 512 ] || { printf '%s: value exceeds the maximum length\n' "$kind" >&2; return 1; }
  clean="$(LC_ALL=C tr -d '\000\n\r\t ' < "$file" | wc -c | tr -d ' ')"
  [ "$clean" = "$bytes" ] || { printf '%s: value contains NUL, newline, or whitespace\n' "$kind" >&2; return 1; }
  LC_ALL=C grep -Eq '^[A-Za-z0-9._:/+=-]+$' "$file" \
    || { printf '%s: value contains characters outside the allowed alphabet\n' "$kind" >&2; return 1; }
  validator="$(secret_registry_field "$kind" 4)"
  case "$validator" in
    anthropic) prefix='sk-ant-'; [ "$bytes" -ge 20 ] ;;
    moonshot) prefix='sk-'; [ "$bytes" -ge 16 ] ;;
    openrouter) prefix='sk-or-v1-'; [ "$bytes" -ge 24 ] ;;
    opaque) prefix=''; [ "$bytes" -ge 16 ] ;;
    *) printf '%s: registry names an unknown validator\n' "$kind" >&2; return 1 ;;
  esac || { printf '%s: value is implausibly short\n' "$kind" >&2; return 1; }
  if [ -n "$prefix" ]; then
    LC_ALL=C grep -q "^$prefix" "$file" \
      || { printf '%s: value lacks the documented prefix\n' "$kind" >&2; return 1; }
  fi
}

secret_file_metadata_valid() { # <kind>
  local path mode owner
  path="$(secret_path "$1")" || return 1
  [ -f "$path" ] && [ ! -L "$path" ] || return 1
  mode="$(stat -c %a "$path" 2>/dev/null || true)"
  owner="$(stat -c %u "$path" 2>/dev/null || true)"
  [ "$mode" = 600 ] && [ "$owner" = "$(id -u)" ]
}

secret_available() { # <kind>; local, uncached, value-free
  local kind="$1" path rc=0
  secret_kind_valid "$kind" || return 1
  [ "$(stat -c %a "$GARDEN_SECRETS_DIR" 2>/dev/null || true)" = 700 ] || return 1
  [ "$(stat -c %u "$GARDEN_SECRETS_DIR" 2>/dev/null || true)" = "$(id -u)" ] || return 1
  path="$(secret_path "$kind")"
  exec {secret_lock_fd}<"$GARDEN_SECRETS_DIR" || return 1
  flock -s "$secret_lock_fd" || return 1
  secret_file_metadata_valid "$kind" || rc=$?
  if [ "$rc" -eq 0 ]; then secret_validate_file "$kind" "$path" >/dev/null 2>&1 || rc=$?; fi
  flock -u "$secret_lock_fd" 2>/dev/null || true
  exec {secret_lock_fd}>&-
  return "$rc"
}

# Trusted launchers use this only in a command substitution or direct assignment.
# It prefers the file and retains the compatibility release's legacy-env fallback.
secret_value() { # <kind>
  local kind="$1" path env_name legacy validator file_ok=0 rc
  if secret_kind_valid "$kind" \
    && [ "$(stat -c %a "$GARDEN_SECRETS_DIR" 2>/dev/null || true)" = 700 ] \
    && [ "$(stat -c %u "$GARDEN_SECRETS_DIR" 2>/dev/null || true)" = "$(id -u)" ]; then
    path="$(secret_path "$kind")"
    if exec {secret_value_lock_fd}<"$GARDEN_SECRETS_DIR"; then
      if flock -s "$secret_value_lock_fd"; then
        if secret_file_metadata_valid "$kind" && secret_validate_file "$kind" "$path" >/dev/null 2>&1; then
          file_ok=1
          command cat "$path"
          rc=$?
        fi
        flock -u "$secret_value_lock_fd" 2>/dev/null || true
      fi
      exec {secret_value_lock_fd}>&-
      [ "$file_ok" -eq 0 ] || return "$rc"
    fi
  fi
  env_name="$(secret_environment_name "$kind")" || return 1
  legacy="${!env_name:-}"
  [ "${#legacy}" -ge 16 ] && [ "${#legacy}" -le 512 ] || return 1
  [[ "$legacy" =~ ^[A-Za-z0-9._:/+=-]+$ ]] || return 1
  validator="$(secret_registry_field "$kind" 4)"
  case "$validator:$legacy" in
    anthropic:sk-ant-*|moonshot:sk-*|openrouter:sk-or-v1-*|opaque:*) ;;
    *) return 1 ;;
  esac
  printf '%s' "$legacy"
}

secret_clear_env_args() {
  # shellcheck disable=SC2034 # consumed by the trusted handler that sources us
  SECRET_CLEAR_ENV_ARGS=(
    -u ANTHROPIC_API_KEY -u MOONSHOT_API_KEY -u FIREWORKS_API_KEY
    -u OPENROUTER_API_KEY -u OLLAMA_CLOUD_API_KEY -u TYPESAFE_API_KEY
  )
}
