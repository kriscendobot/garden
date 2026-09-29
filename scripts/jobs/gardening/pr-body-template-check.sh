#!/bin/bash
# pr-body-template-check.sh — does a PR body follow the base branch's GitHub PR
# template? Deterministic, no LLM.
#
# The review-miss cluster `pr-description-reviewer-attention`
# (endojs/endo-but-for-bots#1281): an upstream-based PR was opened with invented
# sections ("Goal", "What was noisy", ...) instead of the base branch's
# `.github/PULL_REQUEST_TEMPLATE.md` headings, and six panel rounds with the
# integrator seated (whose brief asks exactly this) never flagged it. The rule
# lives in skills/pr-formation § Use the upstream template, section for section;
# this script is the check that cannot forget it. ensure-pr.sh runs it before
# opening a PR, and panel.sh runs it every round against the live body.
#
# What it checks, when the base branch carries a template:
#   missing     every template `##`/`###` heading appears in the body, in order
#               (matched case-insensitively on its text; the level is not
#               compared). A missing or out-of-order heading is NONCONFORMING.
#   guidance    no template guidance survives in the body: a template blockquote
#               line (`> Add a description of ...`) or a `#XXXX` issue
#               placeholder. NONCONFORMING.
#   invented    a body `##`/`###` heading the template does not name. ATTENTION
#               only: a garden-mandated addition (the phase/evidence ledger,
#               skills/pr-formation) is legitimate, and the missing check already
#               catches a body that replaced the template's structure.
# Headings inside fenced code blocks and HTML comments are ignored, so the
# template's own commented-out prompts and the job marker never count.
#
# Usage:
#   pr-body-template-check.sh (--body-file F | --repo R --pr N)
#                             (--template-file T | --base-ref REF [--worktree WT] [--repo R])
#                             [--evidence-file E] [--body-out O]
#
#   --body-file    the body to check (the file ensure-pr.sh is about to submit).
#   --repo/--pr    fetch the LIVE body of PR N (panel mode).
#   --template-file  the template, read directly.
#   --base-ref     resolve the template at this ref: from `git -C WT show` when
#                  --worktree is given (offline; panel mode, where the ref is the
#                  PR's base in the project checkout), else from GitHub via
#                  GraphQL on --repo (ensure-pr mode). GraphQL, not REST contents,
#                  because the REST quota is the one the fleet exhausts first.
#   --evidence-file  write the findings as Markdown (for the integrator).
#   --body-out     copy the resolved body here (panel.sh reuses it for the
#                  concision probe instead of fetching twice).
#
# Exit codes:
#   0   conforming, or the base branch has no template (nothing to conform to)
#   10  ATTENTION: only invented headings
#   20  NONCONFORMING: missing/out-of-order headings or leftover guidance
#   3   could not resolve the body or the template (a read failed); fail open
#   1   usage error
# Findings go to stdout, one per line.
#
# Test seam: GARDEN_GH (the gh binary). PR bodies are untrusted data: this script
# only compares lines, never evaluates them.

set -uo pipefail

TEMPLATE_PATHS=".github/PULL_REQUEST_TEMPLATE.md .github/pull_request_template.md PULL_REQUEST_TEMPLATE.md pull_request_template.md docs/PULL_REQUEST_TEMPLATE.md docs/pull_request_template.md"

body_file=""; repo=""; pr=""; template_file=""; base_ref=""; worktree=""
evidence_file=""; body_out=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --body-file)     body_file="${2:?}"; shift 2 ;;
    --repo)          repo="${2:?}"; shift 2 ;;
    --pr)            pr="${2:?}"; shift 2 ;;
    --template-file) template_file="${2:?}"; shift 2 ;;
    --base-ref)      base_ref="${2:?}"; shift 2 ;;
    --worktree)      worktree="${2:?}"; shift 2 ;;
    --evidence-file) evidence_file="${2:?}"; shift 2 ;;
    --body-out)      body_out="${2:?}"; shift 2 ;;
    *) echo "pr-body-template-check: unknown argument: $1" >&2; exit 1 ;;
  esac
done

GH="${GARDEN_GH:-gh}"
TMP="$(mktemp -d "${TMPDIR:-/tmp}/pr-body-template-check.XXXXXX")"
trap 'rm -rf "$TMP"' EXIT

unresolved() { echo "pr-body-template-check: $*" >&2; exit 3; }

# --- resolve the body --------------------------------------------------------
if [ -n "$body_file" ]; then
  [ -r "$body_file" ] || unresolved "body file '$body_file' is not readable"
  cp "$body_file" "$TMP/body"
elif [ -n "$repo" ] && [ -n "$pr" ]; then
  "$GH" pr view "$pr" --repo "$repo" --json body >"$TMP/body.json" 2>"$TMP/err" \
    || unresolved "could not fetch the body of $repo#$pr: $(cat "$TMP/err")"
  jq -r '.body // ""' "$TMP/body.json" >"$TMP/body" 2>/dev/null \
    || unresolved "unparseable body for $repo#$pr"
else
  echo "pr-body-template-check: need --body-file or --repo with --pr" >&2; exit 1
fi
[ -z "$body_out" ] || cp "$TMP/body" "$body_out"

# --- resolve the template ----------------------------------------------------
# An ABSENT template is a conclusive "nothing to check" (exit 0); a failed read is
# unresolved (exit 3), never mistaken for absence.
if [ -n "$template_file" ]; then
  [ -r "$template_file" ] || unresolved "template file '$template_file' is not readable"
  cp "$template_file" "$TMP/template"
