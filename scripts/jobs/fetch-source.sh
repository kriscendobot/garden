#!/bin/bash
# fetch-source.sh — deterministic primary-source fetcher with an Internet-Archive
# original-bytes fallback and a citable content hash.
#
# WHY THIS EXISTS. Scholar ingest cycles kept re-deriving the same acquisition
# dance by hand, and hand-recording it in prose (the grant-matcher ingest
# rediscovered it; the e-equality follow-on wrote it down). Three facts drive the
# recipe and none of them is a judgment call:
#
#   1. erights.org and its caplet.com mirror refuse connections from the bot
#      sandbox (recurring connection-refused / timeout), so the fetch must use a
#      substitute: the erights.org GitHub Pages mirror
#      (https://erights.github.io/erights-org-website/<path>, which preserves the
#      original paths and serves the HTML site) for what the mirror carries, and
#      the Wayback Machine for what it does not (PDFs / talk files 404 on the
#      mirror).
#   2. The WebFetch tool refuses web.archive.org outright, but plain `curl`
#      reaches it fine — so the fallback goes through curl, not a fetch tool.
#   3. The Wayback Machine REWRITES captured HTML/PDF bytes (injecting its
#      toolbar / rewriting links) UNLESS you request the original-capture form
#      `http://web.archive.org/web/<timestamp>id_/<url>`. The `id_` suffix returns
#      the unmodified bytes, which is what a stable, comparable SHA-256 demands;
#      omitting it corrupts the hash and defeats the idempotency anchor.
#
# "Fetch these bytes and hash them" is deterministic, so it lives here in plain
# code. The scholar's ingest procedure and `library/conventions.md`
# (§ PDF/source acquisition) cite this script in place of the prose recipe, so a
# scholar produces a consistent, hashable primary-source anchor every time
# instead of re-deriving the archive-fallback + hashing steps.
#
# WHAT IT DOES. Given a URL it:
#   1. tries a direct `curl` of the URL;
#   2. if the direct fetch fails AND the URL is on erights.org / caplet.com,
#      rewrites it to the GitHub Pages mirror
#      (https://erights.github.io/erights-org-website/<path>) and curls that —
#      reachable from the sandbox and higher-fidelity than a Wayback capture for
#      the HTML site;
#   3. if there are still no bytes (the mirror lacks the path — PDFs / talk files
#      404 — or the URL is not an erights/caplet URL), asks the Wayback
#      availability API for the closest capture timestamp and fetches the
#      original-bytes form  http://web.archive.org/web/<timestamp>id_/<url> ;
#   4. writes the fetched bytes (to the given output path, else a temp file) and
#      prints a one-line-per-field manifest on stdout whose key field is
#         source_content_sha256=<64-hex>
#      the citable idempotency anchor for the library source-file frontmatter.
#
# The bytes never go to stdout (a source may be a binary PDF); stdout is the
# manifest only, so the script composes in a pipeline (`eval "$(fetch-source.sh
# URL)"` exports the fields). Diagnostics go to stderr.
#
# USAGE
#   fetch-source.sh <url> [<output-path>]
#   fetch-source.sh -h | --help
#
# Output manifest (stdout, one `key=value` per line):
#   source_url=<url as given>
#   source_effective_url=<the URL actually fetched (direct, mirror, or id_ form)>
#   source_fetched_via=direct|mirror|wayback   # which substitute, for provenance
#   source_output_path=<absolute path to the written bytes>
#   source_bytes=<integer byte count>
#   source_content_sha256=<64-hex>        # the citable idempotency anchor
#   source_wayback_timestamp=<14-digit>   # present only when fetched via wayback
#
# EXIT CODES
#   0  bytes fetched (direct, via the mirror, or via the archive) and hashed
#   1  direct, mirror, and archive fallback all failed to produce bytes
#   2  usage error
#
# CONFIG (overridable; the test harness points curl at a stub)
#   FETCH_SOURCE_CURL        curl binary / wrapper to use (default: curl)
#   FETCH_SOURCE_CONNECT_TIMEOUT   per-connection timeout, seconds (default: 20)
#   FETCH_SOURCE_MAX_TIME    overall per-request timeout, seconds (default: 120)
#   FETCH_SOURCE_WAYBACK_HOST  availability-API host (default: archive.org)
#
# This script makes network calls (a direct fetch, then possibly the erights
# mirror, the Wayback availability API, and an archive fetch). It writes ONLY to
# the output path (or a temp file) and never to the journal or any garden tree.

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="fetch-source"

require_tools curl sha256sum jq

CURL="${FETCH_SOURCE_CURL:-curl}"
CONNECT_TIMEOUT="${FETCH_SOURCE_CONNECT_TIMEOUT:-20}"
MAX_TIME="${FETCH_SOURCE_MAX_TIME:-120}"
WAYBACK_HOST="${FETCH_SOURCE_WAYBACK_HOST:-archive.org}"

usage() {
  awk 'NR>1 && /^#/{sub(/^# ?/,"");print;next} NR>1{exit}' "$0"
}

case "${1:-}" in
  -h|--help) usage; exit 0 ;;
  ''|-*) usage >&2; log "FATAL: usage: fetch-source.sh <url> [output-path]"; exit 2 ;;
esac

url="$1"
out="${2:-}"
if [ -z "$out" ]; then
  out="$(mktemp -t fetch-source.XXXXXX)"
