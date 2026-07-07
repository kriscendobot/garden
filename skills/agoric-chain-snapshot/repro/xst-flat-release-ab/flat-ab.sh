#!/bin/sh
# A/B the flat/flatMap value-stack overflow across release `xst` binaries built
# by build-xst.sh. Two shapes:
#   LEAF-dominated  new Map(RI.flatMap(=> [p,p,p,p]))  -- the hex.js / ymax0 shape
#   NESTED-heavy    Array.from(N,()=>[{}]).flat(1)     -- the residual after 73aad47b
#
# Run against the 4096-slot variants (fast; matches on-chain xsnap). The 256k
# stock binaries reproduce the same result at ~64x the N (slow near capacity:
# GC rescans the piling value stack -> quadratic), so prefer -4096 for the A/B.
set -u
BASE="${BASE:-$HOME/.cache/garden-scratch/exp9-xst}"
STACK="${STACK:-4096}"
X70="$BASE/xst-7.0.0-$STACK"; X71="$BASE/xst-7.1.0-$STACK"; X83="$BASE/xst-8.3.0-$STACK"

leaf() { c="var RI=Array.from({length:$2},function(e,t){return t.toString(16);});
var M=new Map(RI.flatMap(function(e,t){return [[e,t],[e+'a',t],[e+'b',t],[e+'c',t]];}));
print('OK size='+M.size);"; o=$(timeout 60 "$1" -e "$c" 2>&1); printf 'exit=%s :: %s\n' "$?" "$(echo "$o"|tr '\n' ' '|head -c 45)"; }
nest() { c="var A=Array.from({length:$2},function(){return [{}];}); var F=A.flat(1); print('OK len='+F.length);"
  o=$(timeout 60 "$1" -e "$c" 2>&1); printf 'exit=%s :: %s\n' "$?" "$(echo "$o"|tr '\n' ' '|head -c 45)"; }

echo "### LEAF-dominated (hex.js shape)  stack=$STACK"
for n in 500 900 1200 2000; do
  printf -- '-- N=%s --\n' "$n"
  printf '  7.0.0 before : '; leaf "$X70" "$n"
  printf '  7.1.0 after  : '; leaf "$X71" "$n"
  printf '  8.3.0 latest : '; leaf "$X83" "$n"
done
echo "### NESTED-heavy (flat(1))  stack=$STACK"
for n in 1500 2000 3000 4000; do
  printf -- '-- N=%s --\n' "$n"
  printf '  7.0.0 before : '; nest "$X70" "$n"
  printf '  7.1.0 after  : '; nest "$X71" "$n"
  printf '  8.3.0 latest : '; nest "$X83" "$n"
done
