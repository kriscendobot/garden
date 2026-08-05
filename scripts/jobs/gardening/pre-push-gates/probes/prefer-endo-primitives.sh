#!/bin/bash
# prefer-endo-primitives.sh -- reject recognizable hand-rolled Endo primitives.
#
# This is deliberately a signature catalog, not a general duplicate-code
# detector. It catches the concrete shapes in the prefer-endo-primitives review
# cluster and stays silent when the same file imports the corresponding @endo
# package. A file with an unavoidable implementation may opt out with
# `prefer-endo-primitives-exempt` in its first five lines.

set -uo pipefail

classify() {
  awk -F '\t' '
    function remember(file, package, signature, key) {
      key = file SUBSEP package SUBSEP signature
      if (!(key in seen)) {
        seen[key] = 1
        candidateFile[++candidateCount] = file
        candidatePackage[candidateCount] = package
        candidateSignature[candidateCount] = signature
      }
    }
    {
      file = $1
      line = substr($0, index($0, "\t") + 1)

      providerLine = line ~ /^@@provider / ||
        line ~ /^[[:space:]]*(import|export)[[:space:]]/ ||
        line ~ /[[:space:]]from[[:space:]]*["\047]/ ||
        line ~ /(require|import)[[:space:]]*\([[:space:]]*["\047]/
      if (providerLine && line ~ /@endo\/sha256/) provided[file SUBSEP "@endo/sha256"] = 1
      if (providerLine && line ~ /@endo\/bytes/) provided[file SUBSEP "@endo/bytes"] = 1
      if (providerLine && line ~ /@endo\/hex/) provided[file SUBSEP "@endo/hex"] = 1
      if (providerLine && line ~ /@endo\/ascii/) provided[file SUBSEP "@endo/ascii"] = 1
      if (providerLine && line ~ /@endo\/base64/) provided[file SUBSEP "@endo/base64"] = 1
      if (providerLine && line ~ /@endo\/errors/) provided[file SUBSEP "@endo/errors"] = 1

      # Do not interpret prose-only comment lines as executable signatures.
      code = line
      sub(/^[[:space:]]+/, "", code)
      if (code ~ /^(\/\/|\/\*|\*|#)/) next

      if (code ~ /createHash[[:space:]]*\([[:space:]]*["\047](sha-?256|SHA-?256)/ ||
          code ~ /subtle\.digest[[:space:]]*\([[:space:]]*["\047]SHA-?256/) {
        remember(file, "@endo/sha256", "hand-rolled SHA-256")
      }
      if (code ~ /new[[:space:]]+Text(Encoder|Decoder)[[:space:]]*\(/) {
        remember(file, "@endo/bytes", "direct TextEncoder/TextDecoder")
      }
      if (code ~ /(^|[^A-Za-z0-9_$])(atob|btoa)[[:space:]]*\(/ ||
          code ~ /\.toString[[:space:]]*\([[:space:]]*["\047]base64["\047]/ ||
          code ~ /Buffer\.from[[:space:]]*\([^\n]*["\047]base64["\047]/) {
        remember(file, "@endo/base64", "hand-rolled base64 conversion")
      }
      if (code ~ /\.toString[[:space:]]*\([[:space:]]*16[[:space:]]*\)[[:space:]]*\.padStart[[:space:]]*\([[:space:]]*2[[:space:]]*,/) {
        remember(file, "@endo/hex", "byte-to-hex loop")
      }
      if (code ~ /Uint8Array\.from[[:space:]]*\([^\n]*charCodeAt[[:space:]]*\(/) {
        remember(file, "@endo/ascii", "hand-rolled ASCII conversion")
      }
      if (code ~ /(^|[[:space:]])(const|let|var|function)[[:space:]]+insist[A-Za-z0-9_$]*/) {
        remember(file, "@endo/errors", "hand-rolled insist/assert helper")
      }
    }
    END {
      findings = 0
      for (i = 1; i <= candidateCount; i++) {
        file = candidateFile[i]
        package = candidatePackage[i]
        if (!provided[file SUBSEP package]) {
          findings++
          printf "fail: %s adds %s; use %s (or mark a justified prefer-endo-primitives-exempt file)\n", file, candidateSignature[i], package
        }
      }
      if (findings == 0) { print "pass"; exit 0 }
      exit 1
    }
  '
}

is_source() {
  case "$1" in
    *.js|*.mjs|*.cjs|*.jsx|*.ts|*.tsx) return 0 ;;
    *) return 1 ;;
  esac
}

is_exempt() {
  local file="$1" content
  content=$(git show ":$file" 2>/dev/null) || content=""
  [ -z "$content" ] && content=$(cat "$file" 2>/dev/null)
  printf '%s\n' "$content" | head -5 | grep -q 'prefer-endo-primitives-exempt'
}

added_lines_for() {
  local file="$1" diff
  diff=$(git diff --staged -U0 -- "$file" 2>/dev/null)
  [ -z "$diff" ] && diff=$(git diff -U0 -- "$file" 2>/dev/null)
  printf '%s\n' "$diff" \
    | grep '^+' | grep -v '^+++' | sed 's/^+//' \
    | awk -v file="$file" '{ print file "\t" $0 }'
}

run_probe() {
  local root="${1:-.}" files stream
  cd "$root" 2>/dev/null || { echo "fail: cannot enter project root '$root'"; return 1; }
  files=$(git diff --staged --name-only --diff-filter=d 2>/dev/null)
  [ -z "$files" ] && files=$(git diff --name-only --diff-filter=d 2>/dev/null)

  stream=$(
    while IFS= read -r file; do
      [ -z "$file" ] && continue
      is_source "$file" || continue
      is_exempt "$file" && continue
      added_lines_for "$file"
      # Existing imports may not be added lines. Feed only provider markers from
      # the post-change file so old implementation lines cannot become findings.
      grep -E "^[[:space:]]*(import|export)|[[:space:]]from[[:space:]]*['\"]|(^|[^[:alnum:]_])(require|import)[[:space:]]*\\(" "$file" 2>/dev/null \
        | grep -oE '@endo/(sha256|bytes|hex|ascii|base64|errors)' \
        | sort -u | awk -v file="$file" '{ print file "\t@@provider " $0 }'
    done <<EOF
$files
EOF
  )

  if [ -z "$stream" ]; then echo pass; return 0; fi
  printf '%s\n' "$stream" | classify
}

case "${1:-}" in
  --scan-stdin)
    label="${2:-<stdin>}"
    awk -v file="$label" '{ print file "\t" $0 }' | classify
    ;;
  *)
    run_probe "${1:-.}"
    ;;
esac
