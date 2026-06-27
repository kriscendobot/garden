---
title: Revocation
source: docs/kernel-guide.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/kernel-guide.md
source_branch: main
source_commit: 175b7c0663ce37c2626d33e08134346d4cdd17bf
source_date: 2026-04-23
source_authors: [Dimitris Marlagkoutsos, MetaMask ocap-kernel team]
ingested: 2026-06-27
ingested_by: scholar
topics: [capability-security]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel exposes revocation as a first-class kernel verb, unlike Endo's caretaker/membrane approach. See [[ocap-kernel]].
---

## Abstract

The ocap-kernel kernel supports **revoking** object references as a first-class, kernel-level operation: `kernel.revoke(kref)` invalidates an object so that any future `E()` call targeting it fails, and `kernel.isRevoked(kref)` reports status. Vats holding a reference to a revoked object get errors when they try to use it. **Revocation is permanent and cannot be undone.** This is a notable structural divergence from Endo: ocap-kernel makes revocation a built-in kernel verb keyed by kref, where Endo achieves revocation compositionally through the caretaker/forwarder pattern (interpose a revocable forwarder; disable it by undefining its target) or via marshal membranes ([[revocation-by-withdrawal]]). The capability theory is the same — the *forwarder/revoker construction* of Miller-Yee-Shapiro's Irrevocability Myth — but ocap-kernel chooses a kernel-enforced mechanism over a userland pattern.

## Body

The kernel supports **revoking** object references. Once revoked, any `E()` call targeting that object will fail.

```ts
// Host application side
kernel.revoke(kref);

// Check revocation status
kernel.isRevoked(kref); // true
```

Revocation is a kernel-level operation. Vats holding a reference to a revoked object will get errors when they try to use it. Revocation is permanent and cannot be undone.

## Lineage note

Miller-Yee-Shapiro's *Irrevocability Myth* (Capability Myths Demolished 2003) shows revocation is achievable in a pure object-capability model via the forwarder/revoker construction (Redell 1974): Alice gives Bob a forwarder F referencing Carol while retaining a revoker R; invoking R disables F. Endo implements this *compositionally* — caretaker patterns and the marshal membrane's revocation-by-undefining-the-`mineToYours`-WeakMap ([[revocation-by-withdrawal]]). ocap-kernel instead exposes revocation as a *primitive kernel operation* on a kref. The trade-off: a kernel verb is simpler to call and harder to forget, but it is *coarse* (revokes the whole kref, permanently) and *host-mediated* (only code holding the `Kernel` instance or kernel facet can revoke), whereas the caretaker pattern is *fine-grained, composable, and exercisable by any holder* of the revoker capability without kernel privilege. Honest divergence: same theory, different layer of enforcement.

Source: [docs/kernel-guide.md](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/docs/kernel-guide.md) at commit `175b7c0`.
