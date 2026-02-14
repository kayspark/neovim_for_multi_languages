# Git Signing Runbook

Last updated: 2026-02-06

## Goal
Enable signed Git commits using GPG so `git commit` succeeds with `commit.gpgsign=true`.

## Current Git Settings
- `user.signingkey=9C5BB2C9D5BAA155`
- `commit.gpgsign=true`
- `gpg.program=gpg`

## Setup
1. Confirm binaries:
```bash
which gpg
which pinentry
```
2. Configure `gpg-agent` (use GnuPG homedir from `gpgconf`):
```bash
GNUPG_HOME="$(gpgconf --list-dirs homedir)"
mkdir -p "$GNUPG_HOME"
cat > "$GNUPG_HOME/gpg-agent.conf" <<'EOF'
pinentry-program /opt/local/bin/pinentry
default-cache-ttl 21600
max-cache-ttl 86400
EOF
chmod 700 "$GNUPG_HOME"
chmod 600 "$GNUPG_HOME/gpg-agent.conf"
```
3. Ensure shell exports terminal for pinentry:
```bash
cat >> ~/.zshrc <<'EOF'

# GnuPG / git signing
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1
EOF
source ~/.zshrc
```
4. Restart agent:
```bash
gpgconf --kill gpg-agent
gpgconf --launch gpg-agent
gpg-connect-agent 'GETINFO pid' /bye
```

## Verification
```bash
echo "test" | gpg --clearsign >/dev/null && echo "gpg sign OK"
git commit -S --allow-empty -m "test signed commit"
```

## Troubleshooting
- If you get `No agent running`, run:
```bash
gpgconf --kill gpg-agent
gpgconf --launch gpg-agent
gpg-connect-agent updatestartuptty /bye
```
- If socket binding fails (`error binding socket ... Operation not permitted`), run the restart commands in a normal local shell (not a restricted sandbox/runner).
