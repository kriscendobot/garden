#!/bin/sh
# Build an xst variant that moves fx_Array_prototype_flatAux's mxPop() from the
# leaf `else` branch (73aad47b's placement) to the END of the `if (fxHasIndex)`
# block (kriscendobot/moddable#1's placement), so it covers BOTH the leaf value
# and the nested sub-array reference -> O(depth). Built on the 8.3.0 tree that
# build-xst.sh already cloned. Output: $BASE/xst-8.3.0pr1-<STACK>.
set -eu
BASE="${BASE:-$HOME/.cache/garden-scratch/exp9-xst}"
STACK="${STACK:-4096}"
MOD="$BASE/moddable-8.3.0"
[ -d "$MOD" ] || { echo "run build-xst.sh first ($MOD missing)"; exit 1; }
F="$MOD/xs/sources/xsArray.c"

python3 - "$F" "$STACK" "$MOD/xs/tools/xst.c" <<'PY'
import sys
xsarray, stack, xst = sys.argv[1], sys.argv[2], sys.argv[3]
s = open(xsarray).read()
old = ("\t\t\telse {\n"
       "\t\t\t\tmxPushSlot(mxResult);\n"
       "\t\t\t\tmxDefineIndex(start, 0, XS_GET_ONLY);\n"
       "\t\t\t\tmxPop();\n"
       "\t\t\t\tstart++;\n"
       "\t\t\t}\n"
       "\t\t}")
new = ("\t\t\telse {\n"
       "\t\t\t\tmxPushSlot(mxResult);\n"
       "\t\t\t\tmxDefineIndex(start, 0, XS_GET_ONLY);\n"
       "\t\t\t\tstart++;\n"
       "\t\t\t}\n"
       "\t\t\tmxPop(); /* PR#1: end-of-block pop covers leaf AND nested */\n"
       "\t\t}")
assert s.count(old) == 1, "expected 1 flatAux leaf-block match, got %d" % s.count(old)
open(xsarray, "w").write(s.replace(old, new))
t = open(xst).read().replace("256 * 1024", stack)
open(xst, "w").write(t)
print("patched flatAux (end-of-block pop) + stackCount=%s" % stack)
PY

( cd "$MOD/xs/makefiles/lin" && MODDABLE="$MOD" make -f xst.mk GOAL=release >/dev/null )
cp "$MOD/build/bin/lin/release/xst" "$BASE/xst-8.3.0pr1-$STACK"
git -C "$MOD" checkout -- xs/sources/xsArray.c xs/tools/xst.c   # leave tree pristine
echo "built xst-8.3.0pr1-$STACK"
