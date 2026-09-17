#!/bin/bash
# Regression coverage for skills/panel-hints/probes/C-archivist-claim-accuracy.sh,
# the sensing half of the `docs-claim-contradicts-code-semantics` review-miss
# cluster (docs-drift; grounding endojs/endo-but-for-bots #475, #877, #264). Each
# fire assertion feeds the probe the real historical prose line where the miss
# occurred and checks it fires the archivist; the abstain assertions check that
# claim-free prose and an entity-pointer-only line do not force a fault.
#
# The three fired lines are quoted from the actual buggy revisions:
#   #877  packages/daemon/src/archive-text-endowments-xs.js @ 6db54d5e8d (fixed by
#         3a7f1dc077 "correct @endo/base64 atob/btoa comment").
#   #264  designs/compartment-mapper-import-attributes.md @ e7f1a9b89e (the
#         "typically a `tar.gz`" line; reviewed head 9d68588c0; fixed by db011c31a).
#   #475  packages/immutable-arraybuffer/README.md brand-check prose (the flagged
#         "canonical brand check" claim; the exact line was squash-merged away, so
#         a faithful reconstruction of the maintainer-flagged claim is used — the
#         probe also fires on the real README diff at caddaede83, verified by hand).

set -uo pipefail

ROOT=$(cd "$(dirname "$0")/../../.." && pwd)
PROBE="$ROOT/skills/panel-hints/probes/C-archivist-claim-accuracy.sh"

passes=0
failures=0
ok() { echo "ok - $1"; passes=$((passes + 1)); }
bad() { echo "not ok - $1"; failures=$((failures + 1)); }

fires() { # <name> <line>
  local name="$1" line="$2" out
  out=$(printf '%s\n' "$line" | "$PROBE" --scan-stdin 2>&1)
  case "$out" in
    "fire archivist"*) ok "$name — $out" ;;
    *) bad "$name did not fire: $out" ;;
  esac
}

abstains() { # <name> <line...>
  local name="$1"; shift
  local out
  out=$(printf '%s\n' "$@" | "$PROBE" --scan-stdin 2>&1)
  case "$out" in
    "skip archivist") ok "$name abstains" ;;
    *) bad "$name should abstain: $out" ;;
  esac
}

# --- Member re-litigation: the real historical prose where each miss occurred ---

fires 'pr877 @endo/base64 "deliberately does not provide" (6db54d5e8d)' \
  'the thin WHATWG `atob`/`btoa` adaptation layer that `@endo/base64` deliberately does not provide:'

fires 'pr264 archive "typically a `tar.gz`" (e7f1a9b89e)' \
  '(typically a `tar.gz`) containing every module in the graph plus a'

fires 'pr475 `immutable` accessor "the canonical brand check" (reconstruction)' \
  "The \`immutable\` accessor on the view's \`.buffer\` is the canonical brand check for telling an emulated immutable view from a genuine one."

# --- Controls ---

# Motivation/intent prose naming no in-repo entity and asserting no definite claim.
abstains 'claim-free motivation prose' \
  'This proposal makes onboarding smoother and reduces contributor friction.'

# Names an in-repo package but only points to it — no definite claim to verify.
abstains 'entity pointer, no claim' \
  'See `@endo/pass-style` for the full byteArray discussion.'

# A bare import naming the package is not a prose claim about it.
abstains 'import line naming a package' \
  "import { encodeBase64, decodeBase64 } from '@endo/base64';"

echo "1..$((passes + failures))"
echo "# passes=$passes failures=$failures"
[ "$failures" -eq 0 ]
