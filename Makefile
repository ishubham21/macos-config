# =============================================================================
# Makefile - Dotfiles Build Automation
# =============================================================================

.PHONY: help install update backup restore test clean lint format doctor

# Default target
.DEFAULT_GOAL := help

# Colors
CYAN := \033[36m
GREEN := \033[32m
YELLOW := \033[33m
RED := \033[31m
RESET := \033[0m

# Variables
DOTFILES_DIR := $(PWD)
BACKUP_DIR := $(HOME)/.dotfiles-backup-$(shell date +%Y%m%d_%H%M%S)
SHELL_CHECK := $(shell command -v shellcheck 2> /dev/null)

##@ Main Commands

help: ## Display this help message
	@echo "$(CYAN)Dotfiles Management$(RESET)"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"; printf "Usage:\n  make $(CYAN)<target>$(RESET)\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  $(CYAN)%-15s$(RESET) %s\n", $$1, $$2 } /^##@/ { printf "\n$(YELLOW)%s$(RESET)\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

install: ## Install dotfiles (interactive)
	@echo "$(GREEN)Installing dotfiles...$(RESET)"
	@chmod +x install.sh
	@./install.sh

install-force: ## Force install dotfiles (non-interactive)
	@echo "$(GREEN)Force installing dotfiles...$(RESET)"
	@chmod +x install.sh
	@./install.sh --force

##@ Development

test: ## Run tests on dotfiles
	@echo "$(GREEN)Running dotfiles tests...$(RESET)"
	@$(MAKE) test-shell
	@$(MAKE) test-links
	@$(MAKE) test-syntax

test-shell: ## Test shell scripts
	@echo "$(CYAN)Testing shell scripts...$(RESET)"
ifdef SHELL_CHECK
	@find . -name "*.sh" -exec shellcheck {} \;
	@find zsh -name "*.zsh" -exec shellcheck {} \;
else
	@echo "$(YELLOW)Warning: shellcheck not found, skipping shell tests$(RESET)"
endif

test-links: ## Test that all symlinks are valid
	@echo "$(CYAN)Testing symlinks...$(RESET)"
	@if [ -L ~/.zshrc ]; then \
		if [ -e ~/.zshrc ]; then \
			echo "$(GREEN)✓ .zshrc symlink is valid$(RESET)"; \
		else \
			echo "$(RED)✗ .zshrc symlink is broken$(RESET)"; \
		fi; \
	else \
		echo "$(YELLOW)! .zshrc is not a symlink$(RESET)"; \
	fi

test-syntax: ## Test ZSH syntax
	@echo "$(CYAN)Testing ZSH syntax...$(RESET)"
	@zsh -n zsh/.zshrc || echo "$(RED)✗ ZSH syntax error in .zshrc$(RESET)"
	@for file in zsh/*.zsh; do \
		echo "Testing $$file"; \
		zsh -n "$$file" || echo "$(RED)✗ ZSH syntax error in $$file$(RESET)"; \
	done

lint: ## Lint all shell scripts
	@echo "$(GREEN)Linting shell scripts...$(RESET)"
ifdef SHELL_CHECK
	@shellcheck install.sh
	@shellcheck scripts/*.sh 2>/dev/null || true
	@find zsh -name "*.zsh" -exec shellcheck {} \;
else
	@echo "$(RED)Error: shellcheck not found. Install with: brew install shellcheck$(RESET)"
	@exit 1
endif

format: ## Format shell scripts
	@echo "$(GREEN)Formatting shell scripts...$(RESET)"
	@if command -v shfmt >/dev/null 2>&1; then \
		shfmt -w -i 4 install.sh; \
		find scripts -name "*.sh" -exec shfmt -w -i 4 {} \; 2>/dev/null || true; \
	else \
		echo "$(YELLOW)Warning: shfmt not found. Install with: brew install shfmt$(RESET)"; \
	fi

##@ Maintenance

update: ## Update dotfiles and dependencies
	@echo "$(GREEN)Updating dotfiles...$(RESET)"
	@if git remote get-url origin >/dev/null 2>&1; then \
		git pull origin main || git pull origin master; \
	else \
		echo "$(YELLOW)No remote origin configured - skipping update$(RESET)"; \
		echo "$(CYAN)To set up remote: git remote add origin <your-repo-url>$(RESET)"; \
	fi
	@$(MAKE) update-submodules
	@$(MAKE) update-plugins
	@echo "$(GREEN)✓ Dotfiles updated$(RESET)"

update-submodules: ## Update git submodules
	@echo "$(CYAN)Updating git submodules...$(RESET)"
	@git submodule update --init --recursive
	@git submodule update --remote

update-plugins: ## Update Oh My Zsh and plugins
	@echo "$(CYAN)Updating Oh My Zsh...$(RESET)"
	@if [ -d "$(HOME)/.oh-my-zsh" ]; then \
		cd $(HOME)/.oh-my-zsh && git pull origin master; \
	fi
	@echo "$(CYAN)Updating custom plugins...$(RESET)"
	@if [ -d "$(HOME)/.oh-my-zsh/custom/plugins" ]; then \
		for plugin in $(HOME)/.oh-my-zsh/custom/plugins/*; do \
			if [ -d "$plugin/.git" ]; then \
				echo "Updating $(basename $plugin)..."; \
				cd "$plugin" && git pull; \
			fi; \
		done; \
	fi

backup: ## Create backup of current dotfiles
	@echo "$(GREEN)Creating backup...$(RESET)"
	@mkdir -p $(BACKUP_DIR)
	@if [ -f ~/.zshrc ]; then cp ~/.zshrc $(BACKUP_DIR)/; fi
	@if [ -f ~/.gitconfig ]; then cp ~/.gitconfig $(BACKUP_DIR)/; fi
	@if [ -f ~/.vimrc ]; then cp ~/.vimrc $(BACKUP_DIR)/; fi
	@if [ -f ~/.ssh/config ]; then cp ~/.ssh/config $(BACKUP_DIR)/; fi
	@echo "$(GREEN)✓ Backup created at $(BACKUP_DIR)$(RESET)"

restore: ## Restore from backup (specify BACKUP_DIR)
	@if [ -z "$(BACKUP_DIR)" ]; then \
		echo "$(RED)Error: Please specify BACKUP_DIR=path/to/backup$(RESET)"; \
		exit 1; \
	fi
	@echo "$(GREEN)Restoring from $(BACKUP_DIR)...$(RESET)"
	@if [ -f $(BACKUP_DIR)/.zshrc ]; then cp $(BACKUP_DIR)/.zshrc ~/.zshrc; fi
	@if [ -f $(BACKUP_DIR)/.gitconfig ]; then cp $(BACKUP_DIR)/.gitconfig ~/.gitconfig; fi
	@if [ -f $(BACKUP_DIR)/.vimrc ]; then cp $(BACKUP_DIR)/.vimrc ~/.vimrc; fi
	@if [ -f $(BACKUP_DIR)/config ]; then cp $(BACKUP_DIR)/config ~/.ssh/config; fi
	@echo "$(GREEN)✓ Restored from backup$(RESET)"

clean: ## Clean up broken symlinks and temporary files
	@echo "$(GREEN)Cleaning up...$(RESET)"
	@find ~ -maxdepth 1 -name ".*" -type l -exec test ! -e {} \; -delete 2>/dev/null || true
	@rm -f ~/.dotfiles-install.log
	@rm -rf ~/.dotfiles-tmp
	@echo "$(GREEN)✓ Cleanup completed$(RESET)"

##@ Utilities

doctor: ## Run system diagnostics
	@echo "$(GREEN)Running dotfiles diagnostics...$(RESET)"
	@echo ""
	@echo "$(CYAN)=== System Information ===$(RESET)"
	@echo "OS: $(uname -s)"
	@echo "Shell: $SHELL"
	@echo "Zsh version: $(zsh --version 2>/dev/null || echo 'Not installed')"
	@echo "Git version: $(git --version 2>/dev/null || echo 'Not installed')"
	@echo ""
	@echo "$(CYAN)=== Dotfiles Status ===$(RESET)"
	@echo "Dotfiles directory: $(DOTFILES_DIR)"
	@echo "Git status: $(cd $(DOTFILES_DIR) && git status --porcelain | wc -l | tr -d ' ') uncommitted changes"
	@echo "Last update: $(cd $(DOTFILES_DIR) && git log -1 --format='%cr')"
	@echo ""
	@echo "$(CYAN)=== Symlinks Status ===$(RESET)"
	@if [ -L ~/.zshrc ]; then \
		echo "✓ .zshrc -> $(readlink ~/.zshrc)"; \
	else \
		echo "✗ .zshrc (not a symlink)"; \
	fi
	@if [ -L ~/.gitconfig ]; then \
		echo "✓ .gitconfig -> $(readlink ~/.gitconfig)"; \
	else \
		echo "✗ .gitconfig (not a symlink)"; \
	fi
	@echo ""
	@echo "$(CYAN)=== Oh My Zsh Status ===$(RESET)"
	@if [ -d ~/.oh-my-zsh ]; then \
		echo "✓ Oh My Zsh installed"; \
		echo "Plugins: $(ls ~/.oh-my-zsh/custom/plugins 2>/dev/null | wc -l | tr -d ' ') custom plugins"; \
	else \
		echo "✗ Oh My Zsh not installed"; \
	fi
	@echo ""
	@echo "$(CYAN)=== Package Managers ===$(RESET)"
	@if command -v brew >/dev/null 2>&1; then \
		echo "✓ Homebrew: $(brew --version | head -1)"; \
	else \
		echo "✗ Homebrew not installed"; \
	fi
	@if command -v npm >/dev/null 2>&1; then \
		echo "✓ npm: $(npm --version)"; \
	else \
		echo "✗ npm not installed"; \
	fi

links: ## Show all dotfiles symlinks
	@echo "$(GREEN)Dotfiles symlinks:$(RESET)"
	@find ~ -maxdepth 1 -name ".*" -type l -exec ls -la {} \; | grep "\.dotfiles" | sort

edit: ## Open dotfiles in editor
	@echo "$(GREEN)Opening dotfiles in $EDITOR...$(RESET)"
	@$EDITOR $(DOTFILES_DIR)

##@ Advanced

benchmark: ## Benchmark shell startup time
	@echo "$(GREEN)Benchmarking shell startup time...$(RESET)"
	@echo "Running 10 iterations..."
	@for i in $(seq 1 10); do \
		/usr/bin/time -p zsh -i -c exit 2>&1 | grep real | awk '{print $2}'; \
	done | awk '{sum+=$1; count++} END {print "Average startup time: " sum/count " seconds"}'

profile: ## Profile zsh startup (requires zprof)
	@echo "$(GREEN)Profiling zsh startup...$(RESET)"
	@echo "Add 'zmodload zsh/zprof' to the top of your .zshrc and 'zprof' to the bottom"
	@echo "Then run: zsh -i -c exit"

deps: ## Install development dependencies
	@echo "$(GREEN)Installing development dependencies...$(RESET)"
	@if command -v brew >/dev/null 2>&1; then \
		brew install shellcheck shfmt; \
	else \
		echo "$(RED)Error: Homebrew not found. This dotfiles setup requires macOS with Homebrew$(RESET)"; \
		exit 1; \
	fi

init: ## Initialize new dotfiles repository
	@echo "$(GREEN)Initializing new dotfiles repository...$(RESET)"
	@git init
	@git add .
	@git commit -m "feat: initial dotfiles setup"
	@echo "$(GREEN)✓ Repository initialized$(RESET)"
	@echo "$(CYAN)Next steps:$(RESET)"
	@echo "1. Create a repository on GitHub/GitLab"
	@echo "2. Add remote: git remote add origin <your-repo-url>"
	@echo "3. Push: git push -u origin main"

##@ Installation Variants

install-minimal: ## Install minimal dotfiles (zsh only)
	@echo "$(GREEN)Installing minimal dotfiles...$(RESET)"
	@./install.sh --skip-packages

install-dev: ## Install dotfiles with development tools
	@echo "$(GREEN)Installing dotfiles with development tools...$(RESET)"
	@./install.sh
	@$(MAKE) install-dev-tools

install-dev-tools: ## Install additional development tools
	@echo "$(GREEN)Installing development tools...$(RESET)"
	@if command -v brew >/dev/null 2>&1; then \
		brew install fzf ripgrep fd bat exa neovim tmux jq; \
		brew install --cask visual-studio-code docker; \
	else \
		echo "$(RED)Error: Homebrew not found. This dotfiles setup requires macOS with Homebrew$(RESET)"; \
		exit 1; \
	fi

##@ Git Operations

commit: ## Commit changes with conventional commit format
	@echo "$(GREEN)Committing changes...$(RESET)"
	@git add .
	@read -p "Commit type (feat/fix/docs/style/refactor/test/chore): " type; \
	read -p "Commit message: " msg; \
	git commit -m "$type: $msg"

push: ## Push changes to remote repository
	@echo "$(GREEN)Pushing changes...$(RESET)"
	@git push origin main || git push origin master

pull: ## Pull latest changes from remote repository
	@echo "$(GREEN)Pulling latest changes...$(RESET)"
	@git pull origin main || git pull origin master

status: ## Show git status and system info
	@echo "$(CYAN)=== Git Status ===$(RESET)"
	@git status
	@echo ""
	@echo "$(CYAN)=== Recent Commits ===$(RESET)"
	@git log --oneline -5
	@echo ""
	@$(MAKE) doctor

##@ Help

list: ## List all available make targets
	@$(MAKE) -pRrq -f $(firstword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($1 !~ "^[#.]") {print $1}}' | sort | grep -E -v -e '^[^[:alnum:]]' -e '^$@$'

debug: ## Show makefile variables
	@echo "$(CYAN)Makefile Variables:$(RESET)"
	@echo "DOTFILES_DIR: $(DOTFILES_DIR)"
	@echo "BACKUP_DIR: $(BACKUP_DIR)"
	@echo "SHELL_CHECK: $(SHELL_CHECK)"
	@echo "HOME: $(HOME)"
	@echo "PWD: $(PWD)"

# Include local makefile if it exists
-include Makefile.local "
