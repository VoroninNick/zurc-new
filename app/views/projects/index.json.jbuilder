json.array!(@projects) do |project|
  json.extract! project, :id, :name, :url_fragment, :deadline_date
  json.url project_url(project, format: :json)
end
