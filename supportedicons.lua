local queryArg = ... 

local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local CoreGui = game:GetService("CoreGui")

local success, Icons = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/stewingit/RayfieldBuilder/refs/heads/main/icons.lua'))()
end)

if not success or not Icons then
    warn("Rayfield Icon Browser: Failed to load icons.")
    return
end

-- Shared Support Logic
local function checkSupport(typeId)
    local supportedIds = {1, 2, 11, 12, 13, 62}
    for _, id in ipairs(supportedIds) do
        if id == typeId then return true end
    end
    return false
end

-- Global Search Logic
getgenv().search = function(query)
    local results = {
        LucideExists = false,
        RobloxInfo = nil,
        Query = query,
        Status = "No results found"
    }
    
    -- 1. Check Lucide Library
    if Icons["48px"] and Icons["48px"][query] then
        results.LucideExists = true
        results.Status = "Lucide Icon Found: " .. query
    end

    -- 2. Check Roblox Asset ID
    local assetId = tonumber(query)
    if assetId then
        local s, info = pcall(function() 
            return MarketplaceService:GetProductInfo(assetId) 
        end)
        
        if s and info then
            local supported = checkSupport(info.AssetTypeId)
            results.RobloxInfo = {
                Name = info.Name,
                IsSupported = supported,
                AssetType = info.AssetTypeId
            }
            results.Status = string.format("Roblox Asset: %s | %s", info.Name, supported and "Supported" or "Not Supported")
        else
            results.Status = "Roblox Error: Asset ID not found"
        end
    end
    
    getgenv().LastSearch = results
    return results
end

-- HANDLE ARGUMENT MODE (Console/Script search)
if queryArg and type(queryArg) == "string" and queryArg ~= "" then
    local res = getgenv().search(queryArg)
    print("--- Icon Search Result ---")
    print(res.Status)
    return res 
end

-- UI CODE START
local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local Parent = (gethui and gethui()) or CoreGui or PlayerGui

if Parent:FindFirstChild("RayfieldIconBrowser") then
    Parent:FindFirstChild("RayfieldIconBrowser"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RayfieldIconBrowser"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Parent

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 520)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -40, 0, 40)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Icons Supported by Rayfield"
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, -30, 0, 30)
TabFrame.Position = UDim2.new(0, 15, 0, 45)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = MainFrame

local LucideBtn = Instance.new("TextButton")
LucideBtn.Size = UDim2.new(0.5, -5, 1, 0)
LucideBtn.Text = "Lucide Icons"
LucideBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
LucideBtn.TextColor3 = Color3.new(1, 1, 1)
LucideBtn.Font = Enum.Font.GothamBold
LucideBtn.Parent = TabFrame
Instance.new("UICorner").Parent = LucideBtn

local AssetBtn = Instance.new("TextButton")
AssetBtn.Size = UDim2.new(0.5, -5, 1, 0)
AssetBtn.Position = UDim2.new(0.5, 5, 0, 0)
AssetBtn.Text = "Roblox Asset Icons"
AssetBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
AssetBtn.TextColor3 = Color3.new(0.6, 0.6, 0.6)
AssetBtn.Font = Enum.Font.GothamBold
AssetBtn.Parent = TabFrame
Instance.new("UICorner").Parent = AssetBtn

local LucideSection = Instance.new("Frame")
LucideSection.Size = UDim2.new(1, 0, 1, -85)
LucideSection.Position = UDim2.new(0, 0, 0, 85)
LucideSection.BackgroundTransparency = 1
LucideSection.Parent = MainFrame

local AssetSection = Instance.new("Frame")
AssetSection.Size = UDim2.new(1, 0, 1, -85)
AssetSection.Position = UDim2.new(0, 0, 0, 85)
AssetSection.BackgroundTransparency = 1
AssetSection.Visible = false
AssetSection.Parent = MainFrame

local SearchBar = Instance.new("TextBox")
SearchBar.Size = UDim2.new(1, -30, 0, 35)
SearchBar.Position = UDim2.new(0, 15, 0, 5)
SearchBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SearchBar.PlaceholderText = "Search Lucide library..."
SearchBar.Text = ""
SearchBar.TextColor3 = Color3.new(1, 1, 1)
SearchBar.Font = Enum.Font.Gotham
SearchBar.Parent = LucideSection
Instance.new("UICorner").Parent = SearchBar

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -55)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 6
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.Parent = LucideSection

local UIGrid = Instance.new("UIGridLayout")
UIGrid.CellSize = UDim2.new(0, 65, 0, 85)
UIGrid.CellPadding = UDim2.new(0, 8, 0, 8)
UIGrid.SortOrder = Enum.SortOrder.Name
UIGrid.Parent = Scroll

local currentAssetId = ""

local IdInput = Instance.new("TextBox")
IdInput.Text = ""
IdInput.Name = "IdInput"
IdInput.Size = UDim2.new(1, -110, 0, 40)
IdInput.Position = UDim2.new(0, 15, 0, 5)
IdInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
IdInput.PlaceholderText = "Enter Asset ID..."
IdInput.TextColor3 = Color3.new(1, 1, 1)
IdInput.Font = Enum.Font.Gotham
IdInput.Parent = AssetSection
Instance.new("UICorner").Parent = IdInput

