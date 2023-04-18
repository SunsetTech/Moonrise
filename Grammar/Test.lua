local URL = arg[1]


function prettyPrintTable(t, indent, path)
    indent = indent or 0
    path = path or ""
    for k, v in pairs(t) do
        local formattedKey
        if type(k) == "number" then
            formattedKey = "[" .. tostring(k) .. "]"
        else
            formattedKey = tostring(k)
        end
        local formattedPath = path ~= "" and (path .. (type(k) == "number" and "" or ".") .. formattedKey) or formattedKey

        if type(v) == "table" then
            print(string.rep(" ", indent) .. formattedPath .. " = {")
            prettyPrintTable(v, indent + 2, formattedPath)
            print(string.rep(" ", indent) .. "}")
        else
            print(string.rep(" ", indent) .. formattedPath .. " = " .. tostring(v))
        end
    end
end


unpack = unpack or table.unpack
table.unpack = table.unpack or unpack
require"Moonrise.Import.Install".All()
local Adapt = require"Moonrise.Adapt"

local URLGrammar = require"URL";
local Success, Result = Adapt.Process(URLGrammar, "Raise", Adapt.Stream.String(URL), nil)
print(Success)
prettyPrintTable(Result or {})
