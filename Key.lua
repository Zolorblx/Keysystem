--[[
    ================================================================
    [ SCRIPT INFORMATION ]
    Project: Custom Script
    Author: OYB
    YouTube: https://www.youtube.com/channel/UCAlXXV1Hbvf7WbfXARuVtiQ

    [ TERMS AND CONDITIONS ]
    - You ARE allowed to use and modify this script for your own games.
    - You ARE NOT allowed to re-upload, redistribute, or claim
      ownership of this script.
    - Removing or altering these credits is strictly prohibited.

    Copyright (c) 2026 OYB. All rights reserved.
    ================================================================
]]

local Config = {
    ----------------------------------------------------------------
    -- [1] PlatoBoost Settings
    ----------------------------------------------------------------
    ServiceId = 30834,

    -- IMPORTANT:
    -- Put your NEWLY ROTATED PlatoBoost secret here.
    PlatoSecret = "37b9d1d0-5c79-4d26-bc60-42f94917d279",

    ----------------------------------------------------------------
    -- [2] Anti-Bypass / Global Secret Variable
    ----------------------------------------------------------------
    Secret = "zolopogi123",

    ----------------------------------------------------------------
    -- [3] Scripts & Links
    ----------------------------------------------------------------
    MainScriptURL =
        "https://raw.githubusercontent.com/Zolorblx/Keysystem/refs/heads/main/ZoloScript.lua",

    ----------------------------------------------------------------
    -- [4] Social Media
    ----------------------------------------------------------------
    ShowDiscord = false,
    DiscordURL = "https://discord.gg/kT55J724BK",

    ShowInstagram = false,
    InstagramURL = "https://www.instagram.com/oyb0i/",

    ShowYoutube = false,
    YoutubeURL =
        "https://www.youtube.com/channel/UCAlXXV1Hbvf7WbfXARuVtiQ",

    ----------------------------------------------------------------
    -- [5] File System
    ----------------------------------------------------------------
    KeyFileName = "Mykey.txt",

    ----------------------------------------------------------------
    -- [6] GUI Management
    ----------------------------------------------------------------
    OldGuiName = "KARINDERYA",
    MainGuiName = "KARINDERYA",

    ----------------------------------------------------------------
    -- [7] Hub Information
    ----------------------------------------------------------------
    HubName = "ZOLO",
    HubDescription = "5$ for lifetime?"
}

----------------------------------------------------------------
-- SERVICES
----------------------------------------------------------------

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer

----------------------------------------------------------------
-- COMPATIBILITY
----------------------------------------------------------------

local function getRequestFunction()
    return request
        or http_request
        or syn_request
        or (http and http.request)
end

local fSetClipboard =
    setclipboard
    or toclipboard
    or function()
    end

local fGetHwid =
    gethwid
    or function()
        return game:GetService("RbxAnalyticsService"):GetClientId()
    end

----------------------------------------------------------------
-- SHA256
----------------------------------------------------------------

local bit = bit32

