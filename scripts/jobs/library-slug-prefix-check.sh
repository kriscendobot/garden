#!/bin/bash
# library-slug-prefix-check.sh — deterministic source-slug PREFIX-DIVERGENCE check
# for the cross-cutting reference library (`journal/library/`).
#
# Companion to library-link-check.sh. Where that resolver answers "does this
# section link target a committed file" (pure graph resolution), this one answers
# a different deterministic question the scholar otherwise carried in its head:
# "for the host/domain this new source comes from, what slug PREFIX do the sibling
# sources already use, and does the proposed slug diverge from it?"
#
# WHY IT EXISTS. A scholar landed a new erights.org source under the slug prefix
# `erights-org--` while the sibling erights.org corpus already used `erights--`,
# then had to re-land and `status: superseded` the divergent files — churn caught
# only AFTER landing. The standing lesson ("check what prefix the sibling corpus
# uses before authoring a new source for a known domain") lived only in the
# agent's head. This check moves that decision off the agent: it maps each source
# row's upstream host/domain to the set of slug prefixes already in use for that
# host, and when a newly-proposed slug introduces a prefix that diverges from the
# established prefix(es) for the same host, it FAILS (the pre-land gate) or WARNS,
# naming the canonical sibling prefix. The scholar reuses the named prefix, or
# passes --allow-new-prefix to deliberately register a genuinely-new thematic
# cluster (per conventions.md § Slug pattern: a "named thematic cluster" MAY take
# a thematic prefix; the bare per-kind prefix is for one-off references).
#
# WHAT A "HOST" IS. The second column of a source row:
#   - a URL (https://erights.org/...) -> the hostname (erights.org; www. stripped);
#   - an owner/name repo cell (endojs/endo, optionally with a trailing "(branch)")
#     -> that owner/name (the repo IS the domain analogue for repo sources);
#   - anything else (a paper's author cell "Miller, Shapiro", a {N files} cell)
#     -> no host; the row is skipped. Papers group under the kind-wide `papers--`
#     prefix by author, not by host, so they are out of this check's scope.
#
# WHAT A "PREFIX" IS. The slug substring before the first `--` (slugs themselves
# embed `--` between prefix and body: `web--miller-...`, `erights--elang-...`,
# `endo--packages-...`). A slug with no `--` contributes its whole self as prefix.
#
# DIVERGENCE RULE (the judgment, made deterministic). A proposed prefix P for host
# H diverges when H already has >=1 established prefix AND P is not among them. The
# established prefixes are reported sorted by usage count (highest = "canonical
# sibling"). A host with NO prior sources cannot diverge (a genuinely new host is
# always fine). This is intentionally simple: a host may legitimately carry several
# thematic prefixes, so the gate does not forbid a new one — it forces the scholar
# to SEE the established set and choose, reusing a sibling or passing
# --allow-new-prefix on purpose.
#
# Exit: 0 = no divergence (or --allow-new-prefix downgraded it to a warning, or
#           --audit found no suspected accidental divergence); 1 = divergence (the
#           gate blocks) / --audit found a singleton prefix beside an established
#           one; 2 = usage / setup error.
#
# This script makes NO writes and NO network calls. It is safe to run anywhere.

set -uo pipefail

usage() {
  cat >&2 <<'USAGE'
library-slug-prefix-check.sh — check a source slug's prefix against sibling
sources sharing the same upstream host/domain.

Mode (exactly one required):
  --propose <slug>         PRE-LAND check for one proposed source slug. Derive its
                           host from --url/--host, else from the slug's own row in
                           the library's sources/README.md. Fail (exit 1) if the
                           prefix diverges from the established prefix(es) for that
                           host, naming the canonical sibling. The form a scholar
                           runs before authoring a new source for a known domain.
  --changed [<base-ref>]   GATE mode: for every source row that is NEW since
                           <base-ref> (default origin/journal2), check its prefix
                           against the host's established prefixes as recorded at
                           <base-ref> (the committed corpus before this change).
                           The producer-side gate; mirrors library-link-check.sh
                           --changed. Needs a git library.
  --audit                  STANDING scan: report every host whose source rows use
                           more than one prefix, flagging any singleton-use prefix
                           that sits beside an established (>1 use) prefix for the
                           same host as a SUSPECTED accidental divergence. Exit 1
                           if any such suspect exists (a CI-style convention check),
                           else 0. Legitimate multi-prefix hosts (every prefix used
                           more than once) are reported but do not fail the run.

Options:
  --url <url>              with --propose: derive the host from this source URL.
  --host <host>           with --propose: use this host/domain (or owner/name)
                           directly, skipping README row lookup.
  --allow-new-prefix       with --propose/--changed: downgrade a divergence from a
                           FAIL to a WARN (exit 0). The deliberate-new-cluster
                           override; use it only after confirming the new prefix
                           names a genuinely distinct thematic cluster.
  --library <dir>          library root. Default: $GARDEN_GARDENER_CLONE/library,
                           else $GARDEN_ROOT/journal/library, else ./library.
  --quiet                  print only divergences/suspects, not per-host OK lines.
  -h, --help               this help.
USAGE
}

