local questions = {
    {question = "Co oznacza znak STOP?", options = {"Zatrzymaj się", "Jedź dalej", "Skręć w prawo"}, correct = 1},
    {question = "Jaka jest dopuszczalna prędkość w terenie zabudowanym?", options = {"50 km/h", "80 km/h", "100 km/h"}, correct = 1},
    -- Dodaj więcej pytań tutaj
}

local currentQuestionIndex = 1
local selectedOption = 0
local correctAnswers = 0
local showingQuestion = false

-- Funkcja wyświetlająca pytanie
function showQuestionToPlayer()
    showingQuestion = true
    addEventHandler("onClientRender", root, drawQuestion)
end
addEvent("startTheoryTest", true)
addEventHandler("startTheoryTest", root, showQuestionToPlayer)

-- Funkcja rysująca pytanie
function drawQuestion()
    local question = questions[currentQuestionIndex]
    local screenW, screenH = guiGetScreenSize()

    -- Rysowanie tła
    dxDrawRectangle(screenW * 0.25, screenH * 0.25, screenW * 0.5, screenH * 0.5, tocolor(0, 0, 0, 200))
    
    -- Rysowanie pytania
    dxDrawText(question.question, screenW * 0.26, screenH * 0.26, screenW * 0.74, screenH * 0.34, tocolor(255, 255, 255, 255), 1.2, "default-bold", "center", "center")

    -- Rysowanie opcji
    for i, option in ipairs(question.options) do
        local y = screenH * 0.35 + (i - 1) * 40
        local color = tocolor(255, 255, 255, 255)
        if i == selectedOption then
            color = tocolor(0, 255, 0, 255)
        end
        dxDrawText(option, screenW * 0.26, y, screenW * 0.74, y + 30, color, 1.0, "default-bold", "center", "center")
    end
end

-- Funkcja obsługująca wybór opcji
function selectOption(option)
    selectedOption = option
end

-- Funkcja przejścia do następnego pytania lub zakończenia testu
function nextQuestion()
    if selectedOption == questions[currentQuestionIndex].correct then
        correctAnswers = correctAnswers + 1
    end

    selectedOption = 0
    currentQuestionIndex = currentQuestionIndex + 1

    if currentQuestionIndex > #questions then
        -- Zakończ test
        removeEventHandler("onClientRender", root, drawQuestion)
        showingQuestion = false
        if correctAnswers >= 13 then
            outputChatBox("Zdałeś test teoretyczny!", 0, 255, 0)
            triggerEvent("startPracticalTest", resourceRoot, localPlayer)
        else
            outputChatBox("Nie zdałeś testu teoretycznego. Spróbuj ponownie.", 255, 0, 0)
        end
    else
        -- Pokaż kolejne pytanie
        showQuestionToPlayer()
    end
end

-- Obsługa klawiszy wyboru i zatwierdzania odpowiedzi
addEventHandler("onClientKey", root, function(button, press)
    if not showingQuestion then return end
    if button == "arrow_u" and press then
        if selectedOption > 1 then
            selectOption(selectedOption - 1)
        end
    elseif button == "arrow_d" and press then
        if selectedOption < #questions[currentQuestionIndex].options then
            selectOption(selectedOption + 1)
        end
    elseif button == "enter" and press then
        if selectedOption > 0 then
            nextQuestion()
        end
    end
end)
