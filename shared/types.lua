---@class BridgePlayer
---@field source number
---@field identifier string
---@field firstname string
---@field lastname string
---@field name string
---@field job string
---@field grade number
---@field money number
---@field bank number
---@field crypto number
---@field metadata table
---@field AddMoney fun(account: string, amount: number, reason?: string)
---@field RemoveMoney fun(account: string, amount: number, reason?: string)
---@field SetMoney fun(account: string, amount: number)
---@field SetJob fun(job: string, grade: number)

Bridge = Bridge or {}

-- Annotations only, no function bodies here to avoid overwriting real logic
---@return string
function Bridge.GetFramework() end

---@param source number
---@return BridgePlayer
function Bridge.GetPlayer(source) end
