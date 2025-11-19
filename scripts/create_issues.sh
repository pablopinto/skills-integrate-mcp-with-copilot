#!/usr/bin/env bash
set -euo pipefail

# Script to create issues listed in ISSUES_TO_CREATE.md
# Prefer `gh` (GitHub CLI). If not available, fallback to curl using GITHUB_TOKEN.

REPO_OWNER="pablopinto"
REPO_NAME="skills-integrate-mcp-with-copilot"

if command -v gh >/dev/null 2>&1; then
  echo "Using gh to create issues..."
  # This simple parser expects blocks separated by '---' and a 'Title: ' line
  n=0
  while IFS= read -r block; do
    ((n++))
    title=$(echo "$block" | sed -n 's/^Title: \(.*\)/\1/p' | sed 's/^ *//;s/ *$//')
    body=$(echo "$block" | sed -n '1,200p' | sed -n '/^Body:/,/^Labels:/p' | sed '1d;$d')
    if [ -n "$title" ]; then
      echo "Creating issue: $title"
      gh issue create --repo "$REPO_OWNER/$REPO_NAME" --title "$title" --body "$body" || true
    fi
  done < <(awk 'BEGIN{RS="---"} {print}' ISSUES_TO_CREATE.md)
  echo "Done (gh)."
  exit 0
fi

if [ -z "${GITHUB_TOKEN-}" ]; then
  echo "gh not found and GITHUB_TOKEN is not set. Please install gh or set GITHUB_TOKEN." >&2
  exit 2
fi

echo "Using GitHub API (curl) to create issues..."
API_URL="https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/issues"

awk 'BEGIN{RS="---"} /Title: /{print}' ISSUES_TO_CREATE.md | while IFS= read -r block; do
  title=$(echo "$block" | sed -n 's/^Title: \(.*\)/\1/p' | sed 's/^ *//;s/ *$//')
  body=$(echo "$block" | sed -n '1,200p' | sed -n '/^Body:/,/^Labels:/p' | sed '1d;$d' | sed 's/\n/\\n/g')
  if [ -n "$title" ]; then
    echo "Creating issue: $title"
    payload=$(jq -n --arg t "$title" --arg b "$body" '{title:$t, body:$b}')
    curl -s -X POST -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" "$API_URL" -d "$payload" >/dev/null || true
  fi
done

echo "Done (curl)."
