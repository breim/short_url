# app;serializers/link_serializer
class LinkSerializer < ActiveModel::Serializer
  attributes :id, :original_url, :short_url, :token, :created_at
end
