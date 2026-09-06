#!/bin/bash
# dep-compat-check-test.sh -- exercise the pure semver compatibility checker.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHECK="$(cd "$HERE/../handlers" && pwd)/dep-compat-check.mjs"
NPM_ROOT="$(npm root -g)"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

run_check() { GARDEN_NPM_ROOT="$NPM_ROOT" node "$CHECK"; }

out="$(printf '%s' '{
  "packageName":"@vitejs/plugin-react",
  "target":{"peerDependencies":{"vite":"^7.0.0"}},
  "manifests":[{"path":"package.json","manifest":{"devDependencies":{"vite":"^6.0.0"}}}]
}' | run_check)"
[ "$out" = $'incompatible\tpeer\tvite\t^6.0.0\t^7.0.0\tpackage.json' ] \
  && ok "empty Vite peer intersection is proven" || bad "unexpected peer result: $out"

out="$(printf '%s' '{
  "packageName":"@vitejs/plugin-react",
  "target":{"peerDependencies":{"vite":"^6.0.0 || ^7.0.0"}},
  "manifests":[{"path":"package.json","manifest":{"devDependencies":{"vite":"^6.1.0"}}}]
}' | run_check)"
[ -z "$out" ] && ok "overlapping peer ranges are not rejected" || bad "compatible peers rejected: $out"

out="$(printf '%s' '{
  "packageName":"@babel/core",
  "target":{"engines":{"node":"^20.19.0 || >=22.12.0"}},
  "manifests":[{"path":"package.json","manifest":{"engines":{"node":">=18"}}}]
}' | run_check)"
[ "$out" = $'incompatible\tnode\t18.0.0\t>=18\t^20.19.0 || >=22.12.0\tpackage.json' ] \
  && ok "Babel-style Node-floor exclusion is proven" || bad "unexpected Node result: $out"

out="$(printf '%s' '{
  "packageName":"some-package",
  "target":{"engines":{"node":">=18"}},
  "manifests":[{"path":"package.json","manifest":{"engines":{"node":"^20.0.0"}}}]
}' | run_check)"
[ -z "$out" ] && ok "supported project Node floor is not rejected" || bad "compatible Node floor rejected: $out"

out="$(printf '%s' '{
  "packageName":"some-package",
  "target":{"peerDependencies":{"vite":"workspace:*"}},
  "manifests":[{"path":"package.json","manifest":{"dependencies":{"vite":"^6"}}}]
}' | run_check)"
[ -z "$out" ] && ok "unsupported range syntax falls open" || bad "unsupported range was rejected: $out"

echo "TOTAL: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
