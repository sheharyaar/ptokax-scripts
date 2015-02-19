--[[

	This file is part of HiT Hi FiT Hai's PtokaX scripts

	Copyright: © 2014 HiT Hi FiT Hai group
	Licence: GNU General Public Licence v3 https://www.gnu.org/licenses/gpl-3.0.html

--]]

function OnStartup()
	local tConfig = {
		sBotName = SetMan.GetString( 21 ) or "PtokaX",
		sRequirePath = "external.restrict.",
		sHubAddress = SetMan.GetString( 2 ) or "localhost",
		sProtocol = "http://",
	}
	tList = {
		"chat",
		"share",
		"nicks",
		"search",
		"passive",
	}
	tConfig.sHubFAQ = tConfig.sProtocol..tConfig.sHubAddress.."/faq/%s/%04d"
	local function Error( sCode, iNum )
		return tConfig.sHubFAQ:format( sCode:upper(), iNum )
	end
	for iIndex, sScript in ipairs( tList ) do
		local r = require( tConfig.sRequirePath..sScript )
		tList[sScript] = r( tConfig.sBotName, Error )
	end
end

function ChatArrival( tUser, sMessage )
	return tList.chat( tUser, sMessage )
end

function UserConnected( tUser )
	tList.nicks( tUser )
	tList.passive( tUser )
end

function SearchArrival( tUser, sQuery )
	return tList.share( tUser, sQuery ) or tList.search( tUser, sQuery )
end

RegConnected, OpConnected = UserConnected, UserConnected
ConnectToMeArrival, MultiConnectToMeArrival, RevConnectToMeArrival = SearchArrival, SearchArrival, SearchArrival