local function sha256(message)
    local K = {
        0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
        0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
        0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
        0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
        0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
        0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
        0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
        0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
        0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
        0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
        0xa2bfe8a1, 0xa81a664b, 0xa2bfe8a1, 0xc24b8b70,
        0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585,
        0x106aa070, 0x19a4c116, 0x1e376c08, 0x2748774c,
        0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f,
        0x682e6ff3, 0x748f82ee, 0x78a5636f, 0x84c87814,
        0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7,
        0xc67178f2
    }

    -- Correct the accidental duplicate constant above.
    K[31] = 0xa831c66d
    K[33] = 0xc24b8b70

    local H = {
        0x6a09e667,
        0xbb67ae85,
        0x3c6ef372,
        0xa54ff53a,
        0x510e527f,
        0x9b05688c,
        0x1f83d9ab,
        0x5be0cd19
    }

    local function rrotate(x, n)
        return bit.rrotate(x, n)
    end

    local data = message
    local bitLength = #data * 8

    data = data .. string.char(0x80)

    while (#data % 64) ~= 56 do
        data = data .. "\0"
    end

    local high = math.floor(bitLength / 4294967296)
    local low = bitLength % 4294967296

    data = data
        .. string.char(
            bit.rshift(high, 24),
            bit.band(bit.rshift(high, 16), 255),
            bit.band(bit.rshift(high, 8), 255),
            bit.band(high, 255),
            bit.rshift(low, 24),
            bit.band(bit.rshift(low, 16), 255),
            bit.band(bit.rshift(low, 8), 255),
            bit.band(low, 255)
        )

    for chunkStart = 1, #data, 64 do
        local W = {}

        for i = 0, 15 do
            local p = chunkStart + i * 4

            W[i + 1] =
                data:byte(p) * 16777216
                + data:byte(p + 1) * 65536
                + data:byte(p + 2) * 256
                + data:byte(p + 3)
        end

        for i = 17, 64 do
            local x = W[i - 15]
            local y = W[i - 2]

            local s0 =
                bit.bxor(
                    rrotate(x, 7),
                    rrotate(x, 18),
                    bit.rshift(x, 3)
                )

            local s1 =
                bit.bxor(
                    rrotate(y, 17),
                    rrotate(y, 19),
                    bit.rshift(y, 10)
                )

            W[i] =
                (W[i - 16] + s0 + W[i - 7] + s1) % 4294967296
        end

        local a = H[1]
        local b = H[2]
        local c = H[3]
        local d = H[4]
        local e = H[5]
        local f = H[6]
        local g = H[7]
        local h = H[8]

        for i = 1, 64 do
            local S1 =
                bit.bxor(
                    rrotate(e, 6),
                    rrotate(e, 11),
                    rrotate(e, 25)
                )

            local ch =
                bit.bxor(
                    bit.band(e, f),
                    bit.band(bit.bnot(e), g)
                )

            local temp1 =
                (h + S1 + ch + K[i] + W[i]) % 4294967296

            local S0 =
                bit.bxor(
                    rrotate(a, 2),
                    rrotate(a, 13),
                    rrotate(a, 22)
                )

            local maj =
                bit.bxor(
                    bit.band(a, b),
                    bit.band(a, c),
                    bit.band(b, c)
                )

            local temp2 =
                (S0 + maj) % 4294967296

            h = g
            g = f
            f = e
            e = (d + temp1) % 4294967296
            d = c
            c = b
            b = a
            a = (temp1 + temp2) % 4294967296
        end

        H[1] = (H[1] + a) % 4294967296
        H[2] = (H[2] + b) % 4294967296
        H[3] = (H[3] + c) % 4294967296
        H[4] = (H[4] + d) % 4294967296
        H[5] = (H[5] + e) % 4294967296
        H[6] = (H[6] + f) % 4294967296
        H[7] = (H[7] + g) % 4294967296
        H[8] = (H[8] + h) % 4294967296
    end

    local result = ""

    for i = 1, 8 do
        result = result .. string.format("%08x", H[i])
    end

    return result
end

----------------------------------------------------------------
-- HTTP
----------------------------------------------------------------

local function safeRequest(options)
    local req = getRequestFunction()

    if not req then
        return nil, "HTTP requests are not supported by this executor."
    end

    local ok, response = pcall(function()
        return req(options)
    end)

    if not ok then
        return nil, "Connection Error: " .. tostring(response)
    end

    if type(response) ~= "table" then
        return nil, "Invalid HTTP response."
    end

    return response
end

----------------------------------------------------------------
-- JSON
----------------------------------------------------------------

local function jsonEncode(data)
    local ok, result = pcall(function()
        return HttpService:JSONEncode(data)
    end)

    if not ok then
        return nil, "JSON encode failed."
    end

    return result
end

local function jsonDecode(data)
    if type(data) ~= "string" or data == "" then
        return nil, "Empty server response."
    end

    local ok, result = pcall(function()
        return HttpService:JSONDecode(data)
    end)

    if not ok or type(result) ~= "table" then
        return nil, "Invalid server response."
    end

    return result
end

----------------------------------------------------------------
-- VARIABLES
----------------------------------------------------------------

local useNonce = true

local cachedLink = ""
local cachedTime = 0

local host = "https://api.platoboost.com"

-- IMPORTANT FIX:
-- This prevents multiple verification requests from running
-- at the same time.
local isVerifying = false

----------------------------------------------------------------
-- CONNECTIVITY
----------------------------------------------------------------

local function checkConnectivity()
    local response = safeRequest({
        Url = host .. "/public/connectivity",
        Method = "GET"
    })

    if response
        and (response.StatusCode == 200 or response.StatusCode == 429) then
        return true
    end

    host = "https://api.platoboost.net"

    local fallbackResponse = safeRequest({
        Url = host .. "/public/connectivity",
        Method = "GET"
    })

    if fallbackResponse
        and (
            fallbackResponse.StatusCode == 200
            or fallbackResponse.StatusCode == 429
        ) then
        return true
    end

    return false
end

----------------------------------------------------------------
-- NONCE
----------------------------------------------------------------

local function generateNonce()
    local chars = {}

    for i = 1, 16 do
        chars[i] = string.char(math.random(97, 122))
    end

    return table.concat(chars)
end

----------------------------------------------------------------
-- GET KEY LINK
----------------------------------------------------------------

local function cacheLink()
    if not checkConnectivity() then
        return false, "Network Error! Try another executor or connection."
    end

    if cachedTime + (10 * 60) > os.time()
        and cachedLink ~= "" then

        return true, cachedLink
    end

    local body = jsonEncode({
        service = Config.ServiceId,
        identifier = sha256(fGetHwid())
    })

    if not body then
        return false, "Could not create request."
    end

    local response, err = safeRequest({
        Url = host .. "/public/start",
        Method = "POST",
        Body = body,
        Headers = {
            ["Content-Type"] = "application/json"
        }
    })

    if not response then
        return false, err or "Server unreachable."
    end

    if response.StatusCode ~= 200 then
        return false,
            "Server Error: HTTP " .. tostring(response.StatusCode)
    end

    local decoded, decodeError = jsonDecode(response.Body)

    if not decoded then
        return false, decodeError
    end

    if decoded.success
        and decoded.data
        and decoded.data.url then

        cachedLink = tostring(decoded.data.url)
        cachedTime = os.time()

        return true, cachedLink
    end

    return false,
        tostring(decoded.message or "Could not get key link.")
end

----------------------------------------------------------------
-- VERIFY / REDEEM KEY
----------------------------------------------------------------

local function redeemKey(key)
    if isVerifying then
        return false, "Please wait for the current verification."
    end

    key = tostring(key or "")

    -- Remove accidental spaces before/after the key.
    key = key:gsub("^%s+", "")
    key = key:gsub("%s+$", "")

    if key == "" then
        return false, "Enter a key!"
    end

    isVerifying = true

    local finalSuccess = false
    local finalMessage = "Unknown verification error."

    local ok, errorMessage = pcall(function()

        if not checkConnectivity() then
            finalMessage =
                "Network Error! Try another executor or connection."
            return
        end

        local nonce = generateNonce()

        local requestBody = {
            identifier = sha256(fGetHwid()),
            key = key
        }

        if useNonce then
            requestBody.nonce = nonce
        end

        local encodedBody, encodeError = jsonEncode(requestBody)

        if not encodedBody then
            finalMessage = encodeError or "Request encoding failed."
            return
        end

        local response, requestError = safeRequest({
            Url =
                host
                .. "/public/redeem/"
                .. tostring(Config.ServiceId),

            Method = "POST",

            Body = encodedBody,

            Headers = {
                ["Content-Type"] = "application/json"
            }
        })

        if not response then
            finalMessage = requestError or "Server Error."
            return
        end

        if response.StatusCode ~= 200 then
            finalMessage =
                "Server Error: HTTP "
                .. tostring(response.StatusCode)
            return
        end

        local decoded, decodeError =
            jsonDecode(response.Body)

        if not decoded then
            finalMessage = decodeError or "Invalid server response."
            return
        end

        if decoded.success ~= true then
            finalMessage =
                tostring(decoded.message or "Invalid Key.")
            return
        end

        if type(decoded.data) ~= "table" then
            finalMessage = "Invalid verification data."
            return
        end

        if decoded.data.valid ~= true then
            finalMessage =
                tostring(decoded.message or "Invalid Key.")
            return
        end

        --------------------------------------------------------
        -- NONCE INTEGRITY CHECK
        --------------------------------------------------------

        if useNonce then

            if not decoded.data.hash then
                finalMessage =
                    "Integrity response missing."
                return
            end

            local expectedHash =
                sha256(
                    "true"
                    .. "-"
                    .. nonce
                    .. "-"
                    .. Config.PlatoSecret
                )

            if tostring(decoded.data.hash)
                ~= tostring(expectedHash) then

                finalMessage = "Integrity Check Failed."
                return
            end
        end

        --------------------------------------------------------
        -- SAVE KEY
        --------------------------------------------------------

        if writefile then
            pcall(function()
                writefile(
                    Config.KeyFileName,
                    key
                )
            end)
        end

        finalSuccess = true
        finalMessage = "Success!"

    end)

    ------------------------------------------------------------
    -- IMPORTANT:
    -- Always unlock verification even if an unexpected error
    -- occurs.
    ------------------------------------------------------------

    isVerifying = false

    if not ok then
        return false,
            "Verification Error: "
            .. tostring(errorMessage)
    end

    return finalSuccess, finalMessage
end

----------------------------------------------------------------
-- START MAIN SCRIPT
----------------------------------------------------------------

local function StartMainScript()
    local player = Players.LocalPlayer
    local pGui = player:WaitForChild("PlayerGui")

    local oldGui = pGui:FindFirstChild(Config.OldGuiName)

    if oldGui then
        oldGui:Destroy()
        task.wait(0.1)
    end

    _G[Config.Secret] = true

    local ok, err = pcall(function()
        loadstring(
            game:HttpGet(Config.MainScriptURL)
        )()
    end)

    if not ok then
        warn(
            "Failed to load main script: "
            .. tostring(err)
        )
    end
end

----------------------------------------------------------------
-- GUI
----------------------------------------------------------------

local function CreateGUI()

    local player = Players.LocalPlayer

    local targetParent

    local coreSuccess = pcall(function()
        return CoreGui
    end)

    if coreSuccess then
        targetParent = CoreGui
    else
        targetParent =
            player:WaitForChild("PlayerGui")
    end

    ------------------------------------------------------------
    -- Remove old key UI
    ------------------------------------------------------------

    local oldKeyGui =
        targetParent:FindFirstChild("OYB_KeySystem")

    if oldKeyGui then
        oldKeyGui:Destroy()
    end

    ------------------------------------------------------------
    -- SCREEN GUI
    ------------------------------------------------------------

    local ScreenGui =
        Instance.new("ScreenGui")

    ScreenGui.Name = "OYB_KeySystem"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = targetParent

    ------------------------------------------------------------
    -- MAIN FRAME
    ------------------------------------------------------------

    local MainFrame =
        Instance.new("Frame")

    MainFrame.Name = "MainFrame"
    MainFrame.Size =
        UDim2.new(0, 340, 0, 420)

    MainFrame.Position =
        UDim2.new(0.5, -170, 0.5, -210)

    MainFrame.BackgroundColor3 =
        Color3.fromRGB(15, 15, 15)

    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local mainCorner =
        Instance.new("UICorner")

    mainCorner.CornerRadius =
        UDim.new(0, 15)

    mainCorner.Parent = MainFrame

    local mainStroke =
        Instance.new("UIStroke")

    mainStroke.Thickness = 2
    mainStroke.Color =
        Color3.fromRGB(0, 120, 255)

    mainStroke.Parent = MainFrame

    ------------------------------------------------------------
    -- CLOSE BUTTON
    ------------------------------------------------------------

    local CloseBtn =
        Instance.new("TextButton")

    CloseBtn.Size =
        UDim2.new(0, 30, 0, 30)

    CloseBtn.Position =
        UDim2.new(1, -35, 0, 10)

    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 =
        Color3.fromRGB(255, 50, 50)

    CloseBtn.Font =
        Enum.Font.GothamBold

    CloseBtn.TextSize = 18
    CloseBtn.ZIndex = 10
    CloseBtn.Parent = MainFrame

    CloseBtn.MouseButton1Click:Connect(function()
        if ScreenGui then
            ScreenGui:Destroy()
        end
    end)

    ------------------------------------------------------------
    -- TITLE
    ------------------------------------------------------------

    local Title =
        Instance.new("TextLabel")

    Title.Size =
        UDim2.new(1, 0, 0, 50)

    Title.Text = Config.HubName

    Title.BackgroundColor3 =
        Color3.fromRGB(20, 20, 30)

    Title.TextColor3 =
        Color3.fromRGB(0, 170, 255)

    Title.Font =
        Enum.Font.GothamBold

    Title.TextSize = 16
    Title.Parent = MainFrame

    local titleCorner =
        Instance.new("UICorner")

    titleCorner.CornerRadius =
        UDim.new(0, 15)

    titleCorner.Parent = Title

    ------------------------------------------------------------
    -- DESCRIPTION
    ------------------------------------------------------------

    local PromoText =
        Instance.new("TextLabel")

    PromoText.Size =
        UDim2.new(0.9, 0, 0, 50)

    PromoText.Position =
        UDim2.new(0.05, 0, 0, 50)

    PromoText.BackgroundTransparency = 1
    PromoText.Text = Config.HubDescription

    PromoText.TextColor3 =
        Color3.fromRGB(0, 170, 255)

    PromoText.Font =
        Enum.Font.GothamBold

    PromoText.TextSize = 14
    PromoText.TextWrapped = true
    PromoText.Parent = MainFrame

    ------------------------------------------------------------
    -- RAINBOW STROKE
    ------------------------------------------------------------

    local function AddRainbowStroke(parent)

        local stroke =
            Instance.new("UIStroke")

        stroke.Thickness = 2
        stroke.ApplyStrokeMode =
            Enum.ApplyStrokeMode.Border

        stroke.Parent = parent

        task.spawn(function()

            while stroke
                and stroke.Parent do

                local hue =
                    (tick() % 5) / 5

                stroke.Color =
                    Color3.fromHSV(
                        hue,
                        1,
                        1
                    )

                task.wait(0.05)
            end

        end)

        return stroke
    end

    ------------------------------------------------------------
    -- SOCIAL BUTTONS
    ------------------------------------------------------------

    local currentYOffset = 105

    if Config.ShowDiscord then

        local DiscordBtn =
            Instance.new("TextButton")

        DiscordBtn.Size =
            UDim2.new(0.85, 0, 0, 35)

        DiscordBtn.Position =
            UDim2.new(
                0.075,
                0,
                0,
                currentYOffset
            )

        DiscordBtn.Text =
            "      JOIN DISCORD"

        DiscordBtn.Font =
            Enum.Font.GothamBold

        DiscordBtn.TextSize = 14

        DiscordBtn.BackgroundColor3 =
            Color3.fromRGB(88, 101, 242)

        DiscordBtn.TextColor3 =
            Color3.new(1, 1, 1)

        DiscordBtn.Parent = MainFrame

        Instance.new(
            "UICorner",
            DiscordBtn
        )

        AddRainbowStroke(DiscordBtn)

        DiscordBtn.MouseButton1Click:Connect(function()

            pcall(function()
                fSetClipboard(
                    Config.DiscordURL
                )
            end)

            Status.Text =
                "Discord Link Copied!"

            Status.TextColor3 =
                Color3.fromRGB(
                    88,
                    101,
                    242
                )
        end)

        currentYOffset += 45
    end

    if Config.ShowInstagram then

        local InstaBtn =
            Instance.new("TextButton")

        InstaBtn.Size =
            UDim2.new(0.85, 0, 0, 35)

        InstaBtn.Position =
            UDim2.new(
                0.075,
                0,
                0,
                currentYOffset
            )

        InstaBtn.Text =
            "      FOLLOW INSTAGRAM"

        InstaBtn.Font =
            Enum.Font.GothamBold

        InstaBtn.TextSize = 14

        InstaBtn.BackgroundColor3 =
            Color3.fromRGB(
                225,
                48,
                108
            )

        InstaBtn.TextColor3 =
            Color3.new(1, 1, 1)

        InstaBtn.Parent = MainFrame

        Instance.new(
            "UICorner",
            InstaBtn
        )

        AddRainbowStroke(InstaBtn)

        InstaBtn.MouseButton1Click:Connect(function()

            pcall(function()
                fSetClipboard(
                    Config.InstagramURL
                )
            end)

            Status.Text =
                "Instagram Link Copied!"

            Status.TextColor3 =
                Color3.fromRGB(
                    225,
                    48,
                    108
                )
        end)

        currentYOffset += 45
    end

    if Config.ShowYoutube then

        local YTBtn =
            Instance.new("TextButton")

        YTBtn.Size =
            UDim2.new(0.85, 0, 0, 35)

        YTBtn.Position =
            UDim2.new(
                0.075,
                0,
                0,
                currentYOffset
            )

        YTBtn.Text =
            "      SUBSCRIBE YOUTUBE"

        YTBtn.Font =
            Enum.Font.GothamBold

        YTBtn.TextSize = 14

        YTBtn.BackgroundColor3 =
            Color3.fromRGB(
                255,
                0,
                0
            )

        YTBtn.TextColor3 =
            Color3.new(1, 1, 1)

        YTBtn.Parent = MainFrame

        Instance.new(
            "UICorner",
            YTBtn
        )

        AddRainbowStroke(YTBtn)

        YTBtn.MouseButton1Click:Connect(function()

            pcall(function()
                fSetClipboard(
                    Config.YoutubeURL
                )
            end)

            Status.Text =
                "YouTube Link Copied!"

            Status.TextColor3 =
                Color3.fromRGB(
                    255,
                    0,
                    0
                )
        end)

        currentYOffset += 45
    end

    ------------------------------------------------------------
    -- KEY INPUT
    ------------------------------------------------------------

    local KeyInput =
        Instance.new("TextBox")

    KeyInput.Size =
        UDim2.new(
            0.85,
            0,
            0,
            40
        )

    KeyInput.Position =
        UDim2.new(
            0.075,
            0,
            0,
            currentYOffset + 15
        )

    KeyInput.PlaceholderText =
        "Enter Key..."

    KeyInput.Text = ""

    KeyInput.ClearTextOnFocus = false

    KeyInput.Font =
        Enum.Font.GothamSemibold

    KeyInput.TextSize = 14

    KeyInput.BackgroundColor3 =
        Color3.fromRGB(
            25,
            25,
            30
        )

    KeyInput.TextColor3 =
        Color3.new(1, 1, 1)

    KeyInput.Parent = MainFrame

    Instance.new(
        "UICorner",
        KeyInput
    )

    local inputStroke =
        Instance.new("UIStroke")

    inputStroke.Thickness = 1
    inputStroke.Color =
        Color3.fromRGB(
            40,
            100,
            180
        )

    inputStroke.Parent = KeyInput

    ------------------------------------------------------------
    -- VERIFY BUTTON
    ------------------------------------------------------------

    local VerifyBtn =
        Instance.new("TextButton")

    VerifyBtn.Size =
        UDim2.new(
            0.4,
            0,
            0,
            40
        )

    VerifyBtn.Position =
        UDim2.new(
            0.075,
            0,
            0,
            currentYOffset + 65
        )

    VerifyBtn.Text = "VERIFY"

    VerifyBtn.Font =
        Enum.Font.GothamBold

    VerifyBtn.TextSize = 14

    VerifyBtn.BackgroundColor3 =
        Color3.fromRGB(
            0,
            120,
            255
        )

    VerifyBtn.TextColor3 =
        Color3.new(1, 1, 1)

    VerifyBtn.Parent = MainFrame

    Instance.new(
        "UICorner",
        VerifyBtn
    )

    ------------------------------------------------------------
    -- GET KEY BUTTON
    ------------------------------------------------------------

    local GetKeyBtn =
        Instance.new("TextButton")

    GetKeyBtn.Size =
        UDim2.new(
            0.4,
            0,
            0,
            40
        )

    GetKeyBtn.Position =
        UDim2.new(
            0.525,
            0,
            0,
            currentYOffset + 65
        )

    GetKeyBtn.Text = "GET KEY"

    GetKeyBtn.Font =
        Enum.Font.GothamBold

    GetKeyBtn.TextSize = 14

    GetKeyBtn.BackgroundColor3 =
        Color3.fromRGB(
            35,
            35,
            40
        )

    GetKeyBtn.TextColor3 =
        Color3.new(1, 1, 1)

    GetKeyBtn.Parent = MainFrame

    Instance.new(
        "UICorner",
        GetKeyBtn
    )

    ------------------------------------------------------------
    -- STATUS
    ------------------------------------------------------------

    local Status =
        Instance.new("TextLabel")

    Status.Name = "StatusLabel"

    Status.Size =
        UDim2.new(
            1,
            0,
            0,
            30
        )

    Status.Position =
        UDim2.new(
            0,
            0,
            0,
            currentYOffset + 115
        )

    Status.BackgroundTransparency = 1

    Status.Text =
        "Waiting for input..."

    Status.TextColor3 =
        Color3.fromRGB(
            150,
            150,
            150
        )

    Status.Font =
        Enum.Font.Gotham

    Status.TextSize = 12

    Status.TextWrapped = true

    Status.Parent = MainFrame

    ------------------------------------------------------------
    -- FINAL SIZE
    ------------------------------------------------------------

    MainFrame.Size =
        UDim2.new(
            0,
            340,
            0,
            currentYOffset + 160
        )

    ------------------------------------------------------------
    -- VERIFY
    ------------------------------------------------------------

    VerifyBtn.MouseButton1Click:Connect(function()

        --------------------------------------------------------
        -- FIX:
        -- Don't allow another request while one is running.
        --------------------------------------------------------

        if isVerifying then
            Status.Text =
                "Please wait, still verifying..."

            Status.TextColor3 =
                Color3.fromRGB(
                    255,
                    180,
                    50
                )

            return
        end

        local key =
            tostring(KeyInput.Text or "")

        key = key:gsub("^%s+", "")
        key = key:gsub("%s+$", "")

        if key == "" then

            Status.Text =
                "Enter a key!"

            Status.TextColor3 =
                Color3.fromRGB(
                    255,
                    80,
                    80
                )

            return
        end

        --------------------------------------------------------
        -- LOCK BUTTON
        --------------------------------------------------------

        VerifyBtn.Active = false
        VerifyBtn.AutoButtonColor = false
        GetKeyBtn.Active = false
        GetKeyBtn.AutoButtonColor = false

        VerifyBtn.Text =
            "VERIFYING..."

        Status.Text =
            "Verifying key..."

        Status.TextColor3 =
            Color3.fromRGB(
                0,
                170,
                255
            )

        task.spawn(function()

            local success, msg =
                redeemKey(key)

            ----------------------------------------------------
            -- SUCCESS
            ----------------------------------------------------

            if success then

                Status.Text =
                    "Success! Loading..."

                Status.TextColor3 =
                    Color3.fromRGB(
                        0,
                        255,
                        100
                    )

                task.wait(0.5)

                if ScreenGui
                    and ScreenGui.Parent then

                    ScreenGui:Destroy()
                end

                StartMainScript()

                return
            end

            ----------------------------------------------------
            -- FAILED KEY
            --
            -- IMPORTANT:
            -- Everything gets unlocked here, so the user can
            -- enter another key.
            ----------------------------------------------------

            Status.Text =
                tostring(
                    msg or "Invalid Key"
                )

            Status.TextColor3 =
                Color3.fromRGB(
                    255,
                    60,
                    60
                )

            VerifyBtn.Active = true
            VerifyBtn.AutoButtonColor = true
            VerifyBtn.Text = "VERIFY"

            GetKeyBtn.Active = true
            GetKeyBtn.AutoButtonColor = true

        end)
    end)

    ------------------------------------------------------------
    -- GET KEY
    ------------------------------------------------------------

    GetKeyBtn.MouseButton1Click:Connect(function()

        if isVerifying then
            Status.Text =
                "Please wait for verification."

            return
        end

        GetKeyBtn.Active = false
        GetKeyBtn.AutoButtonColor = false

        Status.Text =
            "Getting Link..."

        Status.TextColor3 =
            Color3.fromRGB(
                0,
                170,
                255
            )

        task.spawn(function()

            local success, link =
                cacheLink()

            if success
                and link
                and link ~= "" then

                pcall(function()
                    fSetClipboard(link)
                end)

                Status.Text =
                    "Link Copied!"

                Status.TextColor3 =
                    Color3.fromRGB(
                        0,
                        220,
                        255
                    )

            else

                Status.Text =
                    tostring(
                        link
                        or "Unable to get link."
                    )

                Status.TextColor3 =
                    Color3.fromRGB(
                        255,
                        100,
                        100
                    )
            end

            GetKeyBtn.Active = true
            GetKeyBtn.AutoButtonColor = true

        end)
    end)

    ------------------------------------------------------------
    -- AUTO LOGIN
    ------------------------------------------------------------

    if isfile
        and isfile(Config.KeyFileName) then

        local readOK, savedKey =
            pcall(function()
                return readfile(
                    Config.KeyFileName
                )
            end)

        if readOK
            and savedKey then

            savedKey =
                tostring(savedKey)

            savedKey =
                savedKey:gsub(
                    "^%s+",
                    ""
                )

            savedKey =
                savedKey:gsub(
                    "%s+$",
                    ""
                )

            if savedKey ~= "" then

                Status.Text =
                    "Found saved key, verifying..."

                Status.TextColor3 =
                    Color3.fromRGB(
                        0,
                        170,
                        255
                    )

                VerifyBtn.Active = false
                GetKeyBtn.Active = false

                task.spawn(function()

                    local success, msg =
                        redeemKey(savedKey)

                    if success then

                        Status.Text =
                            "Auto-login success!"

                        Status.TextColor3 =
                            Color3.fromRGB(
                                0,
                                255,
                                100
                            )

                        task.wait(0.5)

                        if ScreenGui
                            and ScreenGui.Parent then

                            ScreenGui:Destroy()
                        end

                        StartMainScript()

                    else

                        Status.Text =
                            "Saved key expired or invalid."

                        Status.TextColor3 =
                            Color3.fromRGB(
                                255,
                                150,
                                0
                            )

                        ------------------------------------------------
                        -- IMPORTANT:
                        -- Unlock manual verification after auto-login
                        -- fails.
                        ------------------------------------------------

                        VerifyBtn.Active = true
                        VerifyBtn.AutoButtonColor = true
                        VerifyBtn.Text = "VERIFY"

                        GetKeyBtn.Active = true
                        GetKeyBtn.AutoButtonColor = true

                    end

                end)
            end
        end
    end
end

----------------------------------------------------------------
-- START
----------------------------------------------------------------

local playerGui =
    Player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild(
    Config.MainGuiName
) then

    StartMainScript()
    return
end

CreateGUI()
