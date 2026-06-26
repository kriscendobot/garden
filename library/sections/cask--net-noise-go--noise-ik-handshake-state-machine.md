---
title: Noise IK handshake state machine — symmetric state, the two-message DH ladder, encrypt/decrypt-and-hash, and directional Split
source: net/noise.go
source_kind: comment-fragment
source_repo: kriskowal/cask
source_path: net/noise.go
source_line_range: "1-126, 128-286"
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
comment_subject: The implementation of the Noise_IK_25519_ChaChaPoly_BLAKE2b handshake — the pre-message and two-message DH token ladder annotated inline, the noiseState chaining-key/handshake-hash/cipher-key triple driven by mixHash/mixKey, the encryptAndHash/decryptAndHash transcript discipline, and Split producing the two directional transport keys with the responder's send/recv reversed
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-26
ingested_by: scholar
topics: [networking]
status: current
notes: |
  Implementation source-of-truth for the Noise IK handshake the design docs
  (cask--net-crypto, cask--net-session-init-design) describe in prose. Adds the
  state-machine detail over those: the token ladder, the symmetric-state fields,
  and the directional-key reversal. Cross-references noise-ik-session-
  establishment (the concept) rather than restating the design.
---

> Abstract: `net/noise.go` implements `Noise_IK_25519_ChaChaPoly_BLAKE2b`, the two-message handshake casknet uses to establish a session. The file header states the IK token ladder: a pre-message `<- s` (the initiator already knows the responder's static key), then message 1 `-> e, es, s, ss` (initiator to responder) and message 2 `<- e, ee, se` (responder to initiator). The handshake is driven by a `noiseState` carrying three rolling 32-byte values — a **chaining key** `ck`, a **handshake hash** `h`, and the current **cipher key** `k` — updated by `mixHash` (folds transcript bytes into `h`) and `mixKey` (folds a DH output into `ck` and derives a fresh `k`, resetting the nonce). Every handshake field is passed through `encryptAndHash` / `decryptAndHash`, which AEAD-encrypt-or-decrypt under the current key only once a key exists (plaintext passthrough before the first `mixKey`) and always fold the ciphertext into `h`, so both sides build an identical transcript hash. After the ladder completes, `split` runs the Noise HKDF once more on the final chaining key to produce two 32-byte **directional** transport keys; the initiator uses the first as send and the second as receive, and the responder reverses them (`recvKey, sendKey = split()`), so the two ends agree on who encrypts with which.

This section is the implementation of the handshake the concept [[noise-ik-session-establishment]] and the design docs ([cask--net-crypto](cask--net-crypto.md), [cask--net-session-init-design](cask--net-session-init-design.md)) describe. It does not restate the design rationale (forward secrecy, threat model); it documents the state machine.

## The IK token ladder

The file header names the pattern:

```go
// The IK pattern:
//
//	<- s                          (responder's static key is known to initiator)
//	...
//	-> e, es, s, ss               (message 1: initiator -> responder)
//	<- e, ee, se                  (message 2: responder -> initiator)
//
// After the handshake, Split() produces two symmetric keys for
// ChaCha20-Poly1305 transport encryption (one per direction).
//
// Identity keys are ed25519 keypairs. They are converted to x25519
// for Diffie-Hellman using the standard birational map.
```

Each token is realized as one operation in `WriteMessage1`/`ReadMessage1`/`WriteMessage2`/`ReadMessage2`, annotated inline with the same token name. Message 1 mixes the initiator's ephemeral key (`e`), then `DH(e, rs)` (`es`), then sends the initiator's *encrypted* static key (`s`), then `DH(s, rs)` (`ss`), then the encrypted inner payload. Message 2 mixes the responder's ephemeral (`e`), then `DH(e, re)` (`ee`) and `DH(s, re)` / `DH(e, rs)` (`se`), then the encrypted inner payload. Because the IK pattern pre-mixes the responder's static key (`<- s`) at construction, the initiator can encrypt its static key to the responder on the very first message.

## noiseState: chaining key, handshake hash, cipher key

```go
type noiseState struct {
	ck   [32]byte // chaining key
	h    [32]byte // handshake hash
	k    [32]byte // current cipher key
	hasK bool     // whether k is set
	n    uint64   // nonce counter
}
```

`initializeSymmetric` seeds both `h` and `ck` from the protocol name (`Noise_IK_25519_ChaChaPoly_BLAKE2b`, copied directly because it is ≤32 bytes, otherwise hashed). `mixHash(data)` sets `h = BLAKE2b-256(h || data)`. `mixKey(ikm)` runs the Noise HKDF on `(ck, ikm)` to get a new `ck` and a fresh `k`, sets `hasK`, and **resets the nonce to zero** — so each DH stage starts a fresh ChaCha20-Poly1305 keystream.

## encryptAndHash / decryptAndHash transcript discipline

```go
func (ns *noiseState) encryptAndHash(plaintext []byte) ([]byte, error) {
	var ct []byte
	if ns.hasK {
		ct, _ = noiseAEADEncrypt(ns.k[:], ns.n, ns.h[:], plaintext)
		ns.n++
	} else {
		ct = append([]byte(nil), plaintext...)
	}
	ns.mixHash(ct)
	return ct, nil
}
```

Two invariants ride here. Before the first `mixKey` there is no key, so the field is carried in the clear (the ephemeral public keys are not secret); once a key exists the field is AEAD-sealed with `h` as the **associated data**, which cryptographically binds the entire transcript so far into every ciphertext. Either way the *ciphertext* is folded into `h`, so the initiator and responder, processing the same wire bytes in the same order, arrive at byte-identical `h` and `ck` — a mismatch anywhere (a tampered or reordered field) makes the next AEAD open fail. `decryptAndHash` is the mirror: it decrypts under the current key, then hashes the *ciphertext* it received (not the recovered plaintext).

## Split: two directional transport keys

```go
func (ns *noiseState) split() (k1, k2 [32]byte) {
	return noiseHKDF(ns.ck[:], nil)
}
```

After the ladder, `split` derives two keys from the final chaining key with an empty input-keying-material. The initiator takes them as `sendKey, recvKey = split()`; the responder takes them reversed — `recvKey, sendKey = resp.ns.split()` in `WriteMessage2`, with the inline comment *responder sends with k2, receives with k1*. This directional split is what makes the two transport directions independent (each has its own key and its own monotonic counter nonce); the transport-key derivation and its forward-secrecy consequence are also documented from the design side in [cask--net-crypto--transport-keys-and-forward-secrecy](cask--net-crypto--transport-keys-and-forward-secrecy.md). The HKDF that both `mixKey` and `split` call is [cask--net-noise-go--noise-hkdf-and-aead](cask--net-noise-go--noise-hkdf-and-aead.md).

Source: [net/noise.go](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/net/noise.go) at commit `cdb975d8` (lines 1-126, 128-286).
