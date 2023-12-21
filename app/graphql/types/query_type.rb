# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    field :categories, [Types::CategoryType]    
    def categories
      uri = URI("http://127.0.0.1:3000/categories")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.path, {'Content-Type'=>'application/json'})

      res = http.request(request)
      data = JSON.parse(res.body)
      
      if res.is_a?(Net::HTTPSuccess)
        data
      else
        nil
      end
    end
  end
end
