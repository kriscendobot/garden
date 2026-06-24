#!/usr/bin/env bash
# plan.sh <window.json> <inventory.json> <project-root>
#
# Computes the minimal-edit plan: for each non-frozen inventory entry, the
# desired pin per the policy in .node-lts-window.json (or the default).
#
# Output shape:
# {
#   "entries": [
#     {
#       "kind":"app-bundle",
#       "file":"...",
#       "line":22,
#       "current":"v20.18.1",
#       "desired":"v22.11.0",
#       "reason":"Node 20 entered maintenance 2024-10-29; active LTS is now 22"
#     }
#   ]
# }

set -euo pipefail

WINDOW="$1"
INVENTORY="$2"
PROJECT_ROOT="$3"

POLICY_FILE="$PROJECT_ROOT/.node-lts-window.json"
if [[ -f "$POLICY_FILE" ]]; then
  POLICY="$(cat "$POLICY_FILE")"
else
  POLICY='{
    "app-bundle-policy": "active-lts",
    "ci-matrix-policy": "window-plus-current",
    "embargo-days-for-new-lts": 30
  }'
fi

jq -n \
  --slurpfile w "$WINDOW" \
  --slurpfile inv "$INVENTORY" \
  --argjson policy "$POLICY" \
  '
  ($w[0]) as $win
  | ($inv[0].surfaces) as $surfaces
  |
  # Desired values per surface kind.
  ($win.active_lts) as $active
  | ($win.window) as $window_majors
  | ($win.current) as $current
  | ($win.latest_patch) as $patches
  |
  ($patches[($active|tostring)] // null) as $desired_bundle
  | ($window_majors | map("\(.).x")) as $desired_window_majors_x
  |
  # Window-plus-current adds the current major if not already in window.
  (
    if ($policy["ci-matrix-policy"] == "window-plus-current" and $current and ($window_majors | index($current) | not))
    then $desired_window_majors_x + ["\($current).x"]
    else $desired_window_majors_x
    end
    | sort
  ) as $desired_matrix
  |
  ($surfaces
    | map(
        . as $s
        |
        if $s.kind == "app-bundle" then
          if $desired_bundle and $s.current != $desired_bundle then
            {kind:$s.kind, file:$s.file, line:$s.line,
             current:$s.current, desired:$desired_bundle,
             reason:"app-bundle policy active-lts; advance to active LTS major \($active) latest patch"}
          else empty end
        elif $s.kind == "app-bundle-nvmrc" then
          # Match the file existing precision (major / major.minor / vX.Y.Z).
          ($desired_bundle // "") as $full
          |
          (if ($s.current | test("^v?[0-9]+$")) then "\($active)"
            elif ($s.current | test("^v?[0-9]+\\.[0-9]+$")) then ($full | sub("^v";"") | split(".")[0:2] | join("."))
            else $full
           end) as $want
          | if $s.current != $want and $s.current != ("v" + $want) then
              {kind:$s.kind, file:$s.file, line:$s.line,
               current:$s.current, desired:$want,
               reason:"nvmrc; advance to active LTS major \($active)"}
            else empty end
        elif $s.kind == "ci-single" then
          if $s.current != "\($active).x" then
            {kind:$s.kind, file:$s.file, line:$s.line,
             current:$s.current, desired:"\($active).x",
             reason:"ci-single tracks bundle; bump to active LTS \($active).x"}
          else empty end
        elif $s.kind == "ci-matrix" then
          if ($s.current | sort) != $desired_matrix then
            {kind:$s.kind, file:$s.file, line:$s.line,
             current:($s.current | sort), desired:$desired_matrix,
             reason:"ci-matrix policy \($policy["ci-matrix-policy"]); align to window"}
          else empty end
        elif $s.kind == "frozen" then
          empty
        elif $s.kind == "engines-node-report" then
          # Report-only in v1; do not emit plan entries.
          empty
        else empty end
      )
  ) as $entries
  | {entries: $entries}
  '
