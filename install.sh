#!/usr/bin/env bash
# install.sh — Installer for cypress-agent-skill
#
# Usage:
#   bash install.sh                        # auto-detect or default to .agents/skills/
#   bash install.sh --agent open-claw      # ~/.openclaw/skills/cypress-agent-skill/
#   bash install.sh --agent claude-code    # ./.claude/skills/cypress-agent-skill/
#   bash install.sh --agent codex          # ./.agents/skills/cypress-agent-skill/
#   bash install.sh --agent cursor         # ./.cursor/skills/cypress-agent-skill/
#   bash install.sh --agent global         # ~/.agents/skills/cypress-agent-skill/

set -euo pipefail

REPO_URL="https://github.com/kahlilr23/cypress-agent-skill"
SKILL_NAME="cypress-agent-skill"
AGENT_NAME="default"

# Parse --agent flag
while [[ $# -gt 0 ]]; do
  case "$1" in
    --agent=*)
      AGENT_NAME="${1#*=}"
      shift
      ;;
    --agent)
      AGENT_NAME="${2:-default}"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

# Auto-detect agent if not specified
if [ "$AGENT_NAME" = "default" ]; then
  if [ -d "$HOME/.openclaw" ]; then
    AGENT_NAME="open-claw"
    echo "🦞 Detected OpenClaw installation"
  elif [ -d ".claude" ] || command -v claude &>/dev/null; then
    AGENT_NAME="claude-code"
    echo "🤖 Detected Claude Code"
  else
    AGENT_NAME="global"
  fi
fi

# Resolve install path
case "$AGENT_NAME" in
  open-claw|openclaw)
    INSTALL_DIR="${HOME}/.openclaw/skills/${SKILL_NAME}"
    ;;
  claude-code|claude)
    INSTALL_DIR="./.claude/skills/${SKILL_NAME}"
    ;;
  claude-global)
    INSTALL_DIR="${HOME}/.claude/skills/${SKILL_NAME}"
    ;;
  codex)
    INSTALL_DIR="./.agents/skills/${SKILL_NAME}"
    ;;
  cursor)
    INSTALL_DIR="./.cursor/skills/${SKILL_NAME}"
    ;;
  global)
    INSTALL_DIR="${HOME}/.agents/skills/${SKILL_NAME}"
    ;;
  *)
    INSTALL_DIR="./.agents/skills/${SKILL_NAME}"
    ;;
esac

echo ""
echo "🧪 Installing cypress-agent-skill"
echo "   Agent:   ${AGENT_NAME}"
echo "   Target:  ${INSTALL_DIR}"
echo ""

# Create parent directory
mkdir -p "$(dirname "${INSTALL_DIR}")"

# Clone or update
if [ -d "${INSTALL_DIR}/.git" ]; then
  echo "📦 Updating existing installation..."
  git -C "${INSTALL_DIR}" pull origin main --quiet
  echo "✅ Updated to latest version"
elif [ -d "${INSTALL_DIR}" ] && [ "$(ls -A "${INSTALL_DIR}")" ]; then
  echo "⚠️  Directory ${INSTALL_DIR} already exists and is not empty."
  echo "   Remove it and re-run, or update manually with: git -C ${INSTALL_DIR} pull"
  exit 1
else
  echo "📥 Cloning..."
  git clone --quiet "${REPO_URL}" "${INSTALL_DIR}"
  echo "✅ Installed"
fi

echo ""
echo "📁 Location: ${INSTALL_DIR}"
echo "📖 Main skill: ${INSTALL_DIR}/SKILL.md"
echo "📚 References: ${INSTALL_DIR}/references/"
echo "💡 Examples:   ${INSTALL_DIR}/examples/"
echo ""
echo "🚀 Your agent will now use this skill automatically when writing Cypress tests."
echo "   Or invoke it directly: /cypress-agent-skill"
echo ""