#!/bin/bash
# check-source-children.sh — deterministic child-reachability probe for a hub /
# nav page, so a scholar plans its ingest sections from a scripted reachable/dead
# manifest instead of hand-probing every link.
#
# WHY THIS EXISTS. A scholar ingest cycle that starts from a hub page (an
# `index.html` nav map: `elang/`, `data/`, `guarding/`, ...) has to know which of
# the hub's child links actually resolve before it spends the cycle's section
# budget reading them. Two scholar results in one capture each re-derived this
# probe in prose ("verify reachability via fetch-source.sh before planning
# sections"), and a missed probe burned a whole ingest cycle chasing a page that
# was never written upstream (`elang/guarding/style.html` — a dead nav link).
# "Fetch the hub, pull its child hrefs, probe each one the same way" is
# deterministic, so it lives here in plain code: the scholar runs it once and
# reads a reachable/dead list, and the recurring "verify reachability" caution no
# longer has to ride along in every follow-on job body.
#
# WHAT IT DOES. Given a hub URL (the canonical `erights.org/...` form is
# preferred; the `erights.github.io/...` mirror-URL form also works):
#   1. fetches the hub/nav page through scripts/jobs/fetch-source.sh — the same
#      direct -> erights GitHub Pages mirror -> Internet-Archive `id_` fallback
#      path every scholar source acquisition uses;
#   2. extracts the child hrefs from the hub's HTML, resolving each relative href
#      against the hub URL and keeping only same-host children (the nav map's own
#      pages — external links are not the hub's children);
#   3. probes each child through the SAME fetch-source.sh logic, and before
#      declaring a child dead retries the toggled www / no-www host form (a
#      capture may live under only one of them);
#   4. emits a one-line-per-child manifest on stdout classifying each child as
#      `reachable` (served by the mirror, the archive, or a direct fetch) or
#      `dead` (404 on both the mirror and the Archive, www/no-www tried).
#
# Stdout is the manifest only (one `key=value` line per child), so the script
# composes in a pipeline; diagnostics and the summary go to stderr.
#
# USAGE
#   check-source-children.sh <hub-url-or-mirror-path>
#   check-source-children.sh -h | --help
#
# Output manifest (stdout, one line per child, space-separated key=value):
#   child_url=<resolved absolute URL>
#   child_status=reachable|dead
#   child_via=direct|mirror|wayback|-     # how it was served; - when dead
# A trailing comment line is NOT emitted; the count summary goes to stderr.
#
# EXIT CODES
#   0  the hub was fetched and every child probed (some children may be `dead`;
#      a dead child is a manifest row, not a script failure)
#   1  the hub page itself could not be fetched (nothing to enumerate)
#   2  usage error
#
# CONFIG (overridable; the test harness points these at stubs)
#   CHECK_SOURCE_FETCH   path to fetch-source.sh (default: sibling script)
#   plus every FETCH_SOURCE_* variable fetch-source.sh honors, passed through.
#
# This script makes network calls only through fetch-source.sh (once for the
# hub, once or twice per child). It writes ONLY to a private temp file it
# discards, and never to the journal or any garden tree.

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="check-source-children"

require_tools curl sha256sum jq grep sed

FETCH="${CHECK_SOURCE_FETCH:-$HERE/fetch-source.sh}"
[ -x "$FETCH" ] || die "fetch-source.sh not found or not executable at: $FETCH"

usage() {
  awk 'NR>1 && /^#/{sub(/^# ?/,"");print;next} NR>1{exit}' "$0"
}

case "${1:-}" in
  -h|--help) usage; exit 0 ;;
  ''|-*) usage >&2; log "FATAL: usage: check-source-children.sh <hub-url-or-mirror-path>"; exit 2 ;;
esac

hub="$1"

# --- tiny URL toolkit -------------------------------------------------------
# These operate on http(s) URLs as plain strings; the hub and its children are
# always absolute http(s) URLs by the time they reach here.

url_scheme() { printf '%s' "${1%%://*}"; }
url_host()   { local r="${1#*://}"; printf '%s' "${r%%/*}"; }
# Path including the leading slash; "/" when the URL has no path component.
url_path() {
  local r="${1#*://}"
  case "$r" in
    */*) printf '%s' "/${r#*/}" ;;
    *)   printf '/' ;;
  esac
}

# normalize_url <abs-url> — collapse `.` and `..` and empty (`//`) path segments,
# preserving a trailing slash (a directory hub) so the probe hits the right form.
normalize_url() {
  local u="$1" scheme host path trailing=0
  scheme="$(url_scheme "$u")"; host="$(url_host "$u")"; path="$(url_path "$u")"
  [[ "$path" == */ && "$path" != / ]] && trailing=1
  local out=() seg parts IFS=/
  read -ra parts <<<"$path"
  for seg in "${parts[@]}"; do
    case "$seg" in
      ''|.) : ;;                                   # drop empty (//) and .
      ..)   [ "${#out[@]}" -gt 0 ] && unset 'out[${#out[@]}-1]' ;;
      *)    out+=("$seg") ;;
    esac
  done
  local joined=""
  if [ "${#out[@]}" -gt 0 ]; then printf -v joined '/%s' "${out[@]}"; else joined="/"; fi
  [ "$trailing" = 1 ] && [ "$joined" != "/" ] && joined="$joined/"
  printf '%s://%s%s' "$scheme" "$host" "$joined"
}