fi
# Normalize the output path to absolute so the manifest is unambiguous.
out_dir="$(cd "$(dirname "$out")" && pwd)" || { log "FATAL: output directory for '$out' does not exist"; exit 2; }
out="$out_dir/$(basename "$out")"

# curl invocation shared by every fetch: fail on HTTP errors (-f), follow
# redirects (-L, needed for the Wayback id_ -> capture redirect), quiet but keep
# error text (-sS), and bound both the connect and the whole request.
_curl() {
  "$CURL" -fsSL \
    --connect-timeout "$CONNECT_TIMEOUT" \
    --max-time "$MAX_TIME" \
    -o "$out" \
    "$1"
}

fetched_via=""
effective_url=""
wayback_ts=""

# An erights.org / caplet.com URL has a directly-reachable GitHub Pages mirror
# (`erights.github.io/erights-org-website/<path>`) that preserves the original
# paths and serves the HTML site the sandbox cannot reach. Compute the mirror
# URL when the host is one the mirror carries; empty otherwise. The mirror does
# NOT carry PDFs / talk files (those 404), so the archive fallback below still
# covers what the mirror lacks.
mirror_url=""
if [[ "$url" =~ ^https?://(www\.)?(erights\.org|caplet\.com)/(.*)$ ]]; then
  mirror_url="https://erights.github.io/erights-org-website/${BASH_REMATCH[3]}"
fi

# --- 1. direct fetch --------------------------------------------------------
log "direct fetch: $url"
if _curl "$url" && [ -s "$out" ]; then
  fetched_via="direct"
  effective_url="$url"
fi

# --- 2. erights/caplet GitHub Pages mirror ----------------------------------
# Reachable from the sandbox where bare erights.org refuses connections, and it
# preserves the original paths. Higher fidelity than the Wayback capture for the
# HTML site (no toolbar / link rewriting), so it precedes the archive fallback.
# A 404 here (the mirror lacks PDFs / talk files) drops through to the archive.
if [ -z "$fetched_via" ] && [ -n "$mirror_url" ]; then
  : >"$out"   # discard any partial body the failed direct fetch left behind
  log "mirror fetch: $mirror_url"
  if _curl "$mirror_url" && [ -s "$out" ]; then
    fetched_via="mirror"
    effective_url="$mirror_url"
  else
    log "mirror fetch failed (curl rc=$?); the mirror lacks this path (PDFs 404) — falling back to the Internet Archive"
  fi
fi

# --- 3. Internet-Archive original-bytes fallback ----------------------------
if [ -z "$fetched_via" ]; then
  log "no direct/mirror bytes; falling back to the Internet Archive"
  : >"$out"   # discard any partial body a failed earlier fetch left behind

  # --- 3a. ask the Wayback availability API for the closest capture ----------
  # Returns {"archived_snapshots":{"closest":{"timestamp":"<14d>","url":"..."}}}
  # or {"archived_snapshots":{}} when nothing is captured. jq extracts the
  # timestamp; we do NOT swallow jq/curl errors (a silent empty here is exactly
  # the failure mode that wedged comms before — see the missing-tool lesson).
  avail_url="http://${WAYBACK_HOST}/wayback/available?url=${url}"
  log "wayback availability: $avail_url"
  if avail_json="$("$CURL" -fsSL --connect-timeout "$CONNECT_TIMEOUT" --max-time "$MAX_TIME" "$avail_url")"; then
    wayback_ts="$(printf '%s' "$avail_json" | jq -r '.archived_snapshots.closest.timestamp // empty')"
  else
    log "wayback availability API unreachable (curl rc=$?)"
    wayback_ts=""
  fi

  # --- 3b. fetch the ORIGINAL bytes via the id_ form -------------------------
  # The id_ suffix after the timestamp returns the unmodified capture (no
  # Wayback toolbar / link rewriting), which is what makes the SHA-256 stable
  # and comparable to a direct fetch. With a known timestamp, request it
  # exactly; with none, the bare `2id_` form lets Wayback redirect (-L) to its
  # nearest original capture as a last resort.
  if [ -n "$wayback_ts" ]; then
    archive_url="http://web.archive.org/web/${wayback_ts}id_/${url}"
  else
    log "no availability timestamp; trying the redirect form"
    archive_url="http://web.archive.org/web/2id_/${url}"
  fi
  log "archive fetch: $archive_url"
  if _curl "$archive_url" && [ -s "$out" ]; then
    fetched_via="wayback"
    effective_url="$archive_url"
  else
    rc=$?
    log "FATAL: archive fallback also failed (curl rc=${rc:-?}); no bytes for $url"
    rm -f "$out"
    exit 1
  fi
fi

# --- 3. hash + manifest -----------------------------------------------------
sha="$(sha256sum <"$out" | awk '{print $1}')"
bytes="$(wc -c <"$out" | tr -d ' ')"

log "fetched ${bytes}B via ${fetched_via}; sha256=${sha}"

printf 'source_url=%s\n'            "$url"
printf 'source_effective_url=%s\n'  "$effective_url"
printf 'source_fetched_via=%s\n'    "$fetched_via"
printf 'source_output_path=%s\n'    "$out"
printf 'source_bytes=%s\n'          "$bytes"
printf 'source_content_sha256=%s\n' "$sha"
[ -n "$wayback_ts" ] && printf 'source_wayback_timestamp=%s\n' "$wayback_ts"
exit 0
