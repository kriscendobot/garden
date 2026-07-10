#!/bin/bash
# check-issue-refs.sh — deterministic, Markdown-aware gate that REJECTS a message
# body containing an apparently partially-qualified GitHub issue/PR reference, so a
# bare `#N` never enters the message bus in the first place (fixing it at the source
# instead of resolving it heuristically downstream in the bulletin).
#
# Usage: check-issue-refs.sh [<body-file>]     (body on stdin when omitted or '-')
#
# Exit 0  — clean: no partial reference (all refs are fully-qualified or exempt).
# Exit 1  — one or more partial references found; a per-reference report naming the
#           line and the offending token, plus a one-line remedy, is printed to
#           STDERR. The calling send primitive does NOT post the body.
# Exit 2  — usage / unreadable body-file.
#
# No LLM: a single awk pass. Rule kept deliberately tight and documented:
#   FORBIDDEN (partial) — resolves only with out-of-band context:
#     * a bare `#N`     — `#` + 1-6 digits at a word boundary
#     * `owner#N`       — a bare word + `#N`, with no `/repo`
#     * `GH-N`          — the GitHub short-ref form
#   ALLOWED (fully-qualified) — resolves standalone, so it passes:
#     * `owner/repo#N`
#     * a full https://github.com/owner/repo/(issues|pull)/N URL (optional #fragment)
#   EXEMPT (never scanned) — Markdown code, where a `#N` is prose/vocabulary not a ref:
#     * fenced code blocks (``` and ~~~, optional leading whitespace + info string)
#     * inline `code` spans (the same false-positive class the bulletin linkifier hit,
#       e.g. `rebase #652`, `run the gauntlet #N`)
#   An ATX heading marker (`# ` / `## `) is not a `#N` ref (a digit must abut the `#`),
#   and a `#RRGGBB` hex colour is dodged by the digits-only rule + the code-span exempt.
set -euo pipefail

src="${1:--}"
if [ "$src" = "-" ]; then
  body="$(cat)"
elif [ -f "$src" ]; then
  body="$(cat "$src")"
else
  echo "check-issue-refs.sh: no such body file: $src" >&2
  exit 2
fi

report="$(printf '%s\n' "$body" | awk '
  # Replace every match of re with a single space: drops the span from scanning
  # while preserving the token boundaries around it.
  function strip(s, re,   out) {
    out = ""
    while (match(s, re)) { out = out substr(s, 1, RSTART-1) " "; s = substr(s, RSTART+RLENGTH) }
    return out s
  }
  BEGIN { fence = 0 }
  {
    line = $0
    # Fenced code block: toggle on ``` or ~~~ (optional indent + info string). The
    # fence markers and everything between them are never scanned.
    if (line ~ /^[[:space:]]*(```|~~~)/) { fence = !fence; next }
    if (fence) next
    # Blank the exempt / fully-qualified spans so only partial refs can remain:
    #   1) inline `code` spans
    #   2) full issue/PR URLs (with an optional #fragment such as #issuecomment-N)
    #   3) fully-qualified owner/repo#N slugs
    s = line
    s = strip(s, "`[^`]*`")
    s = strip(s, "https?://github[.]com/[A-Za-z0-9._-]+/[A-Za-z0-9._-]+/(issues|pull)/[0-9]+(#[A-Za-z0-9._-]+)?")
    s = strip(s, "[A-Za-z0-9][A-Za-z0-9._-]*/[A-Za-z0-9._-]+#[0-9]+")
    # What survives: bare `#N` and `owner#N` (a word prefix, then `#` + digits).
    rest = s
    while (match(rest, /[A-Za-z0-9._-]*#[0-9]+/)) {
      tok = substr(rest, RSTART, RLENGTH)
      after = substr(rest, RSTART + RLENGTH, 1)
      hp = index(tok, "#"); dig = substr(tok, hp + 1)
      # Issue-shaped only: 1-6 digits abutting `#`, followed by a non-alphanumeric
      # boundary (so `#12ab`, a 7+-digit run, and `# heading` are all skipped).
      if (length(dig) <= 6 && after !~ /[A-Za-z0-9]/)
        printf "  line %d: %s\n", NR, tok
      rest = substr(rest, RSTART + RLENGTH)
    }
    # And the `GH-N` short-ref form, at a word boundary.
    rest = s
    while (match(rest, /GH-[0-9]+/)) {
      before = (RSTART > 1) ? substr(rest, RSTART - 1, 1) : ""
      after  = substr(rest, RSTART + RLENGTH, 1)
      if (before !~ /[A-Za-z0-9]/ && after !~ /[0-9]/)
        printf "  line %d: %s\n", NR, substr(rest, RSTART, RLENGTH)
      rest = substr(rest, RSTART + RLENGTH)
    }
  }
')"

if [ -n "$report" ]; then
  {
    echo "message REJECTED — apparently partially-qualified issue/PR reference(s):"
    printf '%s\n' "$report"
    echo "remedy: fully-qualify each as \`owner/repo#N\` or a full https://github.com/owner/repo/issues/N (or /pull/N) URL."
    echo "(references inside code fences (\`\`\` / ~~~) or inline \`code\` spans are exempt.)"
  } >&2
  exit 1
fi
exit 0
