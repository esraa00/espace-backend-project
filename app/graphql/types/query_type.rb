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

    field :tags, [Types::TagType]
    def tags
      uri = URI("http://127.0.0.1:3000/tags")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.path, {'Content-Type'=>'application/json'})

      res = http.request(request)
      data = JSON.parse(res.body)
      
      if res.is_a?(Net::HTTPSuccess)
        data["tags"]
      else
        nil
      end
    end

    field :posts, [Types::PostType] do
      argument :page, Int, required: false , default_value: 1
    end
    def posts(page:)
      uri = URI("http://127.0.0.1:3000/posts/page/#{page}")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.path, {'Content-Type'=>'application/json'})

      res = http.request(request)
      data = JSON.parse(res.body)

      if res.is_a?(Net::HTTPSuccess)
        data["posts"]
      else
        nil
      end
    end

    field :post, Types::PostType do
      argument :id, ID, required: true
    end
    def post(id:)
      uri = URI("http://127.0.0.1:3000/posts/#{id}")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.path, {'Content-Type'=>'application/json'})

      res = http.request(request)
      data = JSON.parse(res.body)

      if res.is_a?(Net::HTTPSuccess)
        data["post"]
      else
        nil
      end
    end
  end
end

#TODO why any params I send from graphql, falls under the same name as the entity, such as post => { "name":"hell" }