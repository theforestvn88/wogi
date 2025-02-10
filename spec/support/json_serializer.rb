def json_data_at(index)
    index ? response_body["data"][index] : response_body["data"]
end

def json_attributes(attr, index: nil)
    json = json_data_at(index)
    json["attributes"]["#{attr}"]
end

def json_relationships(rel, index: nil)
    json = json_data_at(index)
    json["relationships"]["#{rel}"]["data"].with_indifferent_access
end

def json_included
    response_body["included"][0]["attributes"].with_indifferent_access
end
