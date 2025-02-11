def response_body
    JSON.parse(response.body).with_indifferent_access
end

def sign_in(email, password)
    post user_session_path, params:  { email:, password: }.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
end

def extract_auth_params_from_sign_in_response_headers(response)
    response.headers.extract!(
        'access-token',
        'client',
        'uid',
        'expiry',
        'token-type'
    )
end