# --- argument parse ----------------------------------------------------------
MODE=""
PROPOSE_SLUG=""
BASE_REF="origin/journal2"
PROPOSE_URL=""
PROPOSE_HOST=""
ALLOW_NEW=0
LIBRARY=""
QUIET=0

while [ $# -gt 0 ]; do
  case "$1" in
    --propose) MODE="propose"; PROPOSE_SLUG="${2:?--propose needs a slug}"; shift 2 ;;
    --changed)
      MODE="changed"; shift
      if [ $# -gt 0 ] && [ "${1#--}" = "$1" ]; then BASE_REF="$1"; shift; fi
      ;;
    --audit) MODE="audit"; shift ;;
    --url) PROPOSE_URL="${2:?--url needs a value}"; shift 2 ;;
    --host) PROPOSE_HOST="${2:?--host needs a value}"; shift 2 ;;
    --allow-new-prefix) ALLOW_NEW=1; shift ;;
    --library) LIBRARY="${2:?--library needs a dir}"; shift 2 ;;
    --quiet) QUIET=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "library-slug-prefix-check: unknown argument: $1" >&2; usage; exit 2 ;;
  esac
done

[ -n "$MODE" ] || { echo "library-slug-prefix-check: a mode is required" >&2; usage; exit 2; }

# --- locate the library root (same resolution order as library-link-check.sh) -
if [ -z "$LIBRARY" ]; then
  if [ -n "${GARDEN_GARDENER_CLONE:-}" ] && [ -d "${GARDEN_GARDENER_CLONE}/library" ]; then
    LIBRARY="${GARDEN_GARDENER_CLONE}/library"
  elif [ -n "${GARDEN_ROOT:-}" ] && [ -d "${GARDEN_ROOT}/journal/library" ]; then
    LIBRARY="${GARDEN_ROOT}/journal/library"
  elif [ -d "./library" ]; then
    LIBRARY="./library"
  else
    echo "library-slug-prefix-check: cannot locate the library; pass --library <dir>" >&2
    exit 2
  fi
fi
LIBRARY="$(cd "$LIBRARY" 2>/dev/null && pwd)" || { echo "library-slug-prefix-check: no such library dir" >&2; exit 2; }
README="$LIBRARY/sources/README.md"
[ -f "$README" ] || { echo "library-slug-prefix-check: $LIBRARY has no sources/README.md — not a library root" >&2; exit 2; }

GIT_ROOT="$(git -C "$LIBRARY" rev-parse --show-toplevel 2>/dev/null || true)"

