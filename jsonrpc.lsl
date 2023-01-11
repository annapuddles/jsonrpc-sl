string jsonrpc_request(string method, string params_type, list params, string id)
{
    if (id == NULL_KEY) id = (string) llGenerateKey();
    return llList2Json(JSON_OBJECT, ["jsonrpc", "2.0", "id", id, "method", method, "params", llList2Json(params_type, params)]);
}

string jsonrpc_notification(string method, string params_type, list params)
{
    return llList2Json(JSON_OBJECT, ["jsonrpc", "2.0", "method", method, "params", llList2Json(params_type, params)]);
}

string jsonrpc_response(string request, string result)
{
    string id = llJsonGetValue(request, ["id"]);
    return llList2Json(JSON_OBJECT, ["jsonrpc", "2.0", "id", id, "result", result]);
}

string jsonrpc_error(string request, integer code, string message, string data)
{
    string id = llJsonGetValue(request, ["id"]);
    return llList2Json(JSON_OBJECT, ["jsonrpc", "2.0", "id", id, "error", llList2Json(JSON_OBJECT, ["code", code, "message", message, "data", data])]);
}
