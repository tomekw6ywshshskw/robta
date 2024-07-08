local connection

function connectToDatabase()
    connection = dbConnect("mysql", "dbname=YOUR_DB_NAME;host=YOUR_DB_HOST", "YOUR_DB_USER", "YOUR_DB_PASSWORD", "share=1")
    if connection then
        outputDebugString("Connected to the database.")
    else
        outputDebugString("Failed to connect to the database.", 2)
    end
end
addEventHandler("onResourceStart", resourceRoot, connectToDatabase)

function dbQuery(query, ...)
    if not connection then
        connectToDatabase()
    end
    local handle = dbQuery(connection, query, ...)
    return handle
end

function dbPoll(handle, timeout)
    local result = dbPoll(handle, timeout)
    if result then
        return result
    else
        return {}
    end
end