# --- the row parser ----------------------------------------------------------
# Read a sources/README.md and emit one TAB-separated `host<TAB>prefix<TAB>slug`
# line per parseable row. A row is parseable when col1 carries a `[title](slug.md)`
# link and col2 yields a host (a URL hostname, or an owner/name repo cell). Rows
# whose col2 is an author cell, a `{N files}` aggregate, or otherwise non-host are
# skipped. Reads from stdin so it works on both the on-disk README and a
# `git show <ref>:...` blob.
parse_rows() {
  awk -F'|' '
    /^\| *\[/ {
      col1 = $2; col2 = $3
      # slug from col1: [..](<slug>.md)
      if (!match(col1, /\]\([^()]+\.md\)/)) next
      slug = substr(col1, RSTART, RLENGTH); gsub(/^\]\(|\)$/, "", slug); sub(/\.md$/, "", slug)
      if (slug == "") next
      # prefix: substring before the first "--", else the whole slug.
      prefix = slug
      if ((p = index(slug, "--")) > 0) prefix = substr(slug, 1, p - 1)
      if (prefix == "") next
      # host from col2.
      gsub(/^[ \t]+|[ \t]+$/, "", col2)
      host = ""
      if (col2 ~ /^https?:\/\//) {
        h = col2; sub(/^https?:\/\//, "", h); sub(/[\/?#].*$/, "", h); sub(/^www\./, "", h)
        sub(/:[0-9]+$/, "", h)
        host = h
      } else {
        # strip a trailing parenthetical like "(journal branch)" before the test.
        repo = col2; sub(/[ \t]*\(.*$/, "", repo); gsub(/^[ \t]+|[ \t]+$/, "", repo)
        if (repo ~ /^[^ \/]+\/[^ \/]+$/) host = repo
      }
      if (host == "") next
      printf "%s\t%s\t%s\n", host, prefix, slug
    }
  '
}

# --- build the host -> prefix-count map from a README blob -------------------
# Populates two assoc arrays keyed by host (and host|prefix):
#   HOSTS_SEEN[host]=1
#   PREFIX_COUNT[host SUBSEP prefix]=N
# When $1 (an exclude-slug list, newline-separated) is given, rows whose slug is
# in it are NOT counted — so a proposed/added slug never registers itself as an
# established sibling.
declare -A HOSTS_SEEN=()
declare -A PREFIX_COUNT=()
build_map() {
  local blob="$1" exclude="${2:-}"
  HOSTS_SEEN=(); PREFIX_COUNT=()
  local host prefix slug
  while IFS=$'\t' read -r host prefix slug; do
    [ -n "$host" ] || continue
    if [ -n "$exclude" ] && printf '%s\n' "$exclude" | grep -qxF "$slug"; then
      continue
    fi
    HOSTS_SEEN["$host"]=1
    PREFIX_COUNT["$host"$'\x1f'"$prefix"]=$(( ${PREFIX_COUNT["$host"$'\x1f'"$prefix"]:-0} + 1 ))
  done < <(printf '%s\n' "$blob" | parse_rows)
}

# established_prefixes <host> -> prints "prefix\tcount" lines for the host, sorted
# by count descending then prefix, one per line. Empty if the host is unseen.
established_prefixes() {
  local host="$1" key prefix count
  for key in "${!PREFIX_COUNT[@]}"; do
    case "$key" in
      "$host"$'\x1f'*)
        prefix="${key#*$'\x1f'}"; count="${PREFIX_COUNT[$key]}"
        printf '%s\t%s\n' "$count" "$prefix" ;;
    esac
  done | sort -t$'\t' -k1,1nr -k2,2
}

# report_divergence <host> <proposed-prefix> <proposed-slug>
# Returns 0 if the prefix is established for the host (no divergence); 1 if it
# diverges. Prints the verdict either way.
report_divergence() {
  local host="$1" prefix="$2" slug="$3"
  if [ -z "${HOSTS_SEEN[$host]:-}" ]; then
    [ "$QUIET" = 1 ] || echo "  ok       $slug -> prefix '$prefix' for host '$host' (new host; no siblings to diverge from)"
    return 0
  fi
  if [ -n "${PREFIX_COUNT["$host"$'\x1f'"$prefix"]:-}" ]; then
    [ "$QUIET" = 1 ] || echo "  ok       $slug -> prefix '$prefix' matches an established prefix for host '$host'"
    return 0
  fi
  # Divergence: enumerate the established prefixes, canonical (highest-count) first.
  local canon=""
  local -a lines=()
  while IFS=$'\t' read -r count pfx; do
    [ -n "$pfx" ] || continue
    [ -z "$canon" ] && canon="$pfx"
    lines+=("$pfx (used ${count}x)")
  done < <(established_prefixes "$host")
  echo "  DIVERGENCE $slug introduces prefix '$prefix' for host '$host',"
  echo "             which already uses: ${lines[*]}."
  echo "             Canonical sibling prefix: '$canon' — reuse it (e.g. '${canon}--<body>'),"
  echo "             or pass --allow-new-prefix to register a deliberately-new thematic cluster."
  return 1
}

# --- mode dispatch -----------------------------------------------------------
DIVERGENCES=0

