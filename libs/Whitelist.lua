getgenv().LicenseKeys = {
    ["AB12-CD34-EF56"] = { type = "1D", firstUse = nil },
    ["GH78-IJ90-KL12"] = { type = "1W", firstUse = nil },
    ["MN34-OP56-QR78"] = { type = "FOREVER", firstUse = nil },
    ["ST90-UV12-WX34"] = { type = "1M", firstUse = nil },
}

-- Function to check if a key is valid
getgenv().VerifyLicense = function()
    local key = getgenv().License
    local info = getgenv().LicenseKeys[key]
    if not info then return false end

    if info.type == "FOREVER" then
        return true
    end

    -- Start timer on first use
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

-- Example usage
if getgenv().VerifyLicense() then
    
else
    error("License invalid or expired.")
end
