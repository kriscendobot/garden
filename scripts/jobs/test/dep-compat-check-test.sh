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
  "baseline":{"peerDependencies":{"vite":"^6.0.0"}},
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
  "baseline":{"engines":{"node":">=18"}},
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

# Baseline rule: a proof is about the bump. The #1493/#1441 shape is an outgoing
# version that already excluded the project floor.
out="$(printf '%s' '{
  "packageName":"@earendil-works/pi-agent-core",
  "baseline":{"engines":{"node":">=22.19.0"}},
  "target":{"engines":{"node":">=22.19.0"}},
  "manifests":[{"path":"package.json","manifest":{"engines":{"node":"^20.17.0 || >=22.9.0"}}}]
}' | run_check)"
[ -z "$out" ] && ok "Node floor the outgoing version already excluded is not proven" \
  || bad "pre-existing Node mismatch was proven: $out"

out="$(printf '%s' '{
  "packageName":"some-package",
  "baseline":{},
  "target":{"engines":{"node":">=22.19.0"}},
  "manifests":[{"path":"package.json","manifest":{"engines":{"node":"^20.17.0 || >=22.9.0"}}}]
}' | run_check)"
[ "$out" = $'incompatible\tnode\t20.17.0\t^20.17.0 || >=22.9.0\t>=22.19.0\tpackage.json' ] \
  && ok "an outgoing version with no engine declaration is a valid baseline" \
  || bad "unexpected Node result for an unconstrained baseline: $out"

out="$(printf '%s' '{
  "packageName":"some-package",
  "baseline":{"engines":{"node":"not a range!"}},
  "target":{"engines":{"node":">=22.19.0"}},
  "manifests":[{"path":"package.json","manifest":{"engines":{"node":">=20"}}}]
}' | run_check)"
[ -z "$out" ] && ok "an unreadable baseline Node range falls open" \
  || bad "unreadable baseline Node range was proven: $out"

out="$(printf '%s' '{
  "packageName":"some-package",
  "target":{"engines":{"node":">=22.19.0"}},
  "manifests":[{"path":"package.json","manifest":{"engines":{"node":">=20"}}}]
}' | run_check)"
[ -z "$out" ] && ok "a missing baseline manifest falls open" || bad "missing baseline was proven: $out"

out="$(printf '%s' '{
  "packageName":"@vitejs/plugin-react",
  "baseline":{"peerDependencies":{"vite":"^7.0.0"}},
  "target":{"peerDependencies":{"vite":"^7.1.0"}},
  "manifests":[{"path":"package.json","manifest":{"devDependencies":{"vite":"^6.0.0"}}}]
}' | run_check)"
[ -z "$out" ] && ok "peer conflict the outgoing version already had is not proven" \
  || bad "pre-existing peer conflict was proven: $out"

out="$(printf '%s' '{
  "packageName":"@vitejs/plugin-react",
  "baseline":{"peerDependencies":{"react":"^18"}},
  "target":{"peerDependencies":{"vite":"^7.0.0"}},
  "manifests":[{"path":"package.json","manifest":{"devDependencies":{"vite":"^6.0.0"}}}]
}' | run_check)"
[ "$out" = $'incompatible\tpeer\tvite\t^6.0.0\t^7.0.0\tpackage.json' ] \
  && ok "a peer the outgoing version did not require is proven when the target excludes it" \
  || bad "unexpected result for a newly-added peer: $out"

echo "TOTAL: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
