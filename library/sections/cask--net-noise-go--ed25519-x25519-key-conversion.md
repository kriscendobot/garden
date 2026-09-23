---
title: ed25519↔x25519 key conversion — SHA-512-clamp for the private key, birational Montgomery map for the public key
source: net/noise.go
source_kind: comment-fragment
source_repo: kriskowal/cask
source_path: net/noise.go
source_line_range: "288-319"
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
comment_subject: How casknet derives x25519 Diffie-Hellman keys from its ed25519 identity keypairs — the private key by SHA-512-hashing the seed and clamping, the public key by the birational map u = (1+y)/(1-y) computed with the edwards25519 Montgomery-u extraction
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-26
ingested_by: scholar
topics: [networking, capability-security]
status: current
notes: |
  The conversion the responder's consistency check (cask--net-peer-go--responder-
  handshake-consistency-and-authorization) relies on, and the bridge between the
  ed25519-keyed member table and the x25519 Noise DH. Cross-references member-
  table-authorization and noise-ik-session-establishment.
---

> Abstract: casknet identities are **ed25519** keypairs (signing-shaped), but the Noise IK handshake does Diffie-Hellman over **x25519** (DH-shaped). `net/noise.go` converts between them with two standard maps. `Ed25519PrivateToX25519` derives the x25519 private key by hashing the ed25519 **seed** with SHA-512 and taking the first 32 bytes with the usual curve25519 **clamping** (clear the low 3 bits of byte 0, clear bit 7 and set bit 6 of byte 31) — this reproduces exactly the scalar ed25519 itself derives from the seed, so the two keypairs share a private scalar. `Ed25519PublicToX25519` converts the ed25519 **public** key (an Edwards point) to its x25519 (Montgomery) form via the birational map `u = (1 + y)/(1 - y)`, computed by parsing the Edwards point with `filippo.io/edwards25519` and reading its Montgomery u-coordinate (`BytesMontgomery`). This conversion is what lets a single identity key serve both roles, and it is the function the responder's [consistency check](cask--net-peer-go--responder-handshake-consistency-and-authorization.md) runs to prove an initiator's ed25519 identity matches the x25519 key the handshake revealed.

This section documents the key-format bridge between casknet's ed25519 identity layer ([[member-table-authorization]]) and its x25519 Diffie-Hellman ([[noise-ik-session-establishment]]).

## Private key: SHA-512 of the seed, then clamp

```go
// Ed25519PrivateToX25519 converts an ed25519 private key to an x25519
// private key by hashing the seed with SHA-512 and clamping.
func Ed25519PrivateToX25519(edPriv ed25519.PrivateKey) [32]byte {
	h := sha512.Sum512(edPriv.Seed())
	var x [32]byte
	copy(x[:], h[:32])
	x[0] &= 248
	x[31] &= 127
	x[31] |= 64
	return x
}
```

ed25519 itself derives its private scalar by SHA-512-hashing the 32-byte seed and clamping the lower half; reproducing that exact derivation yields an x25519 private key whose scalar is the same one the ed25519 key signs with. The clamp (`&= 248` clears the low 3 bits, `&= 127` clears the top bit, `|= 64` sets the second-top bit) is the standard curve25519 clamping that forces the scalar into the right cofactor-clearing, fixed-bit-length form.

## Public key: the birational map via edwards25519

```go
// Ed25519PublicToX25519 converts an ed25519 public key to an x25519
// public key using the birational map u = (1+y)/(1-y).
func Ed25519PublicToX25519(edPub ed25519.PublicKey) ([32]byte, error) {
	if len(edPub) != ed25519.PublicKeySize {
		return [32]byte{}, fmt.Errorf("noise: invalid ed25519 public key length: %d", len(edPub))
	}
	// Use filippo.io/edwards25519 for the conversion.
	p, err := new(edwards25519.Point).SetBytes(edPub)
	if err != nil {
		return [32]byte{}, fmt.Errorf("noise: invalid ed25519 point: %w", err)
	}
	// The Montgomery u-coordinate is computed by the library.
	var result [32]byte
	copy(result[:], p.BytesMontgomery())
	return result, nil
}
```

Curve25519 (Montgomery form, x25519) and Edwards25519 (twisted-Edwards form, ed25519) are the same curve under a birational equivalence; the public-key map is `u = (1 + y)/(1 - y)` from the Edwards `y`-coordinate to the Montgomery `u`-coordinate. Rather than implement the field arithmetic inline, the code parses the ed25519 public key into an `edwards25519.Point` and calls `BytesMontgomery`, which returns the u-coordinate. Parsing also validates the point (an invalid encoding returns an error), so a malformed public key cannot slip through to the consistency check.

Source: [net/noise.go](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/net/noise.go) at commit `cdb975d8` (lines 288-319).
