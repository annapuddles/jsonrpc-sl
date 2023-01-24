/**
 * @file
 * @brief JSON-RPC helper functions for LSL.
 */

/**
 * Create a JSON object for a JSON-RPC request.
 * @param method The name of the JSON-RPC method to call.
 * @param params_type One of JSON_OBJECT or JSON_ARRAY, indicating how the parameters list should be interpreted.
 * @param params A list of parameters for the JSON-RPC method. If params_type is JSON_OBJECT, this should be a strided list of keys and values forming a named parameter list. If params_type is JSON_ARRAY, then this is a flat list of positional parameters.
 * @param id A unique ID for the request. If this is an empty string, an ID will be automatically generated.
 * @return The JSON-RPC request object as a string
 */
string jsonrpc_request(string method, string params_type, list params, string id)
{
    if (id == "") id = (string) llGenerateKey();
    return llList2Json(JSON_OBJECT, ["jsonrpc", "2.0", "id", id, "method", method, "params", llList2Json(params_type, params)]);
}

/**
 * Create a JSON object for a JSON-RPC notification (a request with no expected result).
 * @param method The name of the JSON-RPC method to call.
 * @param params_type One of JSON_OBJECT or JSON_ARRAY, indicating how the parameters list should be interpreted.
 * @param params A list of parameters for the JSON-RPC method. If params_type is JSON_OBJECT, this should be a strided list of keys and values forming a named parameter list. If params_type is JSON_ARRAY, then this is a flat list of positional parameters.
 * @return The JSON-RPC notification object as a string
 */
string jsonrpc_notification(string method, string params_type, list params)
{
    return llList2Json(JSON_OBJECT, ["jsonrpc", "2.0", "method", method, "params", llList2Json(params_type, params)]);
}

/**
 * Create a JSON-RPC response object based on a request object.
 * @param request The JSON-RPC request object to generate a response for.
 * @param result The result of the method call that will be returned to the caller.
 * @return The JSON-RPC response object as a string.
 */
string jsonrpc_response(string request, string result)
{
    string id = llJsonGetValue(request, ["id"]);
    return llList2Json(JSON_OBJECT, ["jsonrpc", "2.0", "id", id, "result", result]);
}

/**
 * Create a JSON-RPC error object based on a request object.
 * @param request The JSON-RPC request object to generate an error for.
 * @param code A numeric code for the error.
 * @param message A message describing the error.
 * @param data Any extra data to be included with the error.
 * @return The JSON-RPC error object as a string.
 */
string jsonrpc_error(string request, integer code, string message, string data)
{
    string id = llJsonGetValue(request, ["id"]);
    return llList2Json(JSON_OBJECT, ["jsonrpc", "2.0", "id", id, "error", llList2Json(JSON_OBJECT, ["code", code, "message", message, "data", data])]);
}

/**
 * Send a JSON-RPC request as a link message.
 * @param link The link number to send the message to.
 * @param method The name of the JSON-RPC method to call.
 * @param params_type One of JSON_OBJECT or JSON_ARRAY, indicating how the parameters list should be interpreted.
 * @param params A list of parameters for the JSON-RPC method. If params_type is JSON_OBJECT, this should be a strided list of keys and values forming a named parameter list. If params_type is JSON_ARRAY, then this is a flat list of positional parameters.
 * @param id A unique ID for the request. If this is an empty string, an ID will be automatically generated.
 * @return The ID of the JSON-RPC request (most useful when the id is automatically generated).
 */
string jsonrpc_link_request(integer link, string method, string params_type, list params, string id)
{
    if (id == "") id = (string) llGenerateKey();
    llMessageLinked(link, 0, jsonrpc_request(method, params_type, params, id), NULL_KEY);
    return id;
}

/**
 * Send a JSON-RPC notification as a link message.
 * @param link The link number to send the message to.
 * @param method The name of the JSON-RPC method to call.
 * @param params_type One of JSON_OBJECT or JSON_ARRAY, indicating how the parameters list should be interpreted.
 * @param params A list of parameters for the JSON-RPC method. If params_type is JSON_OBJECT, this should be a strided list of keys and values forming a named parameter list. If params_type is JSON_ARRAY, then this is a flat list of positional parameters.
 */
jsonrpc_link_notification(integer link, string method, string params_type, list params)
{
    llMessageLinked(link, 0, jsonrpc_notification(method, params_type, params), NULL_KEY);
}

/**
 * Send a JSON-RPC response as a link message.
 * @param link The link number to send the response to.
 * @param request The JSON-RPC request object to generate a response for.
 * @param result The result of the method call that will be returned to the caller.
 */
jsonrpc_link_response(integer link, string request, string result)
{
    llMessageLinked(link, 0, jsonrpc_response(request, result), NULL_KEY);
}

/**
 * Send a JSON-RPC error as a link message.
 * @param link The link number to send the error to.
 * @param request The JSON-RPC request object to generate an error for.
 * @param code A numeric code for the error.
 * @param message A message describing the error.
 * @param data Any extra data to be included with the error.
 */
jsonrpc_link_error(integer link, string request, integer code, string message, string data)
{
    llMessageLinked(link, 0, jsonrpc_error(request, code, message, data), NULL_KEY);
}
