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
    -- [1] Platoboost
    ServiceId = 30834,

    -- IMPORTANT:
    -- Replace this with your NEW rotated Platoboost secret.
    PlatoSecret = "37b9d1d0-5c79-4d26-bc60-42f94917d279",

    -- [2] Main script gate
    Secret = "zolopogi123",

    -- [3] Main script
    MainScriptURL =
        "https://raw.githubusercontent.com/Zolorblx/Keysystem/refs/heads/main/ZoloScript.lua",

    -- [4] Social
    ShowDiscord = false,
    DiscordURL = "https://discord.gg/kT55J724BK",

    ShowInstagram = false,
    InstagramURL = "https://www.instagram.com/oyb0i/",

    ShowYoutube = false,
    YoutubeURL =
        "https://www.youtube.com/channel/UCAlXXV1Hbvf7WbfXARuVtiQ",

    -- [5] Key storage
    KeyFileName = "Mykey.txt",

    -- [6] GUI
    OldGuiName = "KARINDERYA",
    MainGuiName = "KARINDERYA",

    -- [7] Hub
    HubName = "ZOLO",
    HubDescription = "5$ for lifetime?"
}

----------------------------------------------------------------
-- SHA256
----------------------------------------------------------------

local UINT32 = 2 ^ 32
local UINT32_MAX = UINT32 - 1

local function bxor(a, b)
    local result = 0
    local bit = 1

    while a ~= 0 or b ~= 0 do
        local abit = a % 2
        local bbit = b % 2

        if abit ~= bbit then
            result = result + bit
        end

        a = math.floor(a / 2)
        b = math.floor(b / 2)
        bit = bit * 2
    end

    return result % UINT32
end

local function band(a, b, c, ...)
    if b == nil then
        return a % UINT32
    end

    local result = 0
    local bit = 1

    while a ~= 0 or b ~= 0 do
        local abit = a % 2
        local bbit = b % 2

        if abit == 1 and bbit == 1 then
            result = result + bit
        end

        a = math.floor(a / 2)
        b = math.floor(b / 2)
        bit = bit * 2
    end

    result = result % UINT32

    local args = {...}

    for i = 1, #args do
        result = band(result, args[i])
    end

    return result
end

local function bor(a, b, c, ...)
    if b == nil then
        return a % UINT32
    end

    local result = 0
    local bit = 1

    while a ~= 0 or b ~= 0 do
        local abit = a % 2
        local bbit = b % 2

        if abit == 1 or bbit == 1 then
            result = result + bit
        end

        a = math.floor(a / 2)
        b = math.floor(b / 2)
        bit = bit * 2
    end

    result = result % UINT32

    local args = {...}

    for i = 1, #args do
        result = bor(result, args[i])
    end

    return result
end

local function bnot(x)
    return UINT32_MAX - x
end

local function rshift(x, n)
    if n < 0 then
        return lshift(x, -n)
    end

    return math.floor((x % UINT32) / (2 ^ n))
end

local function lshift(x, n)
    if n < 0 then
        return rshift(x, -n)
    end

    return (x * (2 ^ n)) % UINT32
end

local function rrotate(x, n)
    n = n % 32

    local right = rshift(x, n)
    local left = lshift(x, 32 - n)

    return (right + left) % UINT32
end

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
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
    0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
    0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
    0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
}

local function toHex(str)
    return string.gsub(str, ".", function(char)
        return string.format("%02x", string.byte(char))
    end)
end

local function intToBytes(num, count)
    local result = ""

    for _ = 1, count do
        local byte = num % 256
        result = string.char(byte) .. result
        num = (num - byte) / 256
    end

    return result
end

local function readUint32(str, index)
    local result = 0

    for i = index, index + 3 do
        result = result * 256 + string.byte(str, i)
    end

    return result
end

