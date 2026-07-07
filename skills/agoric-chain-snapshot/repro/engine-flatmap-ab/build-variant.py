#!/usr/bin/env python3
# Build an xsnap-worker (on-chain default stackCount=4096) from a pristine
# agoric-labs/moddable xsArray.c with one of three fx_Array_prototype_flatAux
# leaf-branch variants, to A/B the engine-level flat/flatMap value-stack fix:
#
#   stock  : agoric-labs f6c5951 as-is (no per-iteration pop)  -> overflows
#   cherry : Moddable-OpenSource 73aad47b's placement          -> mxPop() INSIDE
#            the leaf else-branch (before start++); leaf refs popped, nested
#            sub-array refs left resident
#   pr1    : kriscendobot/moddable#1's placement               -> mxPop() at the
#            END of the if(fxHasIndex) block (after both branches); leaf AND
#            nested sub-array refs popped -> strictly O(depth)
#
# Usage:  MODDABLE=<path to agoric xsnap's moddable> \
#         PRISTINE=<path to pristine f6c5951 xsArray.c> \
#         DEST=<dir for the named workers> \
#         python3 build-variant.py {stock|cherry|pr1}
#
# The pristine source is fetched once with:
#   curl -sL https://raw.githubusercontent.com/agoric-labs/moddable/\
#   f6c5951fc055e4ca592b9166b9ae3cbb9cca6bf0/xs/sources/xsArray.c -o stock_xsArray.c
import sys, subprocess, shutil, os

MOD = os.environ["MODDABLE"]                       # .../@agoric/xsnap/moddable
PKG = os.path.dirname(MOD.rstrip("/"))              # .../@agoric/xsnap
SRC = MOD + "/xs/sources/xsArray.c"
PRISTINE = os.environ["PRISTINE"]
MK = PKG + "/xsnap-native/xsnap/makefiles/lin"
OUT = PKG + "/xsnap-native/xsnap/build/bin/lin/release/xsnap-worker"
DEST = os.environ.get("DEST", ".")

STOCK_BLOCK = (
"\t\t\telse {\n"
"\t\t\t\tmxPushSlot(mxResult);\n"
"\t\t\t\tmxDefineIndex(start, 0, XS_GET_ONLY);\n"
"\t\t\t\tstart++;\n"
"\t\t\t}\n"
"\t\t}\n"
)
VARIANTS = {
  "stock":  STOCK_BLOCK,
  "cherry": (
"\t\t\telse {\n"
"\t\t\t\tmxPushSlot(mxResult);\n"
"\t\t\t\tmxDefineIndex(start, 0, XS_GET_ONLY);\n"
"\t\t\t\tmxPop();\n"          # 73aad47b: pop the just-defined leaf here
"\t\t\t\tstart++;\n"
"\t\t\t}\n"
"\t\t}\n"
  ),
  "pr1": (
"\t\t\telse {\n"
"\t\t\t\tmxPushSlot(mxResult);\n"
"\t\t\t\tmxDefineIndex(start, 0, XS_GET_ONLY);\n"
"\t\t\t\tstart++;\n"
"\t\t\t}\n"
"\t\t\tmxPop();\n"            # PR#1: pop once for BOTH the leaf and nested branches
"\t\t}\n"
  ),
}

def main():
    v = sys.argv[1]
    with open(PRISTINE) as f: text = f.read()
    assert text.count(STOCK_BLOCK) == 1, "anchor not unique: %d" % text.count(STOCK_BLOCK)
    with open(SRC, "w") as f: f.write(text.replace(STOCK_BLOCK, VARIANTS[v]))
    subprocess.run(["touch", SRC], check=True)
    env = dict(os.environ, MODDABLE=MOD, XSNAP_VERSION=os.environ.get("XSNAP_VERSION", "0.15.0"),
               CC=os.environ.get("CC", 'cc "-D__has_builtin(x)=1"'))
    if subprocess.run(["make", "GOAL=release", "-f", "xsnap-worker.mk"], cwd=MK, env=env).returncode:
        sys.exit("build failed for " + v)
    dst = os.path.join(DEST, "worker-4096-" + v)
    shutil.copy(OUT, dst)
    print("built", v, "->", dst)

main()
