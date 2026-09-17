#!/bin/bash
# C-archivist-claim-accuracy — fires the archivist seat when added prose (in a
# README, any *.md, a design doc, or a source comment) makes a DEFINITE technical
# claim about a named in-repo entity (an `@endo/*` package, a dotted API, an
# export/file, or an archive format). Such a claim is checkable against the
# authoritative code and against the doc's own other statements, and the archivist
# (roles/jurors/archivist/AGENT.md § Cross-verify definite technical claims) is the
# seat that does the cross-verification.
#
# Senses the review-miss cluster `docs-claim-contradicts-code-semantics` (docs-drift;
# grounding PRs #475, #877, #264): fleet-authored prose asserted a definite,
# in-repo-verifiable claim that contradicted the repo's own reference code (or the
# doc's own later text), because review reads prose for clarity but does not
# cross-verify its definite claims against the implementation.
#   #475  packages/immutable-arraybuffer/README.md: the `immutable` accessor called
#         the canonical emulated-vs-genuine brand check (false; it answers only
#         mutable-vs-immutable, per @endo/pass-style byteArray.js).
#   #877  packages/daemon/src/archive-text-endowments-xs.js header comment: claimed
#         `@endo/base64` deliberately does not provide the atob/btoa layer (false;
#         the package ships atob.js, btoa.js, an index export, and shim.js).
#   #264  designs/compartment-mapper-import-attributes.md: the archive called
#         "typically a `tar.gz`" (false; it is a zip, as the same doc's Archive leg
#         already said).
#
# Two signals must co-occur on one added line: a NAMED in-repo entity and a
# DEFINITE-CLAIM cue. Err toward firing (a loose probe is acceptable, a missed fire
# is not); the seat, not the probe, decides whether the claim is actually true. The
# archivist is already always-on for the CODE panel, so on code PRs this probe is a
# no-op for seat selection (it never double-lists); its load-bearing role is routing
# the archivist onto a DESIGN-panel PR, where the seat is otherwise absent and the
# #264 miss slipped through.
set -uo pipefail
BASE=${BASE:-origin/master}

# A named in-repo entity: an @endo/* package, a backticked dotted API
# (`.buffer.immutable`, `M.interface`), a backticked file/export (`atob.js`), a
# backticked bare code identifier, or an archive-format term.
ENTITY='@endo/[a-z0-9-]+|`\.?[A-Za-z_$][A-Za-z0-9_$.]*`|`[a-z0-9._-]+\.(js|mjs|ts)`|\b(tar\.gz|\.tgz|tarball|\.zip|zip file|gzip)\b'

# A definite-claim cue: language asserting a checkable fact rather than motivation
# or intent.
CLAIM='\bthe canonical\b|\bdeliberately\b|\bdoes not (provide|include|ship|export|expose|support|have|implement)\b|\bdoes NOT\b|\bis not\b|\bis the\b|\bare the\b|\btypically a\b|\btypically an\b|\balways\b|\bnever\b|\bthe only\b|\bthe single\b|\bthe correct\b|\bthe actual\b|\bomits?\b|\bcannot\b|\bguarantees?\b|\bprovides only\b|\breimplement'

if [ "${1:-}" = "--scan-stdin" ]; then
  lines=$(cat)
else
  lines=$(git diff "$BASE...HEAD" -U0 2>/dev/null | grep -E '^\+[^+]' | sed 's/^\+//')
fi

# Fire on the first added line carrying both an entity and a claim cue.
while IFS= read -r line; do
  [ -n "$line" ] || continue
  if printf '%s' "$line" | grep -qE "$ENTITY" && printf '%s' "$line" | grep -qE "$CLAIM"; then
    ent=$(printf '%s' "$line" | grep -oE "$ENTITY" | head -1)
    echo "fire archivist definite claim about in-repo entity ($ent) — cross-verify it against the authoritative code and the doc's own other statements"
    exit 0
  fi
done <<< "$lines"

echo "skip archivist"