local AssetSearchBtn = Instance.new("TextButton")
AssetSearchBtn.Size = UDim2.new(0, 80, 0, 40)
AssetSearchBtn.Position = UDim2.new(1, -95, 0, 5)
AssetSearchBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
AssetSearchBtn.Text = "Search ID"
AssetSearchBtn.TextColor3 = Color3.new(1, 1, 1)
AssetSearchBtn.Font = Enum.Font.GothamBold
AssetSearchBtn.Parent = AssetSection
Instance.new("UICorner").Parent = AssetSearchBtn

local AssetPreview = Instance.new("ImageButton")
AssetPreview.Size = UDim2.new(0, 120, 0, 120)
AssetPreview.Position = UDim2.new(0.5, -60, 0, 55)
AssetPreview.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
AssetPreview.Image = "rbxassetid://0"
AssetPreview.ScaleType = Enum.ScaleType.Fit
AssetPreview.Parent = AssetSection
Instance.new("UICorner").Parent = AssetPreview

local PreviewLabel = Instance.new("TextLabel")
PreviewLabel.Size = UDim2.new(1, 0, 0, 20)
PreviewLabel.Position = UDim2.new(0, 0, 0, 175)
PreviewLabel.BackgroundTransparency = 1
PreviewLabel.Text = "Click image to copy ID"
PreviewLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
PreviewLabel.Font = Enum.Font.Gotham
PreviewLabel.TextSize = 12
PreviewLabel.Parent = AssetSection

local AssetScroll = Instance.new("ScrollingFrame")
AssetScroll.Size = UDim2.new(1, -30, 0, 185)
AssetScroll.Position = UDim2.new(0, 15, 0, 200)
AssetScroll.BackgroundTransparency = 0.95
AssetScroll.BackgroundColor3 = Color3.new(0,0,0)
AssetScroll.ScrollBarThickness = 4
AssetScroll.Parent = AssetSection

local AssetListLayout = Instance.new("UIListLayout")
AssetListLayout.Padding = UDim.new(0, 5)
AssetListLayout.Parent = AssetScroll

local function setAssetPreview(id)
    currentAssetId = tostring(id)
    AssetPreview.Image = "rbxthumb://type=Asset&id=" .. id .. "&w=420&h=420"
end

AssetPreview.MouseButton1Click:Connect(function()
    if currentAssetId ~= "" and currentAssetId ~= "0" then
        setclipboard(currentAssetId)
        local oldText = PreviewLabel.Text
        PreviewLabel.Text = "COPIED ID: " .. currentAssetId
        PreviewLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
        task.wait(1)
        PreviewLabel.Text = oldText
        PreviewLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end)

local function addAssetResult(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -5, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.TextWrapped = true
    btn.Parent = AssetScroll
    Instance.new("UICorner").Parent = btn
    return btn
end

AssetSearchBtn.MouseButton1Click:Connect(function()
    local query = IdInput.Text
    if query == "" then return end
    
    for _, v in pairs(AssetScroll:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end

    local loadingBtn = addAssetResult("Searching...")
    
    task.spawn(function()
        local data = getgenv().search(query)
        
        if data.RobloxInfo then
            setAssetPreview(query)
            loadingBtn.Text = "  " .. data.Status
            loadingBtn.TextColor3 = data.RobloxInfo.IsSupported and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 100, 100)
            loadingBtn.MouseButton1Click:Connect(function() setAssetPreview(query) end)
        elseif data.LucideExists then
            loadingBtn.Text = "  " .. data.Status
            loadingBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
        else
            loadingBtn.Text = "  " .. data.Status
            loadingBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
end)

-- Initialize Lucide Icons
for name, data in pairs(Icons["48px"]) do
    local btn = Instance.new("ImageButton")
    btn.Name = name
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.Parent = Scroll
    Instance.new("UICorner").Parent = btn

    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(0, 30, 0, 30)
    img.Position = UDim2.new(0.5, -15, 0.15, 0)
    img.BackgroundTransparency = 1
    img.Image = "rbxassetid://" .. data[1]
    img.ImageRectSize = Vector2.new(data[2][1], data[2][2])
    img.ImageRectOffset = Vector2.new(data[3][1], data[3][2])
    img.Parent = btn
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -4, 0, 30)
    label.Position = UDim2.new(0, 2, 1, -32)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    label.TextSize = 11
    label.Font = Enum.Font.GothamMedium
    label.TextWrapped = true
    label.Parent = btn

    btn.MouseButton1Click:Connect(function()
        setclipboard(name)
        label.Text = "COPIED"
        task.wait(0.7)
        label.Text = name
    end)
end

SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
    local query = SearchBar.Text:lower()
    for _, item in pairs(Scroll:GetChildren()) do
        if item:IsA("ImageButton") then
            item.Visible = (item.Name:lower():find(query, 1, true) ~= nil)
        end
    end
end)

LucideBtn.MouseButton1Click:Connect(function()
    LucideSection.Visible = true; AssetSection.Visible = false
    LucideBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45); AssetBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
end)

AssetBtn.MouseButton1Click:Connect(function()
    LucideSection.Visible = false; AssetSection.Visible = true
    AssetBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45); LucideBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
end)

AssetListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    AssetScroll.CanvasSize = UDim2.new(0, 0, 0, AssetListLayout.AbsoluteContentSize.Y)
end)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