local function padMessage(message)
    local bitLength = #message * 8
    local padding = 64 - ((#message + 9) % 64)

    return message
        .. "\128"
        .. string.rep("\0", padding)
        .. intToBytes(bitLength, 8)
end

local function shaInit()
    return {
        0x6a09e667,
        0xbb67ae85,
        0x3c6ef372,
        0xa54ff53a,
        0x510e527f,
        0x9b05688c,
        0x1f83d9ab,
        0x5be0cd19
    }
end

local function shaProcess(chunk, hash)
    local words = {}

    for i = 1, 16 do
        words[i] = readUint32(
            chunk,
            (i - 1) * 4 + 1
        )
    end

    for i = 17, 64 do
        local s0 =
            bxor(
                rrotate(words[i - 15], 7),
                rrotate(words[i - 15], 18),
                rshift(words[i - 15], 3)
            )

        local s1 =
            bxor(
                rrotate(words[i - 2], 17),
                rrotate(words[i - 2], 19),
                rshift(words[i - 2], 10)
            )

        words[i] =
            (
                words[i - 16]
                + s0
                + words[i - 7]
                + s1
            ) % UINT32
    end

    local a = hash[1]
    local b = hash[2]
    local c = hash[3]
    local d = hash[4]
    local e = hash[5]
    local f = hash[6]
    local g = hash[7]
    local h = hash[8]

    for i = 1, 64 do
        local S1 =
            bxor(
                rrotate(e, 6),
                rrotate(e, 11),
                rrotate(e, 25)
            )

        local ch =
            bxor(
                band(e, f),
                band(bnot(e), g)
            )

        local temp1 =
            (
                h
                + S1
                + ch
                + K[i]
                + words[i]
            ) % UINT32

        local S0 =
            bxor(
                rrotate(a, 2),
                rrotate(a, 13),
                rrotate(a, 22)
            )

        local maj =
            bxor(
                band(a, b),
                band(a, c),
                band(b, c)
            )

        local temp2 =
            (S0 + maj) % UINT32

        h = g
        g = f
        f = e
        e = (d + temp1) % UINT32
        d = c
        c = b
        b = a
        a = (temp1 + temp2) % UINT32
    end

    hash[1] = (hash[1] + a) % UINT32
    hash[2] = (hash[2] + b) % UINT32
    hash[3] = (hash[3] + c) % UINT32
    hash[4] = (hash[4] + d) % UINT32
    hash[5] = (hash[5] + e) % UINT32
    hash[6] = (hash[6] + f) % UINT32
    hash[7] = (hash[7] + g) % UINT32
    hash[8] = (hash[8] + h) % UINT32
end

local function sha256(message)
    local padded = padMessage(message)
    local hash = shaInit()

    for index = 1, #padded, 64 do
        shaProcess(
            padded:sub(index, index + 63),
            hash
        )
    end

    local output = ""

    for i = 1, 8 do
        output =
            output
            .. intToBytes(hash[i], 4)
    end

    return toHex(output)
end

local lDigest = sha256

----------------------------------------------------------------
-- JSON
----------------------------------------------------------------

local HttpService =
    game:GetService("HttpService")

local function jsonEncode(value)
    return HttpService:JSONEncode(value)
end

local function jsonDecode(value)
    return HttpService:JSONDecode(value)
end

local lEncode = jsonEncode
local lDecode = jsonDecode

----------------------------------------------------------------
-- HTTP
----------------------------------------------------------------

local function safeRequest(options)
    local req =
        request
        or http_request
        or syn_request
        or (http and http.request)

    if not req then
        return nil,
            "HTTP requests are not supported."
    end

    local success, response =
        pcall(function()
            return req(options)
        end)

    if success
        and type(response) == "table"
    then
        return response
    end

    return nil,
        "Connection Error: "
        .. tostring(
            response or "Unknown"
        )
end

----------------------------------------------------------------
-- HELPERS
----------------------------------------------------------------

local fSetClipboard =
    setclipboard
    or toclipboard
    or function() end

local fGetHwid =
    gethwid
    or function()
        return game:GetService(
            "RbxAnalyticsService"
        ):GetClientId()
    end

local cachedLink = ""
local cachedTime = 0

local host =
    "https://api.platoboost.com"

local useNonce = true

----------------------------------------------------------------
-- CONNECTIVITY
----------------------------------------------------------------

local function checkConnectivity()
    local response =
        safeRequest({
            Url =
                host
                .. "/public/connectivity",

            Method = "GET"
        })

    if response
        and (
            response.StatusCode == 200
            or response.StatusCode == 429
        )
    then
        return true
    end

    host =
        "https://api.platoboost.net"

    local fallback =
        safeRequest({
            Url =
                host
                .. "/public/connectivity",

            Method = "GET"
        })

    return fallback ~= nil
end

----------------------------------------------------------------
-- NONCE
----------------------------------------------------------------

local function generateNonce()
    local chars = ""

    for _ = 1, 16 do
        chars =
            chars
            .. string.char(
                math.random(97, 122)
            )
    end

    return chars
end

----------------------------------------------------------------
-- GET LINK
--
-- Equivalent to the C#:
-- await boost.GetLink()
----------------------------------------------------------------

local function GetLink()
    if not checkConnectivity() then
        return false,
            "Platoboost connection failed."
    end

    if cachedLink ~= ""
        and cachedTime + 600 > os.time()
    then
        return true, cachedLink
    end

    local response, err =
        safeRequest({
            Url =
                host
                .. "/public/start",

            Method = "POST",

            Body =
                lEncode({
                    service =
                        Config.ServiceId,

                    identifier =
                        lDigest(
                            fGetHwid()
                        )
                }),

            Headers = {
                ["Content-Type"] =
                    "application/json"
            }
        })

    if not response then
        return false,
            err or "Request failed."
    end

    if response.StatusCode ~= 200 then
        return false,
            "Platoboost HTTP "
            .. tostring(
                response.StatusCode
            )
    end

    local ok, decoded =
        pcall(
            lDecode,
            response.Body
        )

    if not ok
        or type(decoded) ~= "table"
    then
        return false,
            "Invalid Platoboost response."
    end

    if not decoded.success then
        return false,
            decoded.message
            or "Unable to create key link."
    end

    if not decoded.data
        or not decoded.data.url
    then
        return false,
            "Platoboost did not return a link."
    end

    cachedLink =
        decoded.data.url

    cachedTime = os.time()

    return true, cachedLink
end

----------------------------------------------------------------
-- VERIFY
--
-- Equivalent to the C#:
-- await boost.Verify(key)
----------------------------------------------------------------

local function Verify(key)
    if type(key) ~= "string"
        or key:gsub("%s+", "") == ""
    then
        return false,
            "Enter a key."
    end

    if not checkConnectivity() then
        return false,
            "Platoboost connection failed."
    end

    local nonce =
        generateNonce()

    local body = {
        identifier =
            lDigest(
                fGetHwid()
            ),

        key = key
    }

    if useNonce then
        body.nonce = nonce
    end

    local response, err =
        safeRequest({
            Url =
                host
                .. "/public/redeem/"
                .. tostring(
                    Config.ServiceId
                ),

            Method = "POST",

            Body =
                lEncode(body),

            Headers = {
                ["Content-Type"] =
                    "application/json"
            }
        })

    if not response then
        return false,
            err
            or "Verification request failed."
    end

    if response.StatusCode ~= 200 then
        return false,
            "Platoboost HTTP "
            .. tostring(
                response.StatusCode
            )
    end

    local ok, decoded =
        pcall(
            lDecode,
            response.Body
        )

    if not ok
        or type(decoded) ~= "table"
    then
        return false,
            "Invalid Platoboost response."
    end

    if not decoded.success then
        return false,
            decoded.message
            or "Invalid key."
    end

    if not decoded.data
        or decoded.data.valid ~= true
    then
        return false,
            decoded.message
            or "Invalid key."
    end

    ------------------------------------------------------------
    -- NONCE INTEGRITY CHECK
    ------------------------------------------------------------

    if useNonce then
        if not decoded.data.hash then
            return false,
                "Missing verification hash."
        end

        local expectedHash =
            lDigest(
                "true"
                .. "-"
                .. nonce
                .. "-"
                .. Config.PlatoSecret
            )

        if decoded.data.hash
            ~= expectedHash
        then
            return false,
                "Integrity Check Failed."
        end
    end

    ------------------------------------------------------------
    -- SAVE VERIFIED KEY
    ------------------------------------------------------------

    if writefile then
        pcall(function()
            writefile(
                Config.KeyFileName,
                key
            )
        end)
    end

    return true,
        "Key valid."
end

----------------------------------------------------------------
-- MAIN SCRIPT
----------------------------------------------------------------

local function StartMainScript()
    local player =
        game:GetService(
            "Players"
        ).LocalPlayer

    local pGui =
        player:WaitForChild(
            "PlayerGui"
        )

    ------------------------------------------------------------
    -- Remove old GUI
    ------------------------------------------------------------

    local oldGui =
        pGui:FindFirstChild(
            Config.OldGuiName
        )

    if oldGui then
        oldGui:Destroy()
        task.wait(0.1)
    end

    ------------------------------------------------------------
    -- Authentication flag
    ------------------------------------------------------------

    _G[Config.Secret] = true

    ------------------------------------------------------------
    -- Load main script
    ------------------------------------------------------------

    local success, result =
        pcall(function()
            local source =
                game:HttpGet(
                    Config.MainScriptURL
                )

            local fn =
                loadstring(source)

            if not fn then
                error(
                    "loadstring failed."
                )
            end

            return fn()
        end)

    if not success then
        warn(
            "[ZOLO] Main script error:",
            result
        )
    end
end

----------------------------------------------------------------
-- GUI
----------------------------------------------------------------

local function CreateGUI()
    local player =
        game:GetService(
            "Players"
        ).LocalPlayer

    local coreGui =
        game:GetService(
            "CoreGui"
        )

    local targetParent =
        coreGui

    ------------------------------------------------------------
    -- Remove duplicate key GUI
    ------------------------------------------------------------

    local existing =
        targetParent:FindFirstChild(
            "OYB_KeySystem"
        )

    if existing then
        existing:Destroy()
    end

    ------------------------------------------------------------
    -- SCREEN GUI
    ------------------------------------------------------------

    local ScreenGui =
        Instance.new(
            "ScreenGui"
        )

    ScreenGui.Name =
        "OYB_KeySystem"

    ScreenGui.ResetOnSpawn =
        false

    ScreenGui.Parent =
        targetParent

    ------------------------------------------------------------
    -- MAIN FRAME
    ------------------------------------------------------------

    local MainFrame =
        Instance.new(
            "Frame"
        )

    MainFrame.Parent =
        ScreenGui

    MainFrame.Size =
        UDim2.new(
            0,
            340,
            0,
            420
        )

    MainFrame.Position =
        UDim2.new(
            0.5,
            -170,
            0.5,
            -210
        )

    MainFrame.BackgroundColor3 =
        Color3.fromRGB(
            15,
            15,
            15
        )

    MainFrame.Active = true
    MainFrame.Draggable = true

    Instance.new(
        "UICorner",
        MainFrame
    ).CornerRadius =
        UDim.new(
            0,
            15
        )

    local mainStroke =
        Instance.new(
            "UIStroke",
            MainFrame
        )

    mainStroke.Thickness = 2

    mainStroke.Color =
        Color3.fromRGB(
            40,
            40,
            40
        )

    ------------------------------------------------------------
    -- CLOSE BUTTON
    ------------------------------------------------------------

    local CloseBtn =
        Instance.new(
            "TextButton",
            MainFrame
        )

    CloseBtn.Size =
        UDim2.new(
            0,
            30,
            0,
            30
        )

    CloseBtn.Position =
        UDim2.new(
            1,
            -35,
            0,
            10
        )

    CloseBtn.BackgroundTransparency =
        1

    CloseBtn.Text = "X"

    CloseBtn.TextColor3 =
        Color3.fromRGB(
            255,
            50,
            50
        )

    CloseBtn.Font =
        Enum.Font.GothamBold

    CloseBtn.TextSize = 18

    CloseBtn.ZIndex = 10

    CloseBtn.MouseButton1Click:Connect(
        function()
            ScreenGui:Destroy()
        end
    )

    ------------------------------------------------------------
    -- TITLE
    ------------------------------------------------------------

    local Title =
        Instance.new(
            "TextLabel",
            MainFrame
        )

    Title.Size =
        UDim2.new(
            1,
            0,
            0,
            50
        )

    Title.Text =
        Config.HubName

    Title.BackgroundColor3 =
        Color3.fromRGB(
            20,
            20,
            20
        )

    Title.TextColor3 =
        Color3.fromRGB(
            0,
            170,
            255
        )

    Title.Font =
        Enum.Font.GothamBold

    Title.TextSize = 16

    Instance.new(
        "UICorner",
        Title
    ).CornerRadius =
        UDim.new(
            0,
            15
        )

    ------------------------------------------------------------
    -- DESCRIPTION
    ------------------------------------------------------------

    local PromoText =
        Instance.new(
            "TextLabel",
            MainFrame
        )

    PromoText.Size =
        UDim2.new(
            0.9,
            0,
            0,
            50
        )

    PromoText.Position =
        UDim2.new(
            0.05,
            0,
            0,
            50
        )

    PromoText.BackgroundTransparency =
        1

    PromoText.Text =
        Config.HubDescription

    PromoText.TextColor3 =
        Color3.fromRGB(
            0,
            170,
            255
        )

    PromoText.Font =
        Enum.Font.GothamBold

    PromoText.TextSize = 14
    PromoText.TextWrapped = true

    ------------------------------------------------------------
    -- RAINBOW STROKE
    ------------------------------------------------------------

    local function AddRainbowStroke(parent)
        local stroke =
            Instance.new(
                "UIStroke",
                parent
            )

        stroke.Thickness = 2

        stroke.ApplyStrokeMode =
            Enum.ApplyStrokeMode.Border

        task.spawn(
            function()
                while stroke.Parent do
                    local hue =
                        tick() % 5 / 5

                    stroke.Color =
                        Color3.fromHSV(
                            hue,
                            1,
                            1
                        )

                    task.wait()
                end
            end
        )
    end

    local currentYOffset =
        105

    ------------------------------------------------------------
    -- STATUS
    ------------------------------------------------------------

    local Status =
        Instance.new(
            "TextLabel",
            MainFrame
        )

    Status.Name =
        "StatusLabel"

    Status.Size =
        UDim2.new(
            1,
            0,
            0,
            30
        )

    Status.BackgroundTransparency =
        1

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

    ------------------------------------------------------------
    -- DISCORD
    ------------------------------------------------------------

    if Config.ShowDiscord then
        local DiscordBtn =
            Instance.new(
                "TextButton",
                MainFrame
            )

        DiscordBtn.Size =
            UDim2.new(
                0.85,
                0,
                0,
                35
            )

        DiscordBtn.Position =
            UDim2.new(
                0.075,
                0,
                0,
                currentYOffset
            )

        DiscordBtn.Text =
            "JOIN DISCORD"

        DiscordBtn.Font =
            Enum.Font.GothamBold

        DiscordBtn.TextSize = 14

        DiscordBtn.BackgroundColor3 =
            Color3.fromRGB(
                88,
                101,
                242
            )

        DiscordBtn.TextColor3 =
            Color3.new(
                1,
                1,
                1
            )

        Instance.new(
            "UICorner",
            DiscordBtn
        )

        AddRainbowStroke(
            DiscordBtn
        )

        DiscordBtn.MouseButton1Click:Connect(
            function()
                fSetClipboard(
                    Config.DiscordURL
                )

                Status.Text =
                    "Discord Link Copied!"

                Status.TextColor3 =
                    Color3.fromRGB(
                        88,
                        101,
                        242
                    )
            end
        )

        currentYOffset =
            currentYOffset + 45
    end

    ------------------------------------------------------------
    -- INSTAGRAM
    ------------------------------------------------------------

    if Config.ShowInstagram then
        local InstaBtn =
            Instance.new(
                "TextButton",
                MainFrame
            )

        InstaBtn.Size =
            UDim2.new(
                0.85,
                0,
                0,
                35
            )

        InstaBtn.Position =
            UDim2.new(
                0.075,
                0,
                0,
                currentYOffset
            )

        InstaBtn.Text =
            "FOLLOW INSTAGRAM"

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
            Color3.new(
                1,
                1,
                1
            )

        Instance.new(
            "UICorner",
            InstaBtn
        )

        AddRainbowStroke(
            InstaBtn
        )

        InstaBtn.MouseButton1Click:Connect(
            function()
                fSetClipboard(
                    Config.InstagramURL
                )

                Status.Text =
                    "Instagram Link Copied!"

                Status.TextColor3 =
                    Color3.fromRGB(
                        225,
                        48,
                        108
                    )
            end
        )

        currentYOffset =
            currentYOffset + 45
    end

    ------------------------------------------------------------
    -- YOUTUBE
    ------------------------------------------------------------

    if Config.ShowYoutube then
        local YTBtn =
            Instance.new(
                "TextButton",
                MainFrame
            )

        YTBtn.Size =
            UDim2.new(
                0.85,
                0,
                0,
                35
            )

        YTBtn.Position =
            UDim2.new(
                0.075,
                0,
                0,
                currentYOffset
            )

        YTBtn.Text =
            "SUBSCRIBE YOUTUBE"

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
            Color3.new(
                1,
                1,
                1
            )

        Instance.new(
            "UICorner",
            YTBtn
        )

        AddRainbowStroke(
            YTBtn
        )

        YTBtn.MouseButton1Click:Connect(
            function()
                fSetClipboard(
                    Config.YoutubeURL
                )

                Status.Text =
                    "YouTube Link Copied!"

                Status.TextColor3 =
                    Color3.fromRGB(
                        255,
                        0,
                        0
                    )
            end
        )

        currentYOffset =
            currentYOffset + 45
    end

    ------------------------------------------------------------
    -- KEY INPUT
    ------------------------------------------------------------

    local KeyInput =
        Instance.new(
            "TextBox",
            MainFrame
        )

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

    KeyInput.ClearTextOnFocus =
        false

    KeyInput.Font =
        Enum.Font.GothamSemibold

    KeyInput.TextSize = 14

    KeyInput.BackgroundColor3 =
        Color3.fromRGB(
            25,
            25,
            25
        )

    KeyInput.TextColor3 =
        Color3.new(
            1,
            1,
            1
        )

    Instance.new(
        "UICorner",
        KeyInput
    )

    ------------------------------------------------------------
    -- VERIFY BUTTON
    ------------------------------------------------------------

    local VerifyBtn =
        Instance.new(
            "TextButton",
            MainFrame
        )

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

    VerifyBtn.Text =
        "VERIFY"

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
        Color3.new(
            1,
            1,
            1
        )

    Instance.new(
        "UICorner",
        VerifyBtn
    )

    ------------------------------------------------------------
    -- GET KEY BUTTON
    ------------------------------------------------------------

    local GetKeyBtn =
        Instance.new(
            "TextButton",
            MainFrame
        )

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

    GetKeyBtn.Text =
        "GET KEY"

    GetKeyBtn.Font =
        Enum.Font.GothamBold

    GetKeyBtn.TextSize = 14

    GetKeyBtn.BackgroundColor3 =
        Color3.fromRGB(
            35,
            35,
            35
        )

    GetKeyBtn.TextColor3 =
        Color3.new(
            1,
            1,
            1
        )

    Instance.new(
        "UICorner",
        GetKeyBtn
    )

    ------------------------------------------------------------
    -- RESIZE
    ------------------------------------------------------------

    MainFrame.Size =
        UDim2.new(
            0,
            340,
            0,
            currentYOffset + 160
        )

    Status.Position =
        UDim2.new(
            0,
            0,
            0,
            currentYOffset + 115
        )

    ------------------------------------------------------------
    -- VERIFY
    ------------------------------------------------------------

    VerifyBtn.MouseButton1Click:Connect(
        function()
            local key =
                KeyInput.Text

            if key == ""
                or key:gsub("%s+", "") == ""
            then
                Status.Text =
                    "Enter a key!"

                Status.TextColor3 =
                    Color3.fromRGB(
                        255,
                        50,
                        50
                    )

                return
            end

            VerifyBtn.Active =
                false

            GetKeyBtn.Active =
                false

            Status.Text =
                "Verifying..."

            Status.TextColor3 =
                Color3.fromRGB(
                    150,
                    150,
                    150
                )

            local success, message =
                Verify(key)

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

                if ScreenGui.Parent then
                    ScreenGui:Destroy()
                end

                StartMainScript()
            else
                Status.Text =
                    tostring(message)

                Status.TextColor3 =
                    Color3.fromRGB(
                        255,
                        50,
                        50
                    )

                VerifyBtn.Active =
                    true

                GetKeyBtn.Active =
                    true
            end
        end
    )

    ------------------------------------------------------------
    -- GET KEY
    ------------------------------------------------------------

    GetKeyBtn.MouseButton1Click:Connect(
        function()
            GetKeyBtn.Active =
                false

            Status.Text =
                "Getting Link..."

            Status.TextColor3 =
                Color3.fromRGB(
                    150,
                    150,
                    150
                )

            local success, link =
                GetLink()

            if success then
                fSetClipboard(link)

                Status.Text =
                    "Link Copied!"

                Status.TextColor3 =
                    Color3.fromRGB(
                        0,
                        170,
                        255
                    )
            else
                Status.Text =
                    tostring(link)

                Status.TextColor3 =
                    Color3.fromRGB(
                        255,
                        100,
                        100
                    )
            end

            GetKeyBtn.Active =
                true
        end
    )

    ------------------------------------------------------------
    -- SAVED KEY
    --
    -- IMPORTANT:
    -- A saved key is NOT trusted locally.
    -- It must pass Platoboost Verify() again.
    ------------------------------------------------------------

    if isfile
        and isfile(
            Config.KeyFileName
        )
    then
        local savedKey =
            readfile(
                Config.KeyFileName
            )

        if savedKey
            and savedKey ~= ""
        then
            Status.Text =
                "Found saved key, verifying..."

            VerifyBtn.Active =
                false

            GetKeyBtn.Active =
                false

            task.spawn(
                function()
                    local success, message =
                        Verify(savedKey)

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

                        if ScreenGui.Parent then
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

                        VerifyBtn.Active =
                            true

                        GetKeyBtn.Active =
                            true
                    end
                end
            )
        end
    end
end

----------------------------------------------------------------
-- MAIN ENTRY
----------------------------------------------------------------

local player =
    game:GetService(
        "Players"
    ).LocalPlayer

local pGui =
    player:WaitForChild(
        "PlayerGui"
    )

----------------------------------------------------------------
-- IMPORTANT FIX
--
-- DO NOT DO THIS:
--
-- if pGui:FindFirstChild("KARINDERYA") then
--     StartMainScript()
--     return
-- end
--
-- An existing KARINDERYA must NEVER itself authenticate
-- the user.
----------------------------------------------------------------

if pGui:FindFirstChild(
    Config.MainGuiName
) then
    return
end

CreateGUI()
