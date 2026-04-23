PLENARY := $(shell nvim --headless -c "echo stdpath('data')" -c qa 2>&1)/site/pack/test/start/plenary.nvim

.PHONY: test deps

deps:
	@if [ ! -d "$(PLENARY)" ]; then \
		git clone --depth=1 https://github.com/nvim-lua/plenary.nvim "$(PLENARY)"; \
	fi

test: deps
	nvim --headless --noplugin -u tests/minimal_init.lua \
		-c "PlenaryBustedDirectory tests/ { minimal_mode = true }" \
		2>&1
