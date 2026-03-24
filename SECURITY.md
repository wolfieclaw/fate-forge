# Security

This repo should stay free of plaintext secrets.

## Rules

- Never commit API keys, tokens, passwords, `.env` files, or private keys.
- Run the local secret scan before pushing meaningful changes.
- Keep local scratch files and credentials out of version control.

## Secret scan

Run:

```bash
./scripts/scan-secrets.sh
```

To install local git hooks that run the scan automatically:

```bash
./scripts/install-git-hooks.sh
```

## Ignore rules

The repo `.gitignore` blocks common secret-bearing and local clutter files, but `.gitignore` is not enough by itself.

## If a leak happens

1. Rotate/revoke the secret immediately.
2. Remove it from the working tree.
3. Rewrite git history if the secret was committed.
4. Force-push the cleaned history if needed.
5. Re-scan the repo.