case "$MODE" in
  propose)
    # Derive the host.
    host=""
    if [ -n "$PROPOSE_HOST" ]; then
      host="$PROPOSE_HOST"
      # normalize a URL passed to --host, and strip www.
      case "$host" in
        http://*|https://*) host="${host#*://}"; host="${host%%/*}" ;;
      esac
      host="${host#www.}"; host="${host%%:*}"
    elif [ -n "$PROPOSE_URL" ]; then
      host="${PROPOSE_URL#*://}"; host="${host%%/*}"; host="${host#www.}"; host="${host%%:*}"
    else
      # Look up the proposed slug's own row in the (working-tree) README.
      host="$(parse_rows < "$README" | awk -F'\t' -v s="$PROPOSE_SLUG" '$3==s{print $1; exit}')"
      if [ -z "$host" ]; then
        echo "library-slug-prefix-check: cannot derive a host for '$PROPOSE_SLUG'." >&2
        echo "  Pass --url <source-url> or --host <host>, or add the source's row to" >&2
        echo "  sources/README.md first (a row with a URL or owner/name in column 2)." >&2
        exit 2
      fi
    fi
    prefix="$PROPOSE_SLUG"
    case "$PROPOSE_SLUG" in *--*) prefix="${PROPOSE_SLUG%%--*}" ;; esac
    [ "$QUIET" = 1 ] || echo "mode: --propose $PROPOSE_SLUG (host '$host')"
    # Build the established map from the committed corpus, excluding the proposed
    # slug itself (so a row the scholar already wrote does not self-establish).
    build_map "$(cat "$README")" "$PROPOSE_SLUG"
    report_divergence "$host" "$prefix" "$PROPOSE_SLUG" || DIVERGENCES=1
    ;;

  changed)
    [ -n "$GIT_ROOT" ] || { echo "library-slug-prefix-check: --changed needs a git library; pass --library a git worktree" >&2; exit 2; }
    libpfx="$(realpath --relative-to="$GIT_ROOT" "$LIBRARY")"
    base_readme_rel="$libpfx/sources/README.md"
    base_blob="$(git -C "$GIT_ROOT" show "$BASE_REF:$base_readme_rel" 2>/dev/null || true)"
    [ -n "$base_blob" ] || echo "library-slug-prefix-check: note — no sources/README.md at $BASE_REF; treating all rows as new" >&2
    [ "$QUIET" = 1 ] || echo "mode: --changed since $BASE_REF ($LIBRARY)"
    # New slugs = rows present in the working-tree README but absent from base.
    base_slugs="$(printf '%s\n' "$base_blob" | parse_rows | cut -f3 | sort -u)"
    # Established map: the BASE corpus only.
    build_map "$base_blob"
    new_count=0
    while IFS=$'\t' read -r host prefix slug; do
      [ -n "$slug" ] || continue
      printf '%s\n' "$base_slugs" | grep -qxF "$slug" && continue   # not new
      new_count=$((new_count + 1))
      report_divergence "$host" "$prefix" "$slug" || DIVERGENCES=1
    done < <(parse_rows < "$README")
    [ "$new_count" -gt 0 ] || { [ "$QUIET" = 1 ] || echo "  (no new source rows since $BASE_REF)"; }
    ;;

  audit)
    [ "$QUIET" = 1 ] || echo "mode: --audit ($LIBRARY)"
    build_map "$(cat "$README")"
    suspects=0
    # For each host with >1 prefix, classify: any prefix used exactly once that
    # sits beside a prefix used more than once is a suspected accidental divergence.
    for host in "${!HOSTS_SEEN[@]}"; do
      mapfile -t rows < <(established_prefixes "$host")
      [ "${#rows[@]}" -gt 1 ] || continue
      has_established=0 has_singleton=0
      declare -a singletons=() established=()
      for r in "${rows[@]}"; do
        c="${r%%$'\t'*}"; p="${r#*$'\t'}"
        if [ "$c" -gt 1 ]; then has_established=1; established+=("$p (${c}x)"); else has_singleton=1; singletons+=("$p"); fi
      done
      if [ "$has_established" = 1 ] && [ "$has_singleton" = 1 ]; then
        suspects=$((suspects + 1)); DIVERGENCES=1
        echo "  SUSPECT  host '$host': singleton prefix(es) ${singletons[*]} beside established ${established[*]}"
        echo "           — a singleton may be an accidental divergence; confirm it names a real cluster."
      else
        [ "$QUIET" = 1 ] || echo "  ok       host '$host': multiple prefixes, all used >1x (${rows[*]//$'\t'/:})"
      fi
      unset singletons established
    done
    echo "----------------------------------------------------------------"
    if [ "$suspects" -gt 0 ]; then
      echo "library-slug-prefix-check: $suspects host(s) with a suspected divergent singleton prefix."
      exit 1
    fi
    echo "library-slug-prefix-check: OK — no host has a singleton prefix beside an established one."
    exit 0
    ;;
esac

# --- verdict (propose / changed) ---------------------------------------------
echo "----------------------------------------------------------------"
if [ "$DIVERGENCES" -gt 0 ]; then
  if [ "$ALLOW_NEW" = 1 ]; then
    echo "library-slug-prefix-check: WARN — prefix divergence(s) above, downgraded by"
    echo "--allow-new-prefix. Confirm each names a genuinely-new thematic cluster."
    exit 0
  fi
  echo "library-slug-prefix-check: FAIL — prefix divergence(s) above. Reuse the named"
  echo "canonical sibling prefix, or re-run with --allow-new-prefix if the new prefix"
  echo "deliberately names a distinct thematic cluster (per conventions.md § Slug pattern)."
  exit 1
fi
echo "library-slug-prefix-check: OK — every checked slug's prefix matches its host's siblings."
exit 0
