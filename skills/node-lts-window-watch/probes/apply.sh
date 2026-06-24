#!/usr/bin/env bash
# apply.sh <plan.json> <project-root>
#
# Rewrites pin surfaces in place per the plan. Does not git-stage; the
# calling builder composes the commit(s).

set -euo pipefail

PLAN="$1"
PROJECT_ROOT="$2"
cd "$PROJECT_ROOT"

count=$(jq '.entries | length' "$PLAN")
if [[ "$count" -eq 0 ]]; then
  echo "no-op" >&2
  exit 0
fi

# Walk plan entries in reverse line order per file, so earlier edits do not
# shift the line numbers of later edits in the same file.
jq -c '.entries | sort_by(.file, -.line) | .[]' "$PLAN" | while IFS= read -r entry; do
  kind=$(echo "$entry" | jq -r '.kind')
  file=$(echo "$entry" | jq -r '.file')
  line=$(echo "$entry" | jq -r '.line')
  current_json=$(echo "$entry" | jq -c '.current')
  desired_json=$(echo "$entry" | jq -c '.desired')

  case "$kind" in
    app-bundle)
      current=$(echo "$current_json" | jq -r '.')
      desired=$(echo "$desired_json" | jq -r '.')
      # Literal replacement of the version string on the target line.
      python3 - <<PY
import sys
path = "$file"
old, new = "$current", "$desired"
ln = $line
with open(path) as fh:
    lines = fh.readlines()
lines[ln-1] = lines[ln-1].replace(old, new)
with open(path, 'w') as fh:
    fh.writelines(lines)
PY
      echo "edited $file:$line  $current -> $desired" >&2
      ;;

    app-bundle-nvmrc)
      desired=$(echo "$desired_json" | jq -r '.')
      echo "$desired" > "$file"
      echo "edited $file (full rewrite)  -> $desired" >&2
      ;;

    ci-single)
      current=$(echo "$current_json" | jq -r '.')
      desired=$(echo "$desired_json" | jq -r '.')
      python3 - <<PY
path = "$file"
ln = $line
old, new = "$current", "$desired"
with open(path) as fh:
    lines = fh.readlines()
lines[ln-1] = lines[ln-1].replace(old, new)
with open(path, 'w') as fh:
    fh.writelines(lines)
PY
      echo "edited $file:$line  $current -> $desired" >&2
      ;;

    ci-matrix)
      # Inline form only in v1. Block form is deferred to a future probe; if
      # the existing line is not an inline list, we leave a comment marker and
      # surface for manual edit.
      desired_arr=$(echo "$desired_json" | jq -r '. | map("\(.)") | join(", ")')
      python3 - <<PY
path = "$file"
ln = $line
desired = "[$desired_arr]" if "$desired_arr" else "[]"
with open(path) as fh:
    lines = fh.readlines()
raw = lines[ln-1]
import re
m = re.search(r'(\s+node-version: )\[[^\]]+\]', raw)
if m:
    lines[ln-1] = raw[:m.start()] + m.group(1) + desired + raw[m.end():]
    with open(path, 'w') as fh:
        fh.writelines(lines)
    print("edited $file:$line (inline matrix) -> " + desired, file=__import__('sys').stderr)
else:
    # Block-form matrix; leave a TODO marker for the builder to address.
    print("$file:$line is a block-form matrix; v1 apply leaves it; the builder must edit by hand", file=__import__('sys').stderr)
PY
      ;;

    *)
      echo "unknown plan kind $kind; skipping" >&2
      ;;
  esac
done
