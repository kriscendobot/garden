#!/bin/bash
# Run one flat/flatMap value-stack probe through a chosen stock `xst` and
# classify the result OK / OVERFLOW / TIMEOUT with wall-clock timing.
#
# Two shapes, isolating the two leak branches of fx_Array_prototype_flatAux
# (xs/sources/xsArray.c):
#   leaf   — `[inner].flat()` where inner is K scalars: one nested descent, then
#            K LEAF defines. 73aad47b pops the leaf slot, so this is the branch
#            the fix covers. Mirrors the ymax0 hex.js `new Map(RI.flatMap(...))`
#            class (leaf-dominated).
#   nested — `Array.from({length:N},()=>[{}]).flat(1)`: every element hits the
#            NESTED branch, whose `item` slot 73aad47b does NOT pop. This is the
#            branch only kriscendobot/moddable#1's end-of-block pop covers.
#
# Stock `xst` runs a script file with a 256K-slot value stack (xs/tools/xst.c
# _creation.stackCount = 256*1024), so thresholds are ~256K elements — far above
# the on-chain xsnap 4096, but the SAME leak. The engine-flatmap-ab harness one
# dir up shows the same A/B at the on-chain stackCount=4096.
#
# Usage: run-ab.sh <leaf|nested> <N> <path-to-xst> [timeout_s]
set -uo pipefail
shape="${1:?shape}"; N="${2:?N}"; xst="${3:?xst path}"; to="${4:-240}"
T="$(mktemp -d)"
if [ "$shape" = leaf ]; then
  cat > "$T/run.js" <<EOF
var K=$N; var inner=[]; for(var i=0;i<K;i++)inner.push(i);
var r=[inner].flat(); print("OK leaf K="+K+" len="+r.length);
EOF
else
  cat > "$T/run.js" <<EOF
var N=$N; var a=Array.from({length:N},function(){return [{}];});
var r=a.flat(1); print("OK nested N="+N+" len="+r.length);
EOF
fi
s=$SECONDS
out="$(timeout "$to" "$xst" "$T/run.js" 2>&1)"; rc=$?
dt=$((SECONDS-s))
cls=UNKNOWN
[ "$rc" -eq 0 ] && cls=OK
echo "$out" | grep -qi 'stack overflow' && cls=OVERFLOW
[ "$rc" -eq 124 ] && cls=TIMEOUT
printf '%-6s N=%-7s %-8s exit=%-3s %ss :: %s\n' "$shape" "$N" "$cls" "$rc" "$dt" "$(echo "$out" | head -1)"
