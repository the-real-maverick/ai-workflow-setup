#!/bin/bash
# ============================================================
# AI Workflow Setup Script
# Sets up: Node.js, Obsidian vault structure, Claude Desktop MCP
# Run: chmod +x setup.sh && ./setup.sh
# ============================================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  AI Workflow Integration Setup${NC}"
echo -e "${BLUE}  Perplexity Max + Claude Max + ChatGPT Plus${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# ---- Step 0: Detect OS ----
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}This script is designed for macOS. Detected: $OSTYPE${NC}"
    exit 1
fi

# ---- Step 1: Find Obsidian Vault ----
echo -e "${YELLOW}Step 1: Locating your Obsidian vault...${NC}"

ICLOUD_BASE="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents"
if [ -d "$ICLOUD_BASE" ]; then
    echo -e "Found iCloud Obsidian directory."
    echo ""
    echo "Available vaults:"
    echo "---"
    VAULT_LIST=()
    i=1
    for dir in "$ICLOUD_BASE"/*/; do
        if [ -d "$dir" ]; then
            VAULT_NAME=$(basename "$dir")
            VAULT_LIST+=("$dir")
            echo "  $i) $VAULT_NAME"
            ((i++))
        fi
    done

    if [ ${#VAULT_LIST[@]} -eq 0 ]; then
        echo -e "${RED}No vaults found in iCloud. Please enter your vault path manually.${NC}"
        read -p "Vault path: " VAULT_PATH
    elif [ ${#VAULT_LIST[@]} -eq 1 ]; then
        VAULT_PATH="${VAULT_LIST[0]}"
        echo ""
        echo -e "Only one vault found: $(basename "$VAULT_PATH")"
        read -p "Use this vault? (y/n): " CONFIRM
        if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
            read -p "Enter vault path manually: " VAULT_PATH
        fi
    else
        echo ""
        read -p "Select vault number: " VAULT_NUM
        VAULT_PATH="${VAULT_LIST[$((VAULT_NUM-1))]}"
    fi
else
    echo -e "${YELLOW}iCloud Obsidian directory not found.${NC}"
    read -p "Enter your Obsidian vault path: " VAULT_PATH
fi

# Remove trailing slash
VAULT_PATH="${VAULT_PATH%/}"

if [ ! -d "$VAULT_PATH" ]; then
    echo -e "${RED}Vault path does not exist: $VAULT_PATH${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Using vault: $VAULT_PATH${NC}"
echo ""

# ---- Step 2: Install Node.js (via Homebrew) ----
echo -e "${YELLOW}Step 2: Checking Node.js installation...${NC}"

if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo -e "${GREEN}✓ Node.js already installed: $NODE_VERSION${NC}"
else
    echo "Node.js not found. Installing via Homebrew..."

    # Install Homebrew if needed
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew first..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Add Homebrew to PATH for Apple Silicon
        if [ -f "/opt/homebrew/bin/brew" ]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    fi

    brew install node
    echo -e "${GREEN}✓ Node.js installed: $(node --version)${NC}"
fi

# Verify npx is available
if ! command -v npx &> /dev/null; then
    echo -e "${RED}npx not found even after Node.js install. Please check your PATH.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ npx available${NC}"
echo ""

# ---- Step 3: Create Vault Folder Structure ----
echo -e "${YELLOW}Step 3: Creating vault folder structure...${NC}"

FOLDERS=(
    "AI-Conversations/Claude"
    "AI-Conversations/ChatGPT"
    "AI-Conversations/Perplexity"
    "Context/projects"
    "Research"
    "Deliverables"
    "Deals"
    "Daily-Notes"
    "Templates"
)

for folder in "${FOLDERS[@]}"; do
    FULL_PATH="$VAULT_PATH/$folder"
    if [ ! -d "$FULL_PATH" ]; then
        mkdir -p "$FULL_PATH"
        echo "  Created: $folder/"
    else
        echo "  Exists:  $folder/"
    fi
done

echo -e "${GREEN}✓ Folder structure ready${NC}"
echo ""

# ---- Step 4: Copy CLAUDE.md and context.md ----
echo -e "${YELLOW}Step 4: Installing context files...${NC}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# CLAUDE.md at vault root
if [ -f "$SCRIPT_DIR/CLAUDE.md" ]; then
    if [ -f "$VAULT_PATH/CLAUDE.md" ]; then
        echo "  CLAUDE.md already exists — backing up to CLAUDE.md.bak"
        cp "$VAULT_PATH/CLAUDE.md" "$VAULT_PATH/CLAUDE.md.bak"
    fi
    cp "$SCRIPT_DIR/CLAUDE.md" "$VAULT_PATH/CLAUDE.md"
    echo -e "  ${GREEN}✓ CLAUDE.md installed at vault root${NC}"
else
    echo -e "  ${YELLOW}⚠ CLAUDE.md not found in setup directory — skipping${NC}"
fi

# context.md in /Context/
if [ -f "$SCRIPT_DIR/Context/context.md" ]; then
    if [ -f "$VAULT_PATH/Context/context.md" ]; then
        echo "  context.md already exists — backing up to context.md.bak"
        cp "$VAULT_PATH/Context/context.md" "$VAULT_PATH/Context/context.md.bak"
    fi
    cp "$SCRIPT_DIR/Context/context.md" "$VAULT_PATH/Context/context.md"
    echo -e "  ${GREEN}✓ context.md installed in /Context/${NC}"
else
    echo -e "  ${YELLOW}⚠ context.md not found — skipping${NC}"
fi

echo ""

# ---- Step 5: Configure Claude Desktop MCP ----
echo -e "${YELLOW}Step 5: Configuring Claude Desktop MCP servers...${NC}"

CLAUDE_CONFIG_DIR="$HOME/Library/Application Support/Claude"
CLAUDE_CONFIG_FILE="$CLAUDE_CONFIG_DIR/claude_desktop_config.json"

# Prompt for Perplexity API key
echo ""
echo "To enable Claude to call Perplexity search, you need a Perplexity API key."
echo "Get one at: https://www.perplexity.ai/settings/api"
echo "(This is separate from your Max subscription — the Sonar API is pay-as-you-go)"
echo ""
read -p "Enter your Perplexity API key (or press Enter to skip): " PPLX_API_KEY

# Escape the vault path for JSON (handle spaces)
VAULT_PATH_ESCAPED=$(echo "$VAULT_PATH" | sed 's/"/\\"/g')

# Build the MCP config
if [ -n "$PPLX_API_KEY" ]; then
    # With Perplexity
    MCP_CONFIG=$(cat <<EOF
{
  "mcpServers": {
    "obsidian-vault": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "$VAULT_PATH_ESCAPED"
      ]
    },
    "perplexity-search": {
      "command": "npx",
      "args": ["-y", "server-perplexity-ask"],
      "env": {
        "PERPLEXITY_API_KEY": "$PPLX_API_KEY"
      }
    }
  }
}
EOF
)
    echo -e "  ${GREEN}✓ Perplexity MCP server configured${NC}"
else
    # Without Perplexity
    MCP_CONFIG=$(cat <<EOF
{
  "mcpServers": {
    "obsidian-vault": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "$VAULT_PATH_ESCAPED"
      ]
    }
  }
}
EOF
)
    echo -e "  ${YELLOW}⚠ Perplexity MCP skipped — you can add it later${NC}"
fi

# Handle existing config
if [ -f "$CLAUDE_CONFIG_FILE" ]; then
    echo ""
    echo -e "${YELLOW}  Existing Claude Desktop config found.${NC}"
    echo "  Current config:"
    cat "$CLAUDE_CONFIG_FILE"
    echo ""
    echo "  Options:"
    echo "    1) Replace with new config (backup old one)"
    echo "    2) Show new config so I can merge manually"
    echo "    3) Skip Claude Desktop config"
    read -p "  Choice (1/2/3): " CONFIG_CHOICE

    case $CONFIG_CHOICE in
        1)
            cp "$CLAUDE_CONFIG_FILE" "$CLAUDE_CONFIG_FILE.bak.$(date +%Y%m%d_%H%M%S)"
            echo "$MCP_CONFIG" > "$CLAUDE_CONFIG_FILE"
            echo -e "  ${GREEN}✓ Config replaced (backup saved)${NC}"
            ;;
        2)
            echo ""
            echo "  New config to merge:"
            echo "  ---"
            echo "$MCP_CONFIG"
            echo "  ---"
            echo "  Add the mcpServers entries to your existing config."
            ;;
        3)
            echo "  Skipped."
            ;;
    esac
else
    mkdir -p "$CLAUDE_CONFIG_DIR"
    echo "$MCP_CONFIG" > "$CLAUDE_CONFIG_FILE"
    echo -e "  ${GREEN}✓ Claude Desktop config created${NC}"
fi

echo ""

# ---- Step 6: Pre-cache MCP packages ----
echo -e "${YELLOW}Step 6: Pre-downloading MCP server packages...${NC}"
echo "  (This speeds up Claude Desktop's first connection)"

npx -y @modelcontextprotocol/server-filesystem --help > /dev/null 2>&1 || true
echo -e "  ${GREEN}✓ Filesystem MCP server cached${NC}"

if [ -n "$PPLX_API_KEY" ]; then
    npx -y server-perplexity-ask --help > /dev/null 2>&1 || true
    echo -e "  ${GREEN}✓ Perplexity MCP server cached${NC}"
fi

echo ""

# ---- Step 7: Create .gitignore for vault (optional) ----
if [ ! -f "$VAULT_PATH/.gitignore" ]; then
    cat > "$VAULT_PATH/.gitignore" << 'GITIGNORE'
.obsidian/workspace.json
.obsidian/workspace-mobile.json
.obsidian/plugins/*/data.json
.trash/
.DS_Store
GITIGNORE
    echo -e "${GREEN}✓ .gitignore created for vault${NC}"
fi

# ---- Done ----
echo ""
echo -e "${BLUE}============================================${NC}"
echo -e "${GREEN}  Setup Complete!${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""
echo "What was configured:"
echo "  ✓ Node.js and npx available"
echo "  ✓ Vault folder structure created"
echo "  ✓ CLAUDE.md installed at vault root"
echo "  ✓ context.md installed in /Context/"
echo "  ✓ Claude Desktop MCP config (vault access$([ -n "$PPLX_API_KEY" ] && echo " + Perplexity search"))"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Restart Claude Desktop (quit and reopen)"
echo "  2. Look for the hammer/tools icon in Claude Desktop — that confirms MCP is working"
echo "  3. Test: Ask Claude 'What files are in my Obsidian vault?'"
echo "  4. Install the 'Perplexity to Obsidian' Chrome extension:"
echo "     https://extpose.com/ext/afmlkbanimddphcomahlfbaandfphjfk"
echo "  5. Install the 'Local REST API' Obsidian plugin (for advanced MCP features later)"
echo ""
echo "  Vault path: $VAULT_PATH"
echo "  Claude config: $CLAUDE_CONFIG_FILE"
echo ""
