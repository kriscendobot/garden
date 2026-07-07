// Moddable test case — Array.prototype.flat value-stack overflow (NESTED branch).
//
// This is the case that STILL OVERFLOWS on the LATEST release (8.3.0), because
// 73aad47b only pops in the LEAF branch of fx_Array_prototype_flatAux; the NESTED
// branch (xs/sources/xsArray.c) fetches `item = the->stack` and, after recursing
// into the sub-array, never pops it — so each nested element leaks one value-stack
// slot even with the fix. kriscendobot/moddable#1 moves the mxPop() to the END of
// the `if (fxHasIndex)` block, covering BOTH branches, and clears this case.
//
// EXPECTED:
//   * stock XS through 8.3.0 (leaf-only pop): "Error: JavaScript stack overflow".
//   * with kriscendobot/moddable#1's end-of-block pop: completes, prints "PASS".
//
// Every element of `a` is an array, so every element hits the NESTED branch.
// N is sized above xst's 256K-slot value stack. NOTE: at the 256K stock stack this
// runs for a few minutes — reaching the overflow is O(N^2) because XS's GC rescans
// the growing value stack. Moddable's own harness can create the machine with a
// small stackCount (e.g. the on-chain xsnap 4096), where the identical overflow
// trips at N ~ 4200 in well under a second (see engine-flatmap-ab/README.md).
var N = 300000;
var inner = [0];
var a = new Array(N);
for (var i = 0; i < N; i++) a[i] = inner;
var r = a.flat(1);
if (r.length !== N) throw new Error("wrong length " + r.length);
print("PASS flat nested N=" + N);
