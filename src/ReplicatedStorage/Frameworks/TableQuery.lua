local TableQuery = {}

function TableQuery.query(tab)
    local q = {
        selects = nil;
        sort = nil;
        table = tab;
    }

    local function len(t)
        local l = 0
        for i, v in pairs(t) do
            l = l + 1
        end
        return l
    end

    function q:select(k, v)
        self.selects = {}
        self.selects[k] = v
    end

    function q:sort(f)
        self.sort = f
    end

    function q:find()
        local found = {}
        for k, v in pairs(self.table) do
            local add = false
            if self.selects == nil then
                add = true
            else
                local matches = 0
                for l, b in pairs(self.selects) do
                    if v[l] == b then
                        matches = matches + 1
                    end
                end
                add = matches == len(self.selects)
            end
            if add then
                found[k] = v
            end
        end
        if self.sort then
            table.sort(found, self.sort)
        end
        return found
    end

    return q
end

return TableQuery
