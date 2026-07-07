/*
 * Minimal reproduction of the Array.prototype.flat / flatMap value-stack
 * overflow in XS (Moddable-OpenSource/moddable), runnable with a stock `xst`.
 *
 * Background: kriskowal/garden#9 traced an on-chain (agoric xsnap, stackCount
 * 4096) "stack overflow" during a contract bundle import to fx_Array_prototype_
 * flatAux in xs/sources/xsArray.c, which builds the flattened result on the heap
 * but leaves each per-iteration slot resident on the *value* stack, so peak
 * value-stack use is O(flattened output) rather than O(depth).
 *
 * Commit 73aad47b ("XS: fix array flat/sort stack overflows") adds mxPop()
 * INSIDE the leaf `else` branch. That fixes the LEAF-dominated shape (flatMap
 * returning many small arrays, e.g. new Map(a.flatMap(=> [p,p,p,p])) — the
 * @agoric/internal hex.js decodings builder that tripped the chain). It does NOT
 * pop the sub-array reference that stays resident in the NESTED branch, so a
 * nested-heavy .flat() STILL leaks ~1 value-stack slot per nested element and
 * still overflows on the latest release. Popping at the END of the
 * `if (fxHasIndex)` block instead (covering both branches) is O(depth) and
 * clears the nested case too.
 *
 * This file is the nested-heavy reproducer. It overflows on a stock xst whose
 * value stack has ~STACK slots once N exceeds ~STACK (the leak is ~1 slot per
 * outer element after 73aad47b). Pick N accordingly:
 *   - agoric on-chain xsnap  (stackCount 4096)    -> overflows at N ~ 4000
 *   - stock standalone xst   (stackCount 262144)  -> overflows at N ~ 262000
 * A single reference-array element (`[{}]`) per outer slot forces the nested
 * branch on every iteration; the inner object is the (already-fixed) leaf.
 *
 * Usage:  xst -e "N=4000; <this file's body>"   (or set N below and run the file)
 * Expect: "Error: JavaScript stack overflow" (exit 1) on 73aad47b..HEAD;
 *         "OK len=<N>" once the end-of-block pop is applied.
 */
var N = typeof N === 'number' ? N : 300000; // > default xst stackCount (262144)
var outer = Array.from({ length: N }, function () {
  return [{}]; // a reference sub-array -> nested branch; inner {} -> leaf branch
});
var flat = outer.flat(1);
print('OK len=' + flat.length);
