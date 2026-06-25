#!/bin/bash
# plan/lib.sh — shared helpers for the plan-in-journal tooling.
#
# The plan is garden state on the `journal2` branch under `journal/plan/`:
#
#   plan/repositories.md                        repository-slug -> repository-URL map
#   plan/designs/<repo-slug>/<design-slug>.md   one record per design (frontmatter + narrative); THE source of truth
#   plan/milestones/<id>.md                     milestone definition (goal, exit criterion, target, members)
#   plan/velocity.md                            observed velocity inputs + the S/M/L/XL day mapping
#   plan/README.md                              GENERATED aggregate roadmap (table + dep graph + rollups); never hand-edited
#
# Per the approved design designs/plan-in-journal.md (garden#4): the per-design
# files are the authoritative unit; the README is an aggregation of them, produced
# by render.sh and kept current by the bulletin/journalist loops and the weekly
# Sunday recalibration job. No part of the plan has an authoritative per-repo copy.
#
# Source this; do not execute it. Callers set PLAN_DIR to the plan/ tree root.

# The canonical status enum, carried verbatim from the endo v1 plan. "Implemented"
# is an accepted synonym for "Complete" on import; the canonical token is "Complete".
PLAN_STATUSES="Not Started|Proposed|In Progress|Draft|Complete|Active|Reference|Deprecated|Superseded"
# Valid size tokens (a single bin; ranges like "S-M" are normalized on import to
# the larger bin so the rollup math has one value per record).
PLAN_SIZES="S|M|L|XL"

# fm_field <file> <key> — echo a scalar frontmatter value (the block between the
# first two `---` lines), trimmed of surrounding quotes/whitespace. Empty if absent.
fm_field() {
  awk -v key="$2" '
    NR==1 && $0!="---" { exit }
    $0=="---" { d++; if (d>=2) exit; next }
    d==1 {
      if (match($0, "^[[:space:]]*" key "[[:space:]]*:[[:space:]]*")) {
        v=substr($0, RLENGTH+1)
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", v)
        gsub(/^["\x27]|["\x27]$/, "", v)
        print v; exit
      }
    }
  ' "$1" 2>/dev/null
}

# fm_list <file> <key> — echo the elements of an inline list value
# (`key: [a, b, c]`) one per line. Empty if absent or `[]`.
fm_list() {
  local raw; raw="$(fm_field "$1" "$2")"
  raw="${raw#[}"; raw="${raw%]}"
  [ -n "${raw//[[:space:],]/}" ] || return 0
  printf '%s\n' "$raw" | tr ',' '\n' | sed -E 's/^[[:space:]]+|[[:space:]]+$//g; s/^["\x27]|["\x27]$//g' | grep -v '^$' || true
}

# fm_body <file> — echo everything after the closing frontmatter `---`.
fm_body() { sed '1{/^---$/!q}; 1d; /^---$/{d; :a; n; ba}' "$1" 2>/dev/null; }

# list_records [<plan-dir>] — echo every design record path under designs/, sorted.
list_records() {
  local p="${1:-$PLAN_DIR}"
  [ -d "$p/designs" ] || return 0
  find "$p/designs" -type f -name '*.md' 2>/dev/null | LC_ALL=C sort
}

# repo_url <plan-dir> <repo-slug> — resolve a repository slug to its URL from
# repositories.md (lines `<slug>: <url>`). Empty if unmapped.
repo_url() {
  local p="$1" slug="$2"
  [ -f "$p/repositories.md" ] || return 0
  sed -nE "s|^[[:space:]]*${slug}[[:space:]]*:[[:space:]]*([^[:space:]]+).*$|\1|p" "$p/repositories.md" | head -1
}

# is_complete_status <status> — exit 0 if the status counts as done for rollups.
is_complete_status() { case "$1" in Complete|Active|Reference) return 0;; *) return 1;; esac; }

# size_days <plan-dir> <size> — map an S/M/L/XL size to a day estimate using
# velocity.md (lines `<SIZE>: <days>`), defaulting to the conservative built-ins.
size_days() {
  local p="$1" sz="$2" v=""
  [ -f "$p/velocity.md" ] && v="$(sed -nE "s|^[[:space:]]*${sz}[[:space:]]*:[[:space:]]*([0-9.]+).*$|\1|p" "$p/velocity.md" | head -1)"
  if [ -n "$v" ]; then printf '%s' "$v"; return; fi
  case "$sz" in S) printf '1';; M) printf '3';; L) printf '8';; XL) printf '15';; *) printf '0';; esac
}
