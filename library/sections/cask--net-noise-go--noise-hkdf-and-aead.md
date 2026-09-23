---
title: Noise HKDF and AEAD primitives — the triple-HMAC-BLAKE2b key ladder and the little-endian-counter ChaCha20-Poly1305 nonce
source: net/noise.go
source_kind: comment-fragment
source_repo: kriskowal/cask
source_path: net/noise.go
source_line_range: "321-395"
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
comment_subject: The cryptographic primitives under the Noise handshake — the noiseHKDF two-output key-derivation built from three HMAC-BLAKE2b invocations, the HMAC-BLAKE2b construction with its 128-byte block size, and the ChaCha20-Poly1305 AEAD wrappers whose 12-byte nonce is the little-endian handshake nonce counter in its upper eight bytes
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-26
ingested_by: scholar
topics: [networking]
status: current
notes: |
  The primitive layer beneath cask--net-noise-go--noise-ik-handshake-state-
  machine. The handshake nonce here (little-endian, set during handshake stages)
  is distinct from the big-endian per-direction transport counter nonce in
  cask--net-crypto-go--counter-nonce-and-replay-protection; this section notes
  the distinction.
---

> Abstract: the Noise handshake in `net/noise.go` is built on two primitives. **`noiseHKDF`** is the Noise key-derivation function: from a chaining key and input-keying-material it produces two 32-byte outputs by first computing a temporary key `temp_key = HMAC-BLAKE2b(chaining_key, ikm)`, then `output1 = HMAC-BLAKE2b(temp_key, 0x01)` and `output2 = HMAC-BLAKE2b(temp_key, output1 || 0x02)`. This is the standard Noise two-output HKDF, and both `mixKey` (advancing the chaining key and deriving the next cipher key) and `split` (deriving the two directional transport keys) call it. The underlying **`hmacBlake2b256`** is a hand-rolled HMAC over BLAKE2b-256 with a 128-byte block size, pre-hashing over-long keys and applying the standard `ipad`/`opad` (`0x36`/`0x5c`) construction. The **AEAD** is ChaCha20-Poly1305: `noiseAEADEncrypt`/`noiseAEADDecrypt` build a 12-byte nonce by writing the 64-bit handshake nonce counter little-endian into the nonce's **upper eight bytes** (offset 4), leaving the lower four bytes zero, and pass the handshake hash as associated data.

This section documents the primitive layer beneath the handshake state machine ([cask--net-noise-go--noise-ik-handshake-state-machine](cask--net-noise-go--noise-ik-handshake-state-machine.md)). The handshake nonce here is distinct from the transport-layer replay counter nonce (see Common confusions below).

## The Noise HKDF

```go
// noiseHKDF implements the Noise HKDF:
//
//	temp_key = HMAC-BLAKE2b(chaining_key, ikm)
//	output1  = HMAC-BLAKE2b(temp_key, 0x01)
//	output2  = HMAC-BLAKE2b(temp_key, output1 || 0x02)
func noiseHKDF(chainingKey, ikm []byte) (out1, out2 [32]byte) {
	tempKey := hmacBlake2b256(chainingKey, ikm)
	out1 = hmacBlake2b256(tempKey[:], []byte{0x01})
	buf := make([]byte, 33)
	copy(buf, out1[:])
	buf[32] = 0x02
	out2 = hmacBlake2b256(tempKey[:], buf)
	return
}
```

The three HMAC invocations are the canonical Noise HKDF: the chaining key keys the first HMAC to absorb the new keying material into `temp_key`; `temp_key` then keys two more HMACs over the single-byte counters `0x01` and `output1 || 0x02` to expand into two independent 32-byte outputs. `mixKey` uses both outputs (new chaining key, new cipher key); `split` also uses both (the two directional keys).

## HMAC-BLAKE2b

```go
func hmacBlake2b256(key, data []byte) [32]byte {
	const blockSize = 128
	var k [blockSize]byte
	if len(key) > blockSize {
		hk := blake2bSum256(key)
		copy(k[:], hk[:])
	} else {
		copy(k[:], key)
	}
	var ipad, opad [blockSize]byte
	for i := range k {
		ipad[i] = k[i] ^ 0x36
		opad[i] = k[i] ^ 0x5c
	}
	// inner = BLAKE2b(ipad || data); outer = BLAKE2b(opad || inner)
	...
}
```

A textbook HMAC: the 128-byte block size matches BLAKE2b's block, over-long keys are pre-hashed to 32 bytes and zero-padded, and the `ipad`/`opad` pads are the standard `0x36`/`0x5c`. BLAKE2b has a native keyed mode, but the Noise spec defines its HKDF in terms of HMAC, so the implementation builds HMAC explicitly rather than using the keyed hash.

## ChaCha20-Poly1305 with a little-endian counter nonce

```go
func noiseAEADEncrypt(key []byte, n uint64, ad, plaintext []byte) ([]byte, error) {
	aead, err := chacha20poly1305.New(key)
	if err != nil {
		return nil, err
	}
	var nonce [12]byte
	binary.LittleEndian.PutUint64(nonce[4:], n)
	return aead.Seal(nil, nonce[:], plaintext, ad), nil
}
```

The AEAD is standard ChaCha20-Poly1305 (12-byte nonce, 16-byte Poly1305 tag). The handshake nonce counter `n` (the `noiseState.n` reset to zero at each `mixKey`) is written **little-endian into bytes 4..11** of the nonce, leaving bytes 0..3 zero. The associated data is the handshake hash `h`, which is what binds the running transcript into every sealed field.

## Common confusions

- **Two different nonces in casknet.** The little-endian handshake nonce here (`noiseState.n`, reset per `mixKey` stage) is **not** the transport-layer nonce. Once the session is established, data packets use a **big-endian** per-direction monotonic send counter as their nonce, which is also the basis for replay protection — see [cask--net-crypto-go--counter-nonce-and-replay-protection](cask--net-crypto-go--counter-nonce-and-replay-protection.md). They are separate counters in separate phases; do not conflate the handshake nonce with the transport replay counter.

Source: [net/noise.go](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/net/noise.go) at commit `cdb975d8` (lines 321-395).