# resolve_href <base-url> <href> — resolve a possibly-relative href against the
# hub URL into a normalized absolute http(s) URL. Echoes nothing for hrefs that
# are not http(s) resources (mailto:, javascript:, fragment-only, ...).
resolve_href() {
  local base="$1" href="$2"
  href="${href%%#*}"                               # strip any #fragment
  href="${href%%$'\r'}"                            # strip a stray CR
  [ -z "$href" ] && return 0                        # was a pure fragment
  case "$href" in
    mailto:*|javascript:*|tel:*|data:*|ftp:*) return 0 ;;
    [a-zA-Z]*://*)                                  # already absolute
      normalize_url "$href"; return 0 ;;
    //*)                                            # scheme-relative
      normalize_url "$(url_scheme "$base"):$href"; return 0 ;;
    /*)                                             # host-absolute
      normalize_url "$(url_scheme "$base")://$(url_host "$base")$href"; return 0 ;;
  esac
  # Document-relative: append to the hub URL's directory.
  local dir="${base%%#*}"; dir="${dir%%\?*}"
  dir="${dir%/*}/"                                   # up to and including last /
  normalize_url "${dir}${href}"
}

# toggle_www <url> — swap the www. host prefix on or off; echoes the alternate
# form. A capture / mirror entry may exist under only one of the two.
toggle_www() {
  local u="$1" scheme host rest
  scheme="$(url_scheme "$u")"; host="$(url_host "$u")"; rest="${u#"$scheme"://"$host"}"
  case "$host" in
    www.*) printf '%s://%s%s' "$scheme" "${host#www.}" "$rest" ;;
    *)     printf '%s://www.%s%s' "$scheme" "$host" "$rest" ;;
  esac
}

# --- href extraction --------------------------------------------------------
# Pull the raw value of every href= attribute from an HTML document on stdin,
# one per line, with surrounding quotes stripped. Tolerant of single/double/no
# quotes and of whitespace around the `=`.
extract_hrefs() {
  grep -oiE "href[[:space:]]*=[[:space:]]*(\"[^\"]*\"|'[^']*'|[^][:space:]\"'>]+)" \
    | sed -E "s/^[Hh][Rr][Ee][Ff][[:space:]]*=[[:space:]]*//; s/^\"//; s/\"\$//; s/^'//; s/'\$//"
}

# --- probe one child --------------------------------------------------------
# Echoes the serving channel (direct|mirror|wayback) if fetch-source.sh obtains
# bytes for the URL, empty otherwise. Bytes are written to $probe_out and
# discarded.
probe_via() {
  local u="$1" man
  if man="$("$FETCH" "$u" "$probe_out" 2>/dev/null)"; then
    printf '%s' "$man" | sed -n 's/^source_fetched_via=//p'
  fi
}

# --- 1. fetch the hub -------------------------------------------------------
hub_html="$(mktemp -t check-source-children-hub.XXXXXX)" || die "cannot mktemp"
probe_out="$(mktemp -t check-source-children-probe.XXXXXX)" || die "cannot mktemp"
trap 'rm -f "$hub_html" "$probe_out"' EXIT

log "fetching hub: $hub"
if ! "$FETCH" "$hub" "$hub_html" >/dev/null 2>&1; then
  die "hub page is unreachable through fetch-source.sh: $hub (nothing to enumerate)"
fi

# The hub URL fetch-source.sh actually resolved may differ from the argument
# (e.g. an erights.org hub served via the mirror), but child hrefs are resolved
# against the CANONICAL hub argument so the manifest carries canonical URLs.
hub_host="$(url_host "$hub")"

# --- 2. extract + resolve the child hrefs -----------------------------------
declare -A seen=()
children=()
while IFS= read -r raw; do
  [ -n "$raw" ] || continue
  resolved="$(resolve_href "$hub" "$raw")"
  [ -n "$resolved" ] || continue
  # Keep only same-host children (the nav map's own pages); drop the hub itself.
  [ "$(url_host "$resolved")" = "$hub_host" ] || continue
  [ "$resolved" = "$hub" ] && continue
  [ -n "${seen[$resolved]:-}" ] && continue
  seen[$resolved]=1
  children+=("$resolved")
done < <(extract_hrefs <"$hub_html")

log "hub yielded ${#children[@]} same-host child link(s)"

# --- 3. probe each child + 4. emit the manifest -----------------------------
reachable=0; dead=0
for child in "${children[@]}"; do
  via="$(probe_via "$child")"
  if [ -z "$via" ]; then
    # Retry the toggled www / no-www form before declaring the child dead.
    alt="$(toggle_www "$child")"
    if [ "$alt" != "$child" ]; then
      via="$(probe_via "$alt")"
    fi
  fi
  if [ -n "$via" ]; then
    reachable=$((reachable+1))
    printf 'child_url=%s child_status=reachable child_via=%s\n' "$child" "$via"
  else
    dead=$((dead+1))
    printf 'child_url=%s child_status=dead child_via=-\n' "$child"
  fi
done

log "probed ${#children[@]} child(ren): ${reachable} reachable, ${dead} dead"
exit 0