elif [ -n "$base_ref" ] && [ -n "$worktree" ]; then
  git -C "$worktree" rev-parse --verify --quiet "$base_ref^{commit}" >/dev/null 2>&1 \
    || unresolved "base ref '$base_ref' does not resolve in $worktree"
  for p in $TEMPLATE_PATHS; do
    if git -C "$worktree" show "$base_ref:$p" >"$TMP/template" 2>/dev/null; then
      template_file="$base_ref:$p"; break
    fi
  done
  [ -n "$template_file" ] || { echo "no PR template on $base_ref"; exit 0; }
elif [ -n "$base_ref" ] && [ -n "$repo" ]; then
  owner="${repo%%/*}"; name="${repo#*/}"
  q='query($o:String!,$n:String!,$e:String!){repository(owner:$o,name:$n){object(expression:$e){... on Blob{text}}}}'
  for p in $TEMPLATE_PATHS; do
    "$GH" api graphql -f query="$q" -f o="$owner" -f n="$name" -f e="$base_ref:$p" \
      >"$TMP/tpl.json" 2>"$TMP/err" \
      || unresolved "could not read $p on $repo@$base_ref: $(cat "$TMP/err")"
    jq -e '.data.repository' "$TMP/tpl.json" >/dev/null 2>&1 \
      || unresolved "unexpected GraphQL response reading $p on $repo@$base_ref"
    if jq -e '.data.repository.object.text | strings' "$TMP/tpl.json" >/dev/null 2>&1; then
      jq -r '.data.repository.object.text' "$TMP/tpl.json" >"$TMP/template"
      template_file="$repo@$base_ref:$p"; break
    fi
  done
  [ -n "$template_file" ] || { echo "no PR template on $repo@$base_ref"; exit 0; }
else
  echo "pr-body-template-check: need --template-file or --base-ref (with --worktree or --repo)" >&2; exit 1
fi

# --- compare -----------------------------------------------------------------
# visible <file>: the lines a reader sees, minus fenced code and HTML comments.
visible() {
  awk '
    BEGIN { fence = 0; comment = 0 }
    {
      line = $0
      if (!comment && line ~ /^[[:space:]]*(```|~~~)/) { fence = !fence; next }
      if (fence) next
      out = ""
      while (line != "") {
        if (comment) {
          i = index(line, "-->")
          if (i == 0) { line = ""; break }
          line = substr(line, i + 3); comment = 0
        } else {
          i = index(line, "<!--")
          if (i == 0) { out = out line; line = ""; break }
          out = out substr(line, 1, i - 1); line = substr(line, i + 4); comment = 1
        }
      }
      print out
    }' "$1"
}

# headings <file>: normalized `##`/`###` heading texts, in order.
headings() {
  visible "$1" | sed -nE 's/^ {0,3}#{2,3}[[:space:]]+(.*)$/\1/p' \
    | sed -E 's/[[:space:]]+#+[[:space:]]*$//; s/[[:space:]]+/ /g; s/^ //; s/ $//' \
    | tr '[:upper:]' '[:lower:]'
}

headings "$TMP/template" >"$TMP/t.h"
headings "$TMP/body" >"$TMP/b.h"

findings=()
blocking=0; attention=0

# In-order matching: each template heading must appear after the previous match.
pos=0
while IFS= read -r th; do
  [ -n "$th" ] || continue
  hit="$(awk -v want="$th" -v from="$pos" 'NR > from && $0 == want { print NR; exit }' "$TMP/b.h")"
  if [ -n "$hit" ]; then
    pos="$hit"
  elif grep -qxF -- "$th" "$TMP/b.h"; then
    findings+=("out-of-order: template heading \"$th\" appears before a heading the template puts ahead of it")
    blocking=1
  else
    findings+=("missing: template heading \"$th\" is absent (keep every template heading; write one sentence when a section does not apply)")
    blocking=1
  fi
done <"$TMP/t.h"

# Headings the body adds. The phase/evidence ledger is a garden-mandated section.
while IFS= read -r bh; do
  [ -n "$bh" ] || continue
  grep -qxF -- "$bh" "$TMP/t.h" && continue
  case "$bh" in "phase and evidence ledger") continue ;; esac
  findings+=("invented: body heading \"$bh\" is not in the template")
  attention=1
done <"$TMP/b.h"

# Leftover guidance: template blockquote lines kept verbatim, and `#XXXX`
# placeholders.
visible "$TMP/body" | sed -E 's/[[:space:]]+$//' >"$TMP/b.v"
visible "$TMP/template" | sed -E 's/[[:space:]]+$//' | grep -E '^ {0,3}>[[:space:]]*[^[:space:]].{15,}' \
  | while IFS= read -r g; do
      grep -qxF -- "$g" "$TMP/b.v" && printf '%s\n' "$g"
    done >"$TMP/leftover"
while IFS= read -r g; do
  findings+=("guidance: template guidance left in the body: \"${g:0:90}\"")
  blocking=1
done <"$TMP/leftover"
if grep -qE '#XXXX\b' "$TMP/b.v"; then
  findings+=("guidance: an issue placeholder (#XXXX) is still in the body; fill it or delete the line")
  blocking=1
fi

rc=0
[ "$attention" -eq 0 ] || rc=10
[ "$blocking" -eq 0 ] || rc=20

if [ "${#findings[@]}" -eq 0 ]; then
  echo "conforms to $template_file"
else
  printf '%s\n' "${findings[@]}"
fi

if [ -n "$evidence_file" ]; then
  {
    if [ "$rc" -eq 0 ]; then
      echo "PR body conforms to \`$template_file\`."
    else
      echo "PR body vs \`$template_file\`:"
      echo
      printf -- '- %s\n' "${findings[@]}"
      echo
      echo "Template headings, in order: $(paste -sd '|' "$TMP/t.h" | sed 's/|/; /g')."
    fi
  } >"$evidence_file"
fi
exit "$rc"
