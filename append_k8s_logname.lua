function append_k8s_logname(tag, timestamp, record)
    local new_record = record

    local app = record["kubernetes"]["labels"]["app"]
    if app == nil then
        local pod_name = record["kubernetes"]["pod_name"]
        _, _, app = string.find(pod_name, "([%w-]+)%-%w+%-%w+")
    end
    local namespace = record["kubernetes"]["namespace_name"]
    local container_name = record["kubernetes"]["container_name"]

    local log_name = string.format("%s_%s_%s", namespace, app, container_name)
    new_record["logging.googleapis.com/logName"] = log_name

    -- If code equals 2, means the original timestamp is not modified
    -- and the record has been modified so it must be replaced by the
    -- returned values from record (third return value).
    return 2, 0, new_record
end

-- It is needed to can be accessed by functions for testing
local M = {}
M.append_k8s_logname = append_k8s_logname
return M

-- https://www.lua.org/pil/20.1.html
-- string.findは返却値の1つ目にmatchが始まったindexと2つ目にmatchが終わったindexの返す
-- その後にcaptureした値を返していく

-- https://www.lua.org/pil/20.2.html
-- pattern matchingはPOSIX準拠ではない