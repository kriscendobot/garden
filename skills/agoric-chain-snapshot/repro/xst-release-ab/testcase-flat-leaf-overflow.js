// Moddable test case — Array.prototype.flat/flatMap value-stack overflow (LEAF).
//
// This is the ymax0 v320 class: `new Map(RI.flatMap(...))` in @agoric/internal
// hex.js. fx_Array_prototype_flatAux (xs/sources/xsArray.c) builds the flattened
// result on the heap but, in stock XS, leaves each defined LEAF element resident
// on the value stack — peak value-stack use is O(flattened output), not O(depth).
//
// EXPECTED:
//   * BEFORE 73aad47b (release 7.0.0 and earlier): "Error: JavaScript stack
//     overflow" — the K leaf defines pile up on the value stack.
//   * AFTER 73aad47b (release 7.1.0 .. 8.3.0): completes; prints "PASS".
//
// The single outer element makes exactly one nested descent, then the inner
// array's K elements all hit the LEAF branch — the branch 73aad47b's mxPop()
// covers. K is sized above xst's 256K-slot value stack (xs/tools/xst.c
// _creation.stackCount = 256*1024). On the on-chain xsnap stackCount=4096 the
// same overflow trips at K ~ 4000.
var K = 300000;
var inner = [];
for (var i = 0; i < K; i++) inner.push(i);
var r = [inner].flat();
if (r.length !== K) throw new Error("wrong length " + r.length);
print("PASS flat leaf K=" + K);
