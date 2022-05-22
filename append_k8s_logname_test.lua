local lu = require('luaunit')
local akl = require('append_k8s_logname')

TestAppendK8sLogname = {}
    function TestAppendK8sLogname:setUp()
        create_record = function(labels)
            return {
                kubernetes = {
                    pod_name = "test-server-75675f5897-7ci7o",
                    container_name = "envoy",
                    namespace_name = "test-ns",
                    labels = labels
                }
            }
        end
        self.create_record = create_record
        self.logname_key = "logging.googleapis.com/logName"
    end

    function TestAppendK8sLogname:testAppLabelExists()
        local record = self.create_record({ app = "app" })
        local _, _, got = akl.append_k8s_logname(nil, nil, record)
        lu.assertEquals(got[self.logname_key], "test-ns_app_envoy")
    end

    function TestAppendK8sLogname:testAppLabelNotExists()
        local record = self.create_record({ dummy = "dummy" })
        local _, _, got = akl.append_k8s_logname(nil, nil, record)
        lu.assertEquals(got[self.logname_key], "test-ns_test-server_envoy")
    end
-- end of table TestAppendK8sLogname

local runner = lu.LuaUnit.new()
runner:setOutputType("text")
os.exit( runner:runSuite() )