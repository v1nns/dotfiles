local present, virtcolumn = pcall(require, "virt-column")

if not present then
    return
end

local options = { char = "|" }

virtcolumn.setup(options)
