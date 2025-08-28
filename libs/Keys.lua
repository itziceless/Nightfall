-- LicenseKeys Module
-- Format: Key = { type = "1D"/"7D"/"1M"/"FOREVER", created = os.time() }
local LicenseKeys = {
    ["AB12-CD34-EF56"] = { type = "1D", created = os.time() },
    ["GH78-IJ90-KL12"] = { type = "1W", created = os.time() },
    ["MN34-OP56-QR78"] = { type = "FOREVER", created = os.time() },
    ["ST90-UV12-WX34"] = { type = "1M", created = os.time() },
    ["YZ56-AB78-CD90"] = { type = "1D", created = os.time() },
    ["EF12-GH34-IJ56"] = { type = "FOREVER", created = os.time() },
    ["KL78-MN90-OP12"] = { type = "1D", created = os.time() },
    ["QR34-ST56-UV78"] = { type = "1W", created = os.time() },
    ["WX90-YZ12-AB34"] = { type = "FOREVER", created = os.time() },
    ["CD56-EF78-GH90"] = { type = "1W", created = os.time() },
    ["IJ12-KL34-MN56"] = { type = "1D", created = os.time() },
    ["OP78-QR90-ST12"] = { type = "FOREVER", created = os.time() },
    ["UV34-WX56-YZ78"] = { type = "1W", created = os.time() },
    ["AB90-CD12-EF34"] = { type = "1D", created = os.time() },
    ["GH56-IJ78-KL90"] = { type = "FOREVER", created = os.time() },
    ["MN12-OP34-QR56"] = { type = "1W", created = os.time() },
    ["ST78-UV90-WX12"] = { type = "1D", created = os.time() },
    ["YZ34-AB56-CD78"] = { type = "FOREVER", created = os.time() },
    ["EF90-GH12-IJ34"] = { type = "1W", created = os.time() },
    ["KL56-MN78-OP90"] = { type = "1D", created = os.time() },
    ["QR12-ST34-UV56"] = { type = "FOREVER", created = os.time() },
    ["WX78-YZ90-AB12"] = { type = "1W", created = os.time() },
    ["CD34-EF56-GH78"] = { type = "1D", created = os.time() },
    ["IJ90-KL12-MN34"] = { type = "FOREVER", created = os.time() },
    ["OP56-QR78-ST90"] = { type = "1W", created = os.time() },
}

-- Function to check if a key is valid and not expired
local function isKeyValid(key)
    local info = LicenseKeys[key]
    if not info then return false end

    if info.type == "FOREVER" then
        return true
    end

    local elapsed = os.time() - info.created
    if info.type == "1D" and elapsed <= 86400 then return true end
    if info.type == "1W" and elapsed <= 604800 then return true end
    if info.type == "1M" and elapsed <= 2592000 then return true end

    return false
end

return {
    isKeyValid = isKeyValid,
    LicenseKeys = LicenseKeys
}
