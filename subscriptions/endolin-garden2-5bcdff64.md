# Subscription identity — endolin-garden2-5bcdff64

subscription: 85319e827288978af66e7c056acdbe47b66242a982e5f8f166e2ead5874d7d59
subscription_short: 85319e827288
recorded_at: 2026-08-02T20:42:00Z
recorded_by: liaison on endolin-garden2-5bcdff64

## What this is

A stable, non-literal identifier for the **Anthropic subscription this host bills
to**, so per-account cost attribution can join `usage/*.jsonl` (which stamps
`host`) to an account WITHOUT publishing the account's identity. Two hosts sharing
a value bill to the same subscription; differing values are different
subscriptions.

## Recipe (compute it identically on every host)

    python3 -c "import json,hashlib;print(hashlib.sha256(
      json.load(open('$HOME/.claude.json'))['oauthAccount']['emailAddress']
      .strip().lower().encode('utf-8')).hexdigest())"

Normalization is load-bearing: **strip surrounding whitespace, lowercase, encode
UTF-8**, then SHA-256, lowercase hex. A host that skips the lowercase step
produces a different digest for the same account and will read as a separate
subscription.

## Known limitation — this is a discriminator, NOT a secret

An email address is a **low-entropy preimage**. Anyone who guesses a candidate
address can confirm it by hashing it, and email-hash reversal is routine. This
value therefore protects against *casual* disclosure and incidental scraping, not
against a party who already suspects a specific address.

It is published deliberately on that understanding: `journal2` is public, the
attribution use-case needs only a join key, and the raw `emailAddress`,
`accountUuid`, and `organizationUuid` remain unpublished (maintainer decision,
2026-08-02).

If a non-reversible identifier is ever needed, replace the plain digest with an
HMAC under a shared salt distributed out-of-band and held OUTSIDE the journal —
same join property, no enumerable preimage.

## Plan shape for this host

    organizationType:          claude_max
    billingType:               stripe_subscription
    organizationRateLimitTier: default_claude_max_20x
    hasExtraUsageEnabled:      false
    organizationRole:          admin
