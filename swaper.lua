WebBanking {
  version = 0.1,
  url = "https://www.swaper.com",
  services = { "Swaper" }
}

local connection

function SupportsBank (protocol, bankCode)
  return protocol == ProtocolWebBanking and bankCode == "Swaper"
end

function InitializeSession (protocol, bankCode, username, username2, password, username3)
  connection = Connection()
  content, charset, mimeType, filename, headers = connection:request("POST",
    "https://www.swaper.com/rest/public/login", '{"name":"' .. username .. '", "password":"' .. password .. '"}', "application/json;charset=UTF-8")
  local token = headers["_csrf"]
 headers = {accept = "application/json",Referer="https://www.swaper.com/"}
 headers["X-XSRF-TOKEN"]=token
 connection:request("GET","https://www.swaper.com/rest/public/logged-in","","",headers)
end

function ListAccounts (knownAccounts)
  -- Return array of accounts.
  local account = {
    name = "Swaper Account",
    owner = "",
    accountNumber = "1",
    bankCode = "1",
    currency = "EUR",
    type = AccountTypeGiro
  }
  return {account}
end


function RefreshAccount (account, since)
   local s = {}
  summary = AccountSummary()
 return {balance=tonumber(summary.accountValue) ,transactions={}}
end

function AccountSummary ()
  local content = connection:request(
    "GET",
    "https://www.swaper.com/rest/public/profile/overview",
    "",
    "application/x-www-form-urlencoded; charset=UTF-8",
    headers
  )
  return JSON(content):dictionary()
end

function EndSession ()
  connection:request("GET","https://www.swaper.com/rest/public/logout","","",headers)
  return nil
end
