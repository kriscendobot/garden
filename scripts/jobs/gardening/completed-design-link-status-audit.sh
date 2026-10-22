#!/bin/bash
# Find completed changed designs whose local Markdown links still claim an
# incomplete status. This is a bounded, syntax-only panel pre-pass; the
# archivist decides what the contradictory status means for the design.

set -euo pipefail

wt="${1:?usage: completed-design-link-status-audit.sh <worktree> <base> [--evidence-file FILE]}"
base="${2:?base ref}"
shift 2
evidence_file=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --evidence-file) evidence_file="${2:?--evidence-file requires a path}"; shift 2 ;;
    *) echo "unknown argument: $1" >&2; exit 3 ;;
  esac
done

: "${GARDEN_COMPLETED_DESIGN_MAX_CHANGED:=32}"
: "${GARDEN_COMPLETED_DESIGN_MAX_LINKS:=128}"
: "${GARDEN_COMPLETED_DESIGN_MAX_BYTES:=262144}"

scratch="$(mktemp -d "${TMPDIR:-/tmp}/completed-design-status.XXXXXX")"
trap 'rm -rf "$scratch"' EXIT
findings="$scratch/findings"
: > "$findings"

status_lines() { # status_lines <file>: print line-number<TAB>kind<TAB>line
  local file="$1"
  head -c "$GARDEN_COMPLETED_DESIGN_MAX_BYTES" "$file" 2>/dev/null \
    | awk '
      {
        line=$0
        low=tolower(line)
        if (low !~ /^[[:space:]]*(>[[:space:]]*)?(\*\*)?status(\*\*)?[[:space:]]*:/ &&
            low !~ /^[[:space:]]*(>[[:space:]]*)?(\*\*)?status:[[:space:]]*(\*\*)?/ &&
            low !~ /^[[:space:]]*\|[[:space:]]*(\*\*)?status(\*\*)?[[:space:]]*\|/)
          next
        if (low ~ /(proposed|draft|planned|pending|incomplete|unfinished|unimplemented|not yet implemented|partially implemented|partial|experimental|open question)/)
          print NR "\tincomplete\t" line
        else if (low ~ /(implemented|built|landed|completed|complete|delivered|done)/)
          print NR "\tcomplete\t" line
      }
    '
}

is_design_path() {
  case "$1" in
    designs/*.md|*/designs/*.md|DESIGN*.md|*/DESIGN*.md) return 0 ;;
    *) return 1 ;;
  esac
}

wt_real="$(realpath -m "$wt")"
changed="$scratch/changed"
if ! git -C "$wt" diff --name-only -z "$base...HEAD" > "$changed" 2>/dev/null; then
  exit 3
fi

changed_count=0
while IFS= read -r -d '' source_rel; do
  is_design_path "$source_rel" || continue
  source="$wt/$source_rel"
  [ -f "$source" ] || continue
  changed_count=$((changed_count + 1))
  [ "$changed_count" -le "$GARDEN_COMPLETED_DESIGN_MAX_CHANGED" ] || break

  source_status="$(status_lines "$source" | head -1)"
  [ -n "$source_status" ] || continue
  [ "$(printf '%s\n' "$source_status" | cut -f2)" = complete ] || continue
  source_status_line="${source_status%%$'\t'*}"
  source_status_text="${source_status#*$'\t'complete$'\t'}"

  links_seen=0
  while IFS=: read -r link_line token; do
    [ -n "${token:-}" ] || continue
    links_seen=$((links_seen + 1))
    [ "$links_seen" -le "$GARDEN_COMPLETED_DESIGN_MAX_LINKS" ] || break
    target="${token#\](}"
    target="${target%)}"
    case "$target" in
      \<*\>) target="${target#<}"; target="${target%>}" ;;
      *) target="${target%%[[:space:]]*}" ;;
    esac
    target="${target%%#*}"; target="${target%%\?*}"
    target="${target//%20/ }"
    case "$target" in ''|*://*|mailto:*|/*) continue ;; esac
    case "$target" in *.md|*.MD) ;; *) continue ;; esac
    target_real="$(realpath -m "$(dirname "$source")/$target")"
    case "$target_real" in "$wt_real"/*) ;; *) continue ;; esac
    [ -f "$target_real" ] || continue
    target_rel="${target_real#"$wt_real"/}"
    while IFS=$'\t' read -r target_line kind target_text; do
      [ "$kind" = incomplete ] || continue
      {
        printf 'completed design: %s:%s: %s\n' "$source_rel" "$source_status_line" "$source_status_text"
        printf 'local design link: %s:%s -> %s\n' "$source_rel" "$link_line" "$target_rel"
        printf 'contradictory linked status: %s:%s: %s\n' "$target_rel" "$target_line" "$target_text"
      } >> "$findings"
    done < <(status_lines "$target_real")
  done < <(head -c "$GARDEN_COMPLETED_DESIGN_MAX_BYTES" "$source" 2>/dev/null \
    | grep -nEo '\]\((<[^>]+>|[^)[:space:]]+)([[:space:]]+"[^"]*")?\)' || true)
done < "$changed"

if [ -s "$findings" ]; then
  if [ -n "$evidence_file" ]; then cp "$findings" "$evidence_file"; else cat "$findings"; fi
  exit 10
fi
[ -z "$evidence_file" ] || : > "$evidence_file"
exit 0
