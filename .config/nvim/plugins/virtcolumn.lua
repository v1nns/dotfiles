local present, virtcolumn = pcall(require, "virt-column")

if not present then
    return
end

local options = {
    virtcolumn = "101",
    char = "|",
}

virtcolumn.setup(options)
