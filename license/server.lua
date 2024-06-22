local db

-- Funkcja uruchamiająca bazę danych
function startDatabase()
    db = dbConnect("mysql", "dbname=your_db_name;host=your_host;port=your_port", "your_username", "your_password")
    if db then
        dbExec(db, "CREATE TABLE IF NOT EXISTS users (id INT AUTO_INCREMENT PRIMARY KEY, uid INT, category_a INT, category_b INT, category_c INT, category_ce INT)")
    else
        outputDebugString("Nie udało się połączyć z bazą danych.", 1)
    end
end
addEventHandler("onResourceStart", resourceRoot, startDatabase)

-- Funkcja pobierająca dane użytkownika
function getUserData(uid)
    local query = dbQuery(db, "SELECT * FROM users WHERE uid=?", uid)
    local result = dbPoll(query, -1)
    if result and #result > 0 then
        return result[1]
    else
        dbExec(db, "INSERT INTO users (uid, category_a, category_b, category_c, category_ce) VALUES (?, 0, 0, 0, 0)", uid)
        return {uid = uid, category_a = 0, category_b = 0, category_c = 0, category_ce = 0}
    end
end

-- Funkcja zapisująca prawo jazdy użytkownika
function saveUserLicense(uid, category)
    local userData = getUserData(uid)
    local column = "category_" .. category:lower()
    dbExec(db, "UPDATE users SET " .. column .. "=? WHERE uid=?", 1, uid)
end

-- Obsługa pobierania pieniędzy
addEvent("takePlayerMoney", true)
addEventHandler("takePlayerMoney", resourceRoot, function(amount)
    takePlayerMoney(client, amount)
end)

-- Obsługa przyznawania prawa jazdy
addEvent("givePlayerLicense", true)
addEventHandler("givePlayerLicense", resourceRoot, function()
    local uid = getElementData(client, "uid")
    saveUserLicense(uid, "B") -- Załóżmy, że zdają kategorię B, można to rozszerzyć na inne kategorie
end)

-- Funkcja ładująca dane gracza
function loadPlayerData()
    local uid = getElementData(source, "uid")
    local userData = getUserData(uid)
    setElementData(source, "category_a", userData.category_a)
    setElementData(source, "category_b", userData.category_b)
    setElementData(source, "category_c", userData.category_c)
    setElementData(source, "category_ce", userData.category_ce)
end
addEventHandler("onPlayerLogin", root, loadPlayerData)
