-- LicenseKeys Module
-- Key = { type = "1D"/"1W"/"1M"/"FOREVER", firstUse = os.time() or nil }
local LicenseKeys = {
    ["OWNER-AB12-CD34-EF56"] = { type = "FOREVER", firstUse = true },
    ["ADMIN-GH78-IJ90-KL12"] = { type = "FOREVER", firstUse = true },
    ["ADMIN-MN34-OP56-QR78"] = { type = "FOREVER", firstUse = true },
    ["GH78-UV12-QR78"] = { type = "1D", firstUse = nil },
    ["ST90-UV12-WX34"] = { type = "1W", firstUse = nil },
    ["YZ56-AB78-CD90"] = { type = "1M", firstUse = nil },
}

-- Function to check if a key is valid and not expired
local function isKeyValid(key)
    local info = LicenseKeys[key]
    if not info then return false end

    if info.type == "FOREVER" then
        return true
    end

    -- If first use is nil, set it now (start the timer)
    if not info.firstUse then
        info.firstUse = os.time()
        return true
    end

    local elapsed = os.time() - info.firstUse
    if info.type == "1D" and elapsed <= 86400 then return true end
    if info.type == "1W" and elapsed <= 604800 then return true end
    if info.type == "1M" and elapsed <= 2592000 then return true end

    return false
end

return {
    isKeyValid = isKeyValid,
    LicenseKeys = LicenseKeys
}
