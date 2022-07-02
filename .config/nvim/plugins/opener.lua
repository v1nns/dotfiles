local present, opener = pcall(require, "opener.nvim")

if not present then
   return
end

opener.setup(options)
