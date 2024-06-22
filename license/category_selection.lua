local categories = {
    {name = "Kategoria A", price = 500},
    {name = "Kategoria B", price = 1000},
    {name = "Kategoria C", price = 1500},
    {name = "Kategoria C+E", price = 2000},
}

local selectedCategory = 0
local showingCategories = false

-- Funkcja wyświetlająca wybór kategorii
function showCategorySelection()
    showingCategories = true
    selectedCategory = 1
    addEventHandler("onClientRender", root, drawCategorySelection)
end
addEvent("showCategorySelection", true)
addEventHandler("showCategorySelection", root, showCategorySelection)

-- Funkcja rysująca wybór kategorii
function drawCategorySelection()
    local screenW, screenH = guiGetScreenSize()

    -- Rysowanie tła
    dxDrawRectangle(screenW * 0.25, screenH * 0.25, screenW * 0.5, screenH * 0.5, tocolor(0, 0, 0, 200))

    -- Rysowanie kategorii
    for i, category in ipairs(categories) do
        local y = screenH * 0.26 + (i - 1) * 40
        local color = tocolor(255, 255, 255, 255)
        if i == selectedCategory then
            color = tocolor(0, 255, 0, 255)
        end
        dxDrawText(category.name .. " - $" .. category.price, screenW * 0.26, y, screenW * 0.74, y + 30, color, 1.0, "default-bold", "center", "center")
    end
end

-- Funkcja obsługująca wybór kategorii
function selectCategory(category)
    selectedCategory = category
end

-- Funkcja obsługująca zakup kategorii
function purchaseCategory()
    if selectedCategory > 0 then
        local category = categories[selectedCategory]
        if getPlayerMoney(localPlayer) >= category.price then
            triggerServerEvent("takePlayerMoney", resourceRoot, category.price)
            outputChatBox("Kupiłeś " .. category.name .. " za $" .. category.price, 0, 255, 0)
            removeEventHandler("onClientRender", root, drawCategorySelection)
            showingCategories = false
            triggerEvent("startTheoryTest", resourceRoot, localPlayer)
        else
            outputChatBox("Nie masz wystarczająco dużo pieniędzy.", 255, 0, 0)
        end
    end
end

-- Obsługa klawiszy wyboru kategorii i zatwierdzania zakupu
addEventHandler("onClientKey", root, function(button, press)
    if not showingCategories then return end
    if button == "arrow_u" and press then
        if selectedCategory > 1 then
            selectCategory(selectedCategory - 1)
        end
    elseif button == "arrow_d" and press then
        if selectedCategory < #categories then
            selectCategory(selectedCategory + 1)
        end
    elseif button == "enter" and press then
        purchaseCategory()
    end
end)